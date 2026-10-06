suppressPackageStartupMessages({
  library(ncfigR)
  library(scfigR)
})

args <- commandArgs(trailingOnly = TRUE)
out_dir <- if (length(args)) args[1] else "examples/single-cell/output"
data <- load_sc_example()
figure <- do.call(compose_sc_atlas_figure, data)
manifest <- data.frame(
  source = "Bundled synthetic scfigR demonstration; not experimental data",
  package = "scfigR",
  version = as.character(utils::packageVersion("scfigR"))
)
paths <- export_figure_bundle(figure, "synthetic_atlas", out_dir,
  width = 9, height = 7, source_manifest = manifest)
print(paths)
