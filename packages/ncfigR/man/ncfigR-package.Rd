\name{ncfigR-package}
\alias{ncfigR-package}
\alias{as_panel_data}
\alias{compose_nc_figure}
\alias{export_figure_bundle}
\alias{nc_theme}
\alias{plot_benchmark_heatmap}
\alias{plot_composition_panel}
\alias{plot_embedding_panel}
\alias{plot_lr_heatmap}
\alias{plot_lr_network}
\alias{plot_marker_heatmap}
\alias{plot_trajectory_trend}
\alias{read_nc_palette}
\alias{validate_palette}
\title{NC-style bioinformatics figure toolkit}
\description{
Local R toolkit for building NC-style single-cell, spatial, communication,
trajectory, and benchmark composite figures from traceable source-data tables.
}
\usage{
nc_theme(base_size = 8, base_family = "sans")
read_nc_palette(x, key_col = NULL, color_col = "color")
validate_palette(values, palette, allow_extra = TRUE)
as_panel_data(x, type = c("embedding", "metadata", "expression"), ...)
plot_embedding_panel(data, color_col = "cell_type", palette = NULL, point_size = 0.5, alpha = 0.85, label = FALSE, title = NULL)
plot_composition_panel(data, group_col = "group", category_col = "cell_type", value_col = "proportion", palette = NULL, position = c("fill", "stack", "dodge"), title = NULL)
plot_marker_heatmap(data, row_col = "feature", col_col = "cell_type", value_col = "value", fill_limits = NULL, title = NULL)
plot_lr_heatmap(data, source_col = "source", target_col = "target", value_col = "score", title = NULL)
plot_lr_network(data, source_col = "source", target_col = "target", value_col = "score", top_n = 30, title = NULL)
plot_trajectory_trend(data, pseudotime_col = "pseudotime", value_col = "value", feature_col = "feature", group_col = NULL, title = NULL)
plot_benchmark_heatmap(data, method_col = "method", dataset_col = "dataset", value_col = "value", metric_col = NULL, title = NULL)
compose_nc_figure(panels, ncol = NULL, labels = "AUTO", title = NULL)
export_figure_bundle(plot, basename, out_dir = "figures/exports", width = 7, height = 5, source_manifest = NULL)
}
\arguments{
\item{x, data, values, palette, panels, plot}{Input object, source-data table, palette, panel list, or plot object.}
\item{type}{Panel-data adapter type.}
\item{...}{Additional adapter arguments.}
\item{base_size, base_family, key_col, color_col, allow_extra, point_size, alpha, label, title, group_col, category_col, value_col, position, row_col, col_col, fill_limits, source_col, target_col, top_n, pseudotime_col, feature_col, method_col, dataset_col, metric_col, ncol, labels, basename, out_dir, width, height, source_manifest}{Function options.}
}
\details{
The package is designed for local project reuse and training. It uses source-data
tables as the stable interface and provides optional Seurat object adapters.
}
\value{
Plot functions return ggplot objects. \code{compose_nc_figure()} returns a
patchwork object. \code{export_figure_bundle()} invisibly returns output paths.
}
