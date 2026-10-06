args <- commandArgs(trailingOnly = FALSE)
script <- gsub("~+~", " ", sub("^--file=", "", args[grepl("^--file=", args)][1]), fixed = TRUE)
root <- dirname(dirname(normalizePath(script, winslash = "/", mustWork = TRUE)))
source(file.path(root, "scripts", "runtime.R"))
activate_runtime(root)
output <- tempfile("communication cli "); dir.create(output)
invoke <- function(script, args) {
  stderr <- tempfile()
  lines <- suppressWarnings(system2(file.path(R.home("bin"), "Rscript"),
    c(shQuote(file.path(root, "scripts", script)), shQuote(args)), stdout = TRUE, stderr = stderr))
  code <- attr(lines, "status")
  if (is.null(code)) code <- 0L
  value <- jsonlite::fromJSON(paste(lines, collapse = "\n"), simplifyVector = FALSE)
  unlink(stderr)
  list(code = code, value = value)
}
run <- invoke("run_comm_job.R", c("--job", file.path(root, "examples/communication/task-example.json"), "--output", output))
stopifnot(run$code == 2L, run$value$status == "needs_review")
report <- jsonlite::read_json(run$value$report_path)
checks <- stats::setNames(lapply(seq_len(6), function(i) list(status = "revise",
  evidence = "Automated gate test only, not a visual inspection or deliverable approval.")),
  c("text_legibility", "label_overlap", "legend_consistency", "panel_layout", "color_scale", "biological_claims"))
review <- list(schema_version = "1.0", run_id = report$run_id, reviewer = "CLI protocol test",
  inspected_artifacts = unname(as.list(unlist(report$artifacts[c("png", "pdf")]))),
  final_size_mm = list(width = report$figure$width_mm, height = report$figure$height_mm), checks = checks)
path <- file.path(output, "review.json")
jsonlite::write_json(review, path, auto_unbox = TRUE)
decision <- invoke("review_comm_job.R", c("--run", run$value$run_dir, "--review", path))
stopifnot(decision$code == 2L, decision$value$status == "revise")
rejected <- invoke("review_comm_job.R", c("--run", run$value$run_dir, "--review", path))
stopifnot(rejected$code == 1L, rejected$value$status == "failed")
reproduced <- invoke("run_comm_job.R", c("--job", file.path(run$value$run_dir, "resolved_job.json")))
stopifnot(reproduced$code == 2L, reproduced$value$status == "needs_review")
failed <- invoke("run_comm_job.R", c("--job", file.path(output, "missing.json"), "--output", output))
stopifnot(failed$code == 1L, failed$value$status == "failed", file.exists(failed$value$report_path))
bad_args <- invoke("run_comm_job.R", c("--unknown", "x"))
stopifnot(bad_args$code == 1L, bad_args$value$status == "failed")
unlink(output, recursive = TRUE)
cat("Communication CLI: execution, frozen reproduction, review revision, terminal gate and failure JSON passed.\n")
