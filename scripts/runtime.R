read_runtime_lock <- function(root) {
  lock <- utils::read.delim(file.path(root, "runtime-lock.tsv"), colClasses = "character")
  if (!identical(names(lock), c("package", "version")) ||
      !identical(lock$package, c("ncfigR", "scfigR")) || anyNA(lock) ||
      any(!grepl("^[0-9]+[.][0-9]+[.][0-9]+$", lock$version))) {
    stop("Invalid runtime-lock.tsv: expected ncfigR and scfigR with exact release versions.")
  }
  for (i in seq_len(nrow(lock))) {
    description <- read.dcf(file.path(root, "packages", lock$package[i], "DESCRIPTION"))
    if (description[1, "Version"] != lock$version[i]) {
      stop("Repository version differs from runtime lock: ", lock$package[i], ". Update the release lock deliberately.")
    }
  }
  lock
}

validate_runtime_versions <- function(lock, actual) {
  if (!identical(unname(actual), unname(lock$version))) {
    stop("Runtime version mismatch. Required: ", paste(paste0(lock$package, "=", lock$version), collapse = ", "),
      "; loaded: ", paste(paste0(lock$package, "=", actual), collapse = ", "),
      ". Install the locked local packages; do not automatically upgrade dependencies.")
  }
}

activate_runtime <- function(root) {
  library <- file.path(root, ".r-library")
  if (dir.exists(library)) .libPaths(c(library, .libPaths()))
  lock <- read_runtime_lock(root)
  actual <- vapply(lock$package, function(pkg) {
    if (!requireNamespace(pkg, quietly = TRUE)) stop("Missing package: ", pkg, ". Run scripts/install_runtime.R first.")
    as.character(getNamespaceVersion(pkg))
  }, character(1))
  validate_runtime_versions(lock, actual)
  invisible(lock)
}
