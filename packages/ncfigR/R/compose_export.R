compose_nc_figure <- function(panels, ncol = NULL, labels = "AUTO", title = NULL) {
  if (!is.list(panels) || length(panels) == 0) {
    stop("panels must be a non-empty list of ggplot objects.", call. = FALSE)
  }
  tag_levels <- if (identical(labels, "AUTO")) "A" else NULL
  patchwork::wrap_plots(panels, ncol = ncol) +
    patchwork::plot_annotation(title = title, tag_levels = tag_levels)
}

export_figure_bundle <- function(plot, basename, out_dir = "figures/exports",
                                 width = 7, height = 5,
                                 source_manifest = NULL) {
  dirs <- file.path(out_dir, c("pdf", "svg", "png"))
  for (d in dirs) {
    dir.create(d, recursive = TRUE, showWarnings = FALSE)
  }

  pdf_path <- file.path(out_dir, "pdf", paste0(basename, ".pdf"))
  svg_path <- file.path(out_dir, "svg", paste0(basename, ".svg"))
  png_path <- file.path(out_dir, "png", paste0(basename, ".png"))

  grDevices::pdf(pdf_path, width = width, height = height)
  print(plot)
  grDevices::dev.off()

  svglite::svglite(svg_path, width = width, height = height)
  print(plot)
  grDevices::dev.off()

  grDevices::png(png_path, width = width, height = height, units = "in", res = 300)
  print(plot)
  grDevices::dev.off()

  manifest_path <- NULL
  if (!is.null(source_manifest)) {
    manifest_path <- file.path(out_dir, paste0(basename, "_source_manifest.tsv"))
    readr::write_tsv(as.data.frame(source_manifest), manifest_path)
  }

  invisible(list(pdf = pdf_path, svg = svg_path, png = png_path, manifest = manifest_path))
}
