args <- commandArgs(trailingOnly = TRUE)
if (identical(args, "--help")) {
  cat("Rscript scripts/run_sp_job.R --job task.json [--output directory]\n")
  quit(status = 0)
}
result <- tryCatch({
  full_args <- commandArgs(trailingOnly = FALSE)
  script <- gsub("~+~", " ", sub("^--file=", "", full_args[grepl("^--file=", full_args)][1]), fixed = TRUE)
  root <- dirname(dirname(normalizePath(script, winslash = "/", mustWork = TRUE)))
  source(file.path(root, "scripts", "runtime.R"))
  activate_runtime(root)
  if (!length(args) || length(args) %% 2L || anyDuplicated(args[seq(1, length(args), 2)])) stop("Use --job task.json [--output directory].")
  flags <- args[seq(1, length(args), 2)]
  if (any(!flags %in% c("--job", "--output")) || !"--job" %in% flags) stop("Use --job task.json [--output directory].")
  values <- stats::setNames(as.list(args[seq(2, length(args), 2)]), flags)
  spfigR::run_sp_job(values[["--job"]], output_dir = values[["--output"]])
}, error = function(e) list(status = "failed", exit_code = 1L,
  errors = list(list(code = "entrypoint_failed", message = conditionMessage(e))),
  next_action = "Correct installation or arguments; output-storage errors may prevent report creation."))
if (requireNamespace("jsonlite", quietly = TRUE)) cat(jsonlite::toJSON(result, auto_unbox = TRUE, null = "null"), "\n") else
  cat('{"status":"failed","exit_code":1,"message":"Install jsonlite"}\n')
quit(status = result$exit_code)
