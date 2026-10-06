args <- commandArgs(trailingOnly = FALSE)
script <- gsub("~+~", " ", sub("^--file=", "", args[grepl("^--file=", args)][1]), fixed = TRUE)
root <- dirname(dirname(normalizePath(script, winslash = "/", mustWork = TRUE)))
source(file.path(root, "scripts", "runtime.R"))
result <- tryCatch({
  lock <- activate_runtime(root)
  dependencies <- unique(unlist(lapply(lock$package, function(pkg) {
    fields <- utils::packageDescription(pkg)[c("Imports", "Depends")]
    values <- unlist(fields, use.names = FALSE)
    parts <- trimws(unlist(strsplit(values, ",", fixed = TRUE)))
    trimws(sub("\\s*\\(.*$", "", parts))
  })))
  dependencies <- setdiff(dependencies, c("R", lock$package))
  versions <- stats::setNames(vapply(dependencies, function(pkg) as.character(utils::packageVersion(pkg)), character(1)), dependencies)
  list(status = "ready", exit_code = 0L, R = R.version.string, platform = R.version$platform,
    packages = lapply(seq_len(nrow(lock)), function(i) list(package = lock$package[i], version = lock$version[i],
      library = dirname(getNamespaceInfo(lock$package[i], "path")))),
    dependency_versions = as.list(versions),
    scope = "Exact versions for ncfigR/scfigR; third-party dependency versions are recorded, not fully locked.")
}, error = function(e) list(status = "failed", exit_code = 1L, message = conditionMessage(e)))
if (requireNamespace("jsonlite", quietly = TRUE)) cat(jsonlite::toJSON(result, auto_unbox = TRUE, pretty = TRUE), "\n") else {
  cat("Runtime check failed: install jsonlite and the required package dependencies.\n")
  quit(status = 1L)
}
quit(status = result$exit_code)
