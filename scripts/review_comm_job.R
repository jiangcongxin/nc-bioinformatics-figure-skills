args <- commandArgs(trailingOnly = TRUE)
if (identical(args, "--help")) {
  cat("Rscript scripts/review_comm_job.R --run directory --review review.json\n")
  quit(status = 0)
}
result <- tryCatch({
  full_args <- commandArgs(trailingOnly = FALSE)
  script <- gsub("~+~", " ", sub("^--file=", "", full_args[grepl("^--file=", full_args)][1]), fixed = TRUE)
  root <- dirname(dirname(normalizePath(script, winslash = "/", mustWork = TRUE)))
  source(file.path(root, "scripts", "runtime.R"))
  activate_runtime(root)
  if (length(args) != 4L || anyDuplicated(args[c(1, 3)]) || !setequal(args[c(1, 3)], c("--run", "--review"))) stop("Use --run directory --review review.json.")
  values <- stats::setNames(as.list(args[c(2, 4)]), args[c(1, 3)])
  commfigR::review_comm_job(values[["--run"]], values[["--review"]])
}, error = function(e) list(status = "failed", exit_code = 1L,
  errors = list(list(code = if (inherits(e, "figure_review_error")) e$code else "review_entrypoint_failed", message = conditionMessage(e))),
  next_action = "Inspect review errors; a rejected review does not change the prior task report."))
if (requireNamespace("jsonlite", quietly = TRUE)) cat(jsonlite::toJSON(result, auto_unbox = TRUE, null = "null"), "\n") else
  cat('{"status":"failed","exit_code":1,"message":"Install jsonlite"}\n')
quit(status = result$exit_code)
