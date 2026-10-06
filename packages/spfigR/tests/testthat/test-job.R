sp_job_fixture <- function() {
  directory <- tempfile("sp-job-"); dir.create(directory)
  for (name in c("coordinates", "features")) file.copy(system.file(paste0("extdata/overview_", name, ".tsv"), package = "spfigR"), file.path(directory, paste0(name, ".tsv")))
  spec <- list(schema_version = "1.0", task = "spatial_overview", job_id = "test",
    inputs = list(coordinates = "coordinates.tsv", features = "features.tsv", expression_scale = "log_normalized",
      coordinate_unit = "arbitrary", y_axis = "up", provenance = "Synthetic task test, not biological evidence"),
    figure = list(point_size = 1), output_dir = "runs")
  path <- file.path(directory, "task.json"); jsonlite::write_json(spec, path, auto_unbox = TRUE)
  list(path = path, spec = spec, directory = directory)
}

sp_review_fixture <- function(run, status = "pass") {
  report <- jsonlite::read_json(run$report_path)
  checks <- stats::setNames(lapply(seq_len(6), function(i) list(status = status,
    evidence = "Automated protocol fixture; this is not an actual visual approval.")),
    c("text_legibility", "label_overlap", "legend_consistency", "panel_layout", "color_scale", "biological_claims"))
  value <- list(schema_version = "1.0", run_id = report$run_id, reviewer = "unit-test fixture",
    inspected_artifacts = unname(as.list(unlist(report$artifacts[c("png", "pdf")]))),
    final_size_mm = list(width = report$figure$width_mm, height = report$figure$height_mm), checks = checks)
  path <- file.path(dirname(run$run_dir), "review.json"); jsonlite::write_json(value, path, auto_unbox = TRUE)
  list(value = value, path = path)
}

test_that("spatial tasks freeze inputs, preserve barcode strings and reproduce", {
  x <- sp_job_fixture(); on.exit(unlink(x$directory, recursive = TRUE))
  run <- run_sp_job(x$path)
  expect_identical(run$status, "needs_review")
  report <- jsonlite::read_json(run$report_path)
  expect_null(report$review)
  expect_equal(report$summary$spots, 8)
  expect_true(all(file.exists(file.path(run$run_dir, unlist(report$artifacts)))))
  second <- run_sp_job(file.path(run$run_dir, "resolved_job.json"))
  expect_identical(second$status, "needs_review")
  expect_false(identical(second$run_dir, run$run_dir))
  expect_identical(unname(tools::md5sum(file.path(run$run_dir, "source-data/coordinates.tsv"))),
    unname(tools::md5sum(file.path(second$run_dir, "source-data/coordinates.tsv"))))
  review <- sp_review_fixture(run, "revise")
  expect_identical(review_sp_job(run$run_dir, review$path)$status, "revise")
  expect_error(review_sp_job(run$run_dir, review$path), "awaiting review")
  review <- sp_review_fixture(second)
  review$value$final_size_mm$width <- 100
  jsonlite::write_json(review$value, review$path, auto_unbox = TRUE)
  expect_error(review_sp_job(second$run_dir, review$path), "configured final")
  review <- sp_review_fixture(second)
  expect_identical(review_sp_job(second$run_dir, review$path)$status, "passed")
  expect_error(review_sp_job(second$run_dir, review$path), "awaiting review")
})

test_that("bad configuration and coverage fail with reports", {
  x <- sp_job_fixture(); on.exit(unlink(x$directory, recursive = TRUE))
  x$spec$inputs$coordinate_unit <- "unknown"
  jsonlite::write_json(x$spec, x$path, auto_unbox = TRUE)
  expect_identical(run_sp_job(x$path)$errors[[1]]$code, "unconfirmed_scale")
  x$spec$inputs$coordinate_unit <- "pixel"
  x$spec$figure$unknown <- TRUE
  jsonlite::write_json(x$spec, x$path, auto_unbox = TRUE)
  expect_identical(run_sp_job(x$path)$errors[[1]]$code, "invalid_spec")
  x$spec$figure$unknown <- NULL
  jsonlite::write_json(x$spec, x$path, auto_unbox = TRUE)
  data <- readr::read_tsv(file.path(x$directory, "features.tsv"), show_col_types = FALSE)
  readr::write_tsv(data[-1, ], file.path(x$directory, "features.tsv"))
  failed <- run_sp_job(x$path)
  expect_identical(failed$status, "failed")
  expect_true(file.exists(failed$report_path))
  expect_error(review_sp_job(failed$run_dir, "missing.json"), "awaiting review")
})

test_that("changed frozen inputs and wrong task reviews cannot be approved", {
  x <- sp_job_fixture(); on.exit(unlink(x$directory, recursive = TRUE))
  run <- run_sp_job(x$path); review <- sp_review_fixture(run)
  expect_error(ncfigR::review_figure_job(run$run_dir, review$path, "communication_overview"), "Task does not match")
  writeLines("changed", file.path(run$run_dir, "source-data/features.tsv"))
  expect_error(review_sp_job(run$run_dir, review$path), "changed since execution")
  expect_identical(jsonlite::read_json(run$report_path)$status, "needs_review")
})
