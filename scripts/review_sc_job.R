args <- commandArgs(trailingOnly = TRUE)
if (identical(args, "--help")) {
  cat("Rscript scripts/review_sc_job.R --run run-directory --review review.json\n")
  quit(status = 0)
}
result <- tryCatch({
  full_args <- commandArgs(trailingOnly = FALSE)
  script <- gsub("~+~", " ", sub("^--file=", "", full_args[grepl("^--file=", full_args)][1]), fixed = TRUE)
  root <- dirname(dirname(normalizePath(script, winslash = "/", mustWork = TRUE)))
  source(file.path(root, "scripts", "runtime.R"))
  activate_runtime(root)
  if (length(args) != 4L || anyDuplicated(args[c(1, 3)]) || !setequal(args[c(1, 3)], c("--run", "--review"))) {
    stop("Use --run run-directory --review review.json.")
  }
  values <- stats::setNames(as.list(args[c(2, 4)]), args[c(1, 3)])
  scfigR::review_sc_job(values[["--run"]], values[["--review"]])
}, error = function(e) list(status = "failed", exit_code = 1L,
  errors = list(list(code = if (inherits(e, "sc_job_error")) e$code else "review_entrypoint_failed", message = conditionMessage(e))),
  next_action = "Read the review error; the previous task report is unchanged by this rejected review."))
if (requireNamespace("jsonlite", quietly = TRUE)) {
  cat(jsonlite::toJSON(result, auto_unbox = TRUE, null = "null"), "\n")
} else cat("{\"status\":\"failed\",\"exit_code\":1,\"message\":\"Install jsonlite and scfigR\"}\n")
quit(status = result$exit_code)
