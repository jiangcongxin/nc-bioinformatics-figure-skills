job_fixture <- function() {
  root <- tempfile("job-test-"); dir.create(root)
  embedding <- data.frame(cell_id = c("001", "002", "003"), x = c(0, 1, 2), y = c(0, 2, 1),
    cell_type = c("T", "T", "B"), sample = "s1")
  expression <- expand.grid(cell_id = embedding$cell_id, feature = c("g1", "g2", "g3"), stringsAsFactors = FALSE)
  expression$value <- c(2, 1, 0, 0, 0, 3, 1, 1, 1)
  readr::write_tsv(embedding, file.path(root, "embedding.tsv"))
  readr::write_tsv(expression, file.path(root, "expression.tsv"))
  spec <- list(schema_version = "1.0", job_id = "test-atlas", task = "single_cell_atlas",
    inputs = list(embedding = "embedding.tsv", expression = "expression.tsv",
      expression_scale = "log_normalized", provenance = "Synthetic unit-test fixture; not experimental data"),
    figure = list(layout = "publication", feature_genes = as.list(c("g1", "g2", "g3"))), output_dir = "runs")
  path <- file.path(root, "task.json")
  jsonlite::write_json(spec, path, auto_unbox = TRUE)
  list(root = root, spec = spec, path = path)
}

review_fixture <- function(result, status = "pass") {
  report <- jsonlite::read_json(result$report_path, simplifyVector = FALSE)
  keys <- c("text_legibility", "label_overlap", "legend_consistency", "panel_layout", "color_scale", "biological_claims")
  checks <- stats::setNames(lapply(keys, function(key) list(status = status,
    evidence = paste("Unit-test protocol fixture, not actual visual certification:", key))), keys)
  review <- list(schema_version = "1.0", run_id = report$run_id, reviewer = "unit-test",
    inspected_artifacts = list(report$artifacts$png, report$artifacts$pdf),
    final_size_mm = list(width = report$figure$width_mm, height = report$figure$height_mm), checks = checks)
  path <- file.path(dirname(result$run_dir), "test-review.json")
  jsonlite::write_json(review, path, auto_unbox = TRUE)
  list(value = review, path = path)
}

test_that("valid execution freezes inputs and stops for actual visual review", {
  fixture <- job_fixture()
  originals <- tools::md5sum(file.path(fixture$root, c("embedding.tsv", "expression.tsv")))
  result <- run_sc_job(fixture$path)
  expect_identical(result$status, "needs_review")
  expect_identical(result$exit_code, 2L)
  report <- jsonlite::read_json(result$report_path)
  expect_equal(report$summary$cells, 3)
  expect_null(report$review)
  expect_true(all(vapply(report$artifact_checksums, function(x) file.exists(file.path(result$run_dir, x$path)), logical(1))))
  expect_true(file.exists(file.path(result$run_dir, "reproduce.R")))
  expect_identical(tools::md5sum(names(originals)), originals)
  saved <- readr::read_tsv(file.path(result$run_dir, "source-data/embedding.tsv"),
    col_types = readr::cols(cell_id = readr::col_character()))
  expect_identical(saved$cell_id, c("001", "002", "003"))
  second <- run_sc_job(file.path(result$run_dir, "resolved_job.json"))
  expect_identical(second$status, "needs_review")
  expect_false(identical(result$run_dir, second$run_dir))
})

test_that("grouped jobs export marker display data and reproduce the grouping", {
  fixture <- job_fixture()
  fixture$spec$figure$marker_groups <- list(First = list("g1", "g2"), Second = list("g3"))
  jsonlite::write_json(fixture$spec, fixture$path, auto_unbox = TRUE)
  result <- run_sc_job(fixture$path)
  expect_identical(result$status, "needs_review")
  plotted <- readr::read_tsv(file.path(result$run_dir, "source-data/marker-plot-data.tsv"), show_col_types = FALSE)
  source <- readr::read_tsv(file.path(result$run_dir, "source-data/markers.tsv"), show_col_types = FALSE)
  expect_equal(plotted$avg_expression, source$avg_expression)
  expect_equal(plotted$pct_expression, source$pct_expression)
  expect_true(all(c("marker_group", "plot_expression") %in% names(plotted)))
  expect_setequal(plotted$marker_group, c("First", "Second"))
  second <- run_sc_job(file.path(result$run_dir, "resolved_job.json"))
  expect_identical(second$status, "needs_review")
  fixture$spec$figure$marker_groups <- list(First = list("g1", "g2"))
  jsonlite::write_json(fixture$spec, fixture$path, auto_unbox = TRUE)
  expect_identical(run_sc_job(fixture$path)$status, "failed")
})

test_that("bad scientific data produce reports without silent repairs", {
  fixture <- job_fixture()
  data <- job_read_table(file.path(fixture$root, "expression.tsv"), expression = TRUE)
  readr::write_tsv(data[-1, ], file.path(fixture$root, "expression.tsv"))
  result <- run_sc_job(fixture$path)
  expect_identical(result$status, "failed")
  expect_identical(result$exit_code, 1L)
  expect_match(result$errors[[1]]$message, "every cell-feature")
  expect_true(file.exists(result$report_path))
  expect_false(dir.exists(file.path(result$run_dir, "figures")))
  expect_equal(nrow(job_read_table(file.path(fixture$root, "expression.tsv"), expression = TRUE)), 8)
})

