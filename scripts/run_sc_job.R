args <- commandArgs(trailingOnly = TRUE)
if (identical(args, "--help")) {
  cat("Rscript scripts/run_sc_job.R --job task.json [--output output-directory]\n")
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
  if (!requireNamespace("scfigR", quietly = TRUE) || !"run_sc_job" %in% getNamespaceExports("scfigR")) {
    stop("Install the current packages/ncfigR and packages/scfigR before calling this entry point.")
  }
  scfigR::run_sc_job(values[["--job"]], output_dir = values[["--output"]])
}, error = function(e) list(status = "failed", exit_code = 1L,
  errors = list(list(code = "entrypoint_failed", message = conditionMessage(e))),
  next_action = "Fix the entry-point arguments or installation; no report is guaranteed when output storage is unavailable."))
if (requireNamespace("jsonlite", quietly = TRUE)) {
  cat(jsonlite::toJSON(result, auto_unbox = TRUE, null = "null"), "\n")
} else cat("{\"status\":\"failed\",\"exit_code\":1,\"message\":\"Install jsonlite and scfigR\"}\n")
quit(status = result$exit_code)
