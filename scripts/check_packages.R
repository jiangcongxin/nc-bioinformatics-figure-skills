development_packages <- c("rcmdcheck", "testthat", "knitr", "rmarkdown")
missing <- development_packages[!vapply(development_packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) {
  stop("Install development packages first: ", paste(missing, collapse = ", "))
}
if (!rmarkdown::pandoc_available()) stop("Pandoc is required to build the HTML vignettes.")
args <- commandArgs(trailingOnly = TRUE)
root <- normalizePath(if (length(args)) args[1] else ".", mustWork = TRUE)
library_dir <- tempfile("ncfig-check-library-")
dir.create(library_dir)
.libPaths(c(library_dir, .libPaths()))
Sys.setenv(R_LIBS = paste(.libPaths(), collapse = .Platform$path.sep),
           `_R_CHECK_FORCE_SUGGESTS_` = "false")
for (pkg in c("ncfigR", "scfigR")) {
  path <- file.path(root, "packages", pkg)
  utils::install.packages(path, repos = NULL, type = "source", lib = library_dir)
  rcmdcheck::rcmdcheck(path, args = "--no-manual", error_on = "warning")
}
message("Both packages passed checks, including examples, tests, and vignettes.")