test_that("configuration and parser failures are actionable", {
  fixture <- job_fixture()
  fixture$spec$inputs$expression_scale <- "unknown"
  jsonlite::write_json(fixture$spec, fixture$path, auto_unbox = TRUE)
  result <- run_sc_job(fixture$path)
  expect_identical(result$errors[[1]]$code, "expression_scale_unconfirmed")
  expect_identical(result$errors[[1]]$retry_policy, "requires_confirmation")
  fixture$spec$inputs$expression_scale <- "log_normalized"
  fixture$spec$figure$typo <- TRUE
  jsonlite::write_json(fixture$spec, fixture$path, auto_unbox = TRUE)
  expect_identical(run_sc_job(fixture$path)$errors[[1]]$code, "invalid_spec")
  fixture$spec$figure$typo <- NULL
  fixture$spec$output_dir <- 123
  jsonlite::write_json(fixture$spec, fixture$path, auto_unbox = TRUE)
  expect_identical(run_sc_job(fixture$path)$errors[[1]]$code, "invalid_spec")
  writeLines("{broken", fixture$path)
  expect_identical(run_sc_job(fixture$path)$errors[[1]]$code, "invalid_json")
  expect_identical(run_sc_job(file.path(fixture$root, "absent.json"))$errors[[1]]$code, "invalid_json")
})

test_that("table parsing failures remain structured and do not discard rows", {
  fixture <- job_fixture()
  data <- job_read_table(file.path(fixture$root, "expression.tsv"), expression = TRUE)
  data$value <- as.character(data$value); data$value[1] <- "not-a-number"
  readr::write_tsv(data, file.path(fixture$root, "expression.tsv"))
  result <- run_sc_job(fixture$path)
  expect_identical(result$errors[[1]]$code, "parse_error")
  expect_identical(result$status, "failed")
})

test_that("source paths resolve relative to the specification, not working directory", {
  fixture <- job_fixture()
  old <- getwd(); on.exit(setwd(old), add = TRUE)
  setwd(tempdir())
  result <- run_sc_job(fixture$path)
  expect_identical(result$status, "needs_review")
  expect_true(startsWith(result$run_dir, normalizePath(fixture$root, winslash = "/")))
})

test_that("review is evidence-backed, run-bound, and cannot approve changed artifacts", {
  fixture <- job_fixture()
  result <- run_sc_job(fixture$path)
  review <- review_fixture(result)
  review$value$run_id <- "wrong-run"
  jsonlite::write_json(review$value, review$path, auto_unbox = TRUE)
  expect_error(review_sc_job(result$run_dir, review$path), "does not match")
  review <- review_fixture(result)
  review$value$checks$text_legibility$evidence <- "TODO"
  jsonlite::write_json(review$value, review$path, auto_unbox = TRUE)
  expect_error(review_sc_job(result$run_dir, review$path), "concrete observation")
  review <- review_fixture(result, status = "revise")
  revised <- review_sc_job(result$run_dir, review$path)
  expect_identical(revised$status, "revise")
  expect_identical(revised$exit_code, 2L)
  review <- review_fixture(result)
  expect_error(review_sc_job(result$run_dir, review$path), "awaiting review")
  fixture$spec$figure$width_mm <- 200
  jsonlite::write_json(fixture$spec, fixture$path, auto_unbox = TRUE)
  corrected <- run_sc_job(fixture$path)
  review <- review_fixture(corrected)
  approved <- review_sc_job(corrected$run_dir, review$path)
  expect_identical(approved$status, "passed")
  expect_identical(approved$exit_code, 0L)
  expect_error(review_sc_job(corrected$run_dir, review$path), "awaiting review")
  second <- run_sc_job(fixture$path)
  review <- review_fixture(second)
  report <- jsonlite::read_json(second$report_path)
  writeLines("changed", file.path(second$run_dir, report$artifacts$png))
  expect_error(review_sc_job(second$run_dir, review$path), "changed since execution")
  expect_identical(jsonlite::read_json(second$report_path)$status, "needs_review")
})

test_that("failed runs and uninspected vector artifacts cannot pass review", {
  fixture <- job_fixture()
  result <- run_sc_job(fixture$path)
  review <- review_fixture(result)
  review$value$inspected_artifacts <- review$value$inspected_artifacts[1]
  jsonlite::write_json(review$value, review$path, auto_unbox = TRUE)
  expect_error(review_sc_job(result$run_dir, review$path), "PNG and at least one vector")
  fixture$spec$inputs$expression <- "absent.tsv"
  jsonlite::write_json(fixture$spec, fixture$path, auto_unbox = TRUE)
  failed <- run_sc_job(fixture$path)
  expect_error(review_sc_job(failed$run_dir, review$path), "awaiting review")
})
