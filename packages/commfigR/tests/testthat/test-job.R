comm_job_fixture <- function() {
  directory <- tempfile("comm-job-"); dir.create(directory)
  file.copy(system.file("extdata/lr_pairs.tsv", package = "commfigR"), file.path(directory, "input.tsv"))
  spec <- list(schema_version = "1.0", task = "communication_overview", job_id = "test",
    inputs = list(table = "input.tsv", format = "canonical", provenance = "Synthetic unit-test data",
      score_definition = "Synthetic score", p_value_definition = "Synthetic p-value"),
    figure = list(width_mm = 183, height_mm = 220, top_n = 3), output_dir = "runs")
  path <- file.path(directory, "task.json")
  jsonlite::write_json(spec, path, auto_unbox = TRUE)
  list(path = path, spec = spec, directory = directory)
}

comm_review_fixture <- function(run, status = "pass") {
  report <- jsonlite::read_json(run$report_path)
  checks <- stats::setNames(lapply(seq_len(6), function(i) list(status = status,
    evidence = "Automated fixture evidence for gate testing only; not actual visual inspection.")),
    c("text_legibility", "label_overlap", "legend_consistency", "panel_layout", "color_scale", "biological_claims"))
  value <- list(schema_version = "1.0", run_id = report$run_id, reviewer = "unit-test (not human review)",
    inspected_artifacts = unname(as.list(unlist(report$artifacts[c("png", "pdf")]))),
    final_size_mm = list(width = report$figure$width_mm, height = report$figure$height_mm), checks = checks)
  path <- file.path(dirname(run$run_dir), "test-review.json")
  jsonlite::write_json(value, path, auto_unbox = TRUE)
  list(path = path, value = value)
}

test_that("tasks freeze inputs, reproduce, and require evidence-backed review", {
  fixture <- comm_job_fixture()
  on.exit(unlink(fixture$directory, recursive = TRUE))
  run <- run_comm_job(fixture$path)
  expect_identical(run$status, "needs_review")
  expect_identical(run$exit_code, 2L)
  report <- jsonlite::read_json(run$report_path)
  expect_null(report$review)
  expect_length(report$errors, 0)
  expect_true(all(c("network_top_n", "max_pairs") %in% names(report$figure)))
  displayed_edges <- readr::read_tsv(file.path(run$run_dir, "source-data/network_edges.tsv"), show_col_types = FALSE)
  expect_true(all(table(displayed_edges$condition) <= report$figure$network_top_n))
  expect_true(all(file.exists(file.path(run$run_dir, unlist(report$artifacts)))))
  expect_true(file.exists(file.path(run$run_dir, "methods.md")))
  second <- run_comm_job(file.path(run$run_dir, "resolved_job.json"))
  expect_identical(second$status, "needs_review")
  expect_false(identical(second$run_dir, run$run_dir))
  expect_equal(readr::read_tsv(file.path(run$run_dir, "source-data/edges.tsv"), show_col_types = FALSE),
    readr::read_tsv(file.path(second$run_dir, "source-data/edges.tsv"), show_col_types = FALSE))
  review <- comm_review_fixture(run)
  review$value$run_id <- "wrong"
  jsonlite::write_json(review$value, review$path, auto_unbox = TRUE)
  expect_error(review_comm_job(run$run_dir, review$path), "does not match")
  review <- comm_review_fixture(run)
  review$value$inspected_artifacts <- review$value$inspected_artifacts[1]
  jsonlite::write_json(review$value, review$path, auto_unbox = TRUE)
  expect_error(review_comm_job(run$run_dir, review$path), "at least one vector")
  review <- comm_review_fixture(run)
  review$value$checks$text_legibility$evidence <- "TODO"
  jsonlite::write_json(review$value, review$path, auto_unbox = TRUE)
  expect_error(review_comm_job(run$run_dir, review$path), "concrete observation")
  review <- comm_review_fixture(run, "revise")
  expect_identical(review_comm_job(run$run_dir, review$path)$status, "revise")
  expect_error(review_comm_job(run$run_dir, review$path), "awaiting review")
  review <- comm_review_fixture(second)
  expect_identical(review_comm_job(second$run_dir, review$path)$status, "passed")
  expect_error(review_comm_job(second$run_dir, review$path), "awaiting review")
})

test_that("invalid task inputs produce failed reports, not partial successes", {
  fixture <- comm_job_fixture()
  on.exit(unlink(fixture$directory, recursive = TRUE))
  fixture$spec$figure$unknown_parameter <- TRUE
  jsonlite::write_json(fixture$spec, fixture$path, auto_unbox = TRUE)
  run <- run_comm_job(fixture$path)
  expect_identical(run$status, "failed")
  expect_identical(run$errors[[1]]$code, "invalid_spec")
  expect_identical(run$exit_code, 1L)
  fixture$spec$figure$unknown_parameter <- NULL
  fixture$spec$inputs$table <- "absent.tsv"
  jsonlite::write_json(fixture$spec, fixture$path, auto_unbox = TRUE)
  run <- run_comm_job(fixture$path)
  expect_identical(run$errors[[1]]$code, "input_missing")
  expect_error(review_comm_job(run$run_dir, "absent.json"), "awaiting review")
})

test_that("changed frozen files cannot be approved", {
  fixture <- comm_job_fixture()
  on.exit(unlink(fixture$directory, recursive = TRUE))
  run <- run_comm_job(fixture$path)
  review <- comm_review_fixture(run)
  writeLines("changed", file.path(run$run_dir, "methods.md"))
  expect_error(review_comm_job(run$run_dir, review$path), "changed since execution")
  expect_identical(jsonlite::read_json(run$report_path)$status, "needs_review")
})

test_that("CSV parsing preserves labels and fails on malformed numeric fields", {
  path <- tempfile(fileext = ".csv")
  on.exit(unlink(path))
  writeLines(c("source,target,ligand,receptor,score,p_value", '001,002,"L,complex",R,0.2,0'), path)
  x <- comm_read(path)
  expect_identical(x$source, "001")
  expect_identical(x$ligand, "L,complex")
  writeLines(c("source,target,ligand,receptor,score", "001,002,L,R,nope"), path)
  expect_error(comm_read(path), "Invalid numeric")
})

test_that("CellChat CSV tasks adapt scores without altering upstream labels", {
  fixture <- comm_job_fixture()
  on.exit(unlink(fixture$directory, recursive = TRUE))
  input <- data.frame(source = "001", target = "002", ligand = "L", receptor = "R_COMPLEX",
    prob = 0.2, pval = 0.01, interaction_name = "L_R_COMPLEX")
  readr::write_csv(input, file.path(fixture$directory, "cellchat.csv"))
  fixture$spec$inputs$table <- "cellchat.csv"
  fixture$spec$inputs$format <- "cellchat"
  jsonlite::write_json(fixture$spec, fixture$path, auto_unbox = TRUE)
  failed <- run_comm_job(fixture$path)
  expect_identical(failed$errors[[1]]$code, "condition_unconfirmed")
  fixture$spec$inputs$condition <- "LS"
  jsonlite::write_json(fixture$spec, fixture$path, auto_unbox = TRUE)
  run <- run_comm_job(fixture$path)
  expect_identical(run$status, "needs_review")
  table <- readr::read_tsv(file.path(run$run_dir, "source-data/input.tsv"),
    col_types = readr::cols(source = readr::col_character(), target = readr::col_character()))
  expect_identical(table$source, "001")
  expect_equal(table$score, input$prob)
  expect_identical(table$receptor, "R_COMPLEX")
  expect_equal(table$p_value, input$pval)
  expect_identical(table$condition, "LS")
})
