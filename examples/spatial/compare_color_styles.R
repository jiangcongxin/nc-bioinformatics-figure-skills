args <- commandArgs(trailingOnly = FALSE)
script <- gsub("~+~", " ", sub("^--file=", "", args[grepl("^--file=", args)][1]), fixed = TRUE)
directory <- dirname(normalizePath(script, winslash = "/", mustWork = TRUE))
root <- dirname(dirname(directory))
source(file.path(root, "scripts", "runtime.R")); activate_runtime(root)
template <- jsonlite::read_json(file.path(directory, "task-mouse-cortex.json"))
for (name in c("coordinates", "features", "regions")) {
  template$inputs[[name]] <- normalizePath(file.path(directory, template$inputs[[name]]), mustWork = TRUE)
}
output <- file.path(directory, "job-runs", "color-comparison")
dir.create(output, recursive = TRUE, showWarnings = FALSE)
coordinates <- readr::read_tsv(template$inputs$coordinates,
  col_types = readr::cols(.default = readr::col_character(), x = readr::col_double(), y = readr::col_double()))
features <- readr::read_tsv(template$inputs$features,
  col_types = readr::cols(.default = readr::col_character(), value = readr::col_double()))
maps <- list(); swatches <- list(); results <- list()
for (style in spfigR::sp_color_styles()$style) {
  spec <- template; spec$job_id <- paste0("mouse-cortex-", style)
  spec$figure$color_style <- style; spec$output_dir <- output
  path <- file.path(output, paste0(style, ".json"))
  jsonlite::write_json(spec, path, auto_unbox = TRUE, pretty = TRUE)
  run <- spfigR::run_sp_job(path)
  if (run$status != "needs_review") stop("Style failed: ", style, " ", run$report_path)
  results[[style]] <- run
  display <- spfigR::compose_spatial_overview(coordinates, features,
    expression_scale = template$inputs$expression_scale, coordinate_unit = "pixel", y_axis = "down",
    feature_order = unlist(template$figure$feature_order), point_size = 0.9,
    color_style = style, data.out = TRUE)
  maps[[length(maps) + 1L]] <- display$plot[[1]] + ggplot2::labs(title = paste(style, "| annotations"))
  maps[[length(maps) + 1L]] <- display$plot[[3]] + ggplot2::labs(title = paste(style, "| Igf1r"))
  preview <- display$data$color_preview
  long <- do.call(rbind, lapply(c("color", "deutan", "protan", "tritan"), function(view)
    data.frame(domain = preview$domain, view = view, color = preview[[view]])))
  long$view <- factor(long$view, levels = rev(c("color", "deutan", "protan", "tritan")))
  long$domain <- factor(long$domain, levels = preview$domain)
  swatches[[style]] <- ggplot2::ggplot(long, ggplot2::aes(domain, view, fill = color)) +
    ggplot2::geom_tile(width = 0.95, height = 0.9) + ggplot2::scale_fill_identity() +
    ggplot2::labs(title = style, x = NULL, y = NULL) + cowplot::theme_minimal_grid(font_size = 8) +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1), panel.grid = ggplot2::element_blank())
}
comparison <- cowplot::plot_grid(plotlist = maps, ncol = 2, align = "none")
ncfigR::export_figure_bundle(comparison, "color-comparison", output, width = 210 / 25.4, height = 300 / 25.4)
ncfigR::export_figure_bundle(cowplot::plot_grid(plotlist = swatches, ncol = 2),
  "color-vision-preview", output, width = 210 / 25.4, height = 150 / 25.4)
jsonlite::write_json(results, file.path(output, "runs.json"), auto_unbox = TRUE, pretty = TRUE)
cat("Four styles rendered from identical mouse-cortex inputs. Runs remain needs_review.\n", output, "\n")
