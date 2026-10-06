args <- commandArgs(trailingOnly = FALSE)
script <- gsub("~+~", " ", sub("^--file=", "", args[grepl("^--file=", args)][1]), fixed = TRUE)
root <- dirname(dirname(normalizePath(script, winslash = "/", mustWork = TRUE)))
source(file.path(root, "scripts", "runtime.R"))
if (length(commandArgs(trailingOnly = TRUE))) stop("Run without arguments; installation uses the project-local .r-library.")
lock <- read_runtime_lock(root)
if (any(lock$package %in% loadedNamespaces())) stop("Install in a fresh R process, before loading the task-runtime packages.")
library <- file.path(root, ".r-library")
dir.create(library, showWarnings = FALSE)
if (!dir.exists(library)) stop("Cannot create project-local library.")
.libPaths(c(library, .libPaths()))
Sys.setenv(R_LIBS = paste(.libPaths(), collapse = .Platform$path.sep))
for (pkg in lock$package) {
  status <- system2(file.path(R.home("bin"), "R"), c("CMD", "INSTALL",
    shQuote(paste0("--library=", library)), shQuote(file.path(root, "packages", pkg))))
  if (status != 0L) stop("Installation failed: ", pkg, ". Install its missing dependencies explicitly.")
  installed <- find.package(pkg, lib.loc = library, quiet = TRUE)
  if (!length(installed)) stop("Installation failed: ", pkg, ". Install its missing dependencies explicitly.")
  actual <- utils::packageDescription(pkg, lib.loc = library)$Version
  if (!identical(actual, lock$version[match(pkg, lock$package)])) stop("Installed version differs from the lock: ", pkg)
}
cat("Locked packages installed into", normalizePath(library, winslash = "/"), "\n")
cat("Next: Rscript scripts/check_runtime.R\n")
