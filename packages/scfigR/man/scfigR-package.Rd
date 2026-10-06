\name{scfigR-package}
\alias{scfigR-package}
\alias{scfigR}
\alias{plot_sc_embedding_panel}
\alias{plot_cell_fraction_panel}
\alias{plot_marker_dotplot_panel}
\alias{plot_module_score_panel}
\alias{compose_sc_atlas_figure}
\docType{package}
\title{NC-Style Single-Cell Figure Toolkit}
\description{
Source-data-first R functions for training and generating NC-style single-cell atlas overview figures.
}
\arguments{
\item{color_style}{Coordinated color style used by the atlas composer.}
\item{feature_palette}{Optional sequential scico palette for atlas marker means.}
\item{data}{A source-data data frame for one panel.}
\item{color_col}{Column used to color embedding points.}
\item{palette}{Named color vector or palette data frame.}
\item{point_size}{Point size for embedding panels.}
\item{alpha}{Point alpha for embedding panels.}
\item{label}{Whether to add cluster labels to the embedding.}
\item{title}{Panel or figure title.}
\item{group_col}{Group, condition, or sample column.}
\item{category_col}{Categorical column for cell types or annotations.}
\item{value_col}{Numeric value column for composition panels.}
\item{position}{Bar position for composition panels.}
\item{feature_col}{Feature or marker gene column.}
\item{cell_type_col}{Cell type column.}
\item{expression_col}{Average expression or scaled expression column.}
\item{percent_col}{Fraction-expressing column in [0, 1]. Values in [0, 100] are rejected. Point area uses a fixed zero-to-one scale.}
\item{expression_limits}{Optional color-scale limits for marker expression.}
\item{score_col}{Module score column.}
\item{mode}{Module score display mode: embedding or violin.}
\item{x_col}{Embedding x-coordinate column.}
\item{y_col}{Embedding y-coordinate column.}
\item{facet_col}{Optional facet column for module score panels.}
\item{embedding}{Embedding source-data table.}
\item{composition}{Cell composition source-data table.}
\item{markers}{Marker dotplot source-data table.}
\item{module_scores}{Optional module score source-data table.}
\item{embedding_color_col}{Column used to color the atlas embedding panel.}
\item{cell_type_order, feature_order, group_order}{Optional character vectors specifying category order. Defaults to factor levels or first appearance. All observed values must be included.}
\item{labels}{AUTO for capital-letter tags, NULL for none, or one unique label per panel.}
\item{marker_groups}{Optional named list assigning every observed gene once to a display group. Explicit feature_order must match flattened list order.}
\item{data.out}{If TRUE, return a list with plot and data instead of only a plot. For composite figures, data holds the source tables and shared palette.}
}
\usage{
plot_sc_embedding_panel(data, color_col = "cell_type", palette = NULL,
  point_size = 0.45, alpha = 0.85, label = TRUE, title = NULL, cell_type_order = NULL, color_style = "balanced")

plot_cell_fraction_panel(data, group_col = "group", category_col = "cell_type",
  value_col = "proportion", palette = NULL, position = c("fill", "stack", "dodge"),
  title = NULL, cell_type_order = NULL, group_order = NULL, color_style = "balanced")

plot_marker_dotplot_panel(data, feature_col = "feature", cell_type_col = "cell_type",
  expression_col = "avg_expression", percent_col = "pct_expression",
  expression_limits = NULL, title = NULL, cell_type_order = NULL, feature_order = NULL,
  marker_groups = NULL, data.out = FALSE, color_style = "balanced")

plot_module_score_panel(data, score_col = "score", mode = c("embedding", "violin"),
  x_col = "x", y_col = "y", group_col = "group", facet_col = NULL, title = NULL, color_style = "balanced")

compose_sc_atlas_figure(embedding, composition, markers, module_scores = NULL,
  palette = NULL, embedding_color_col = "cell_type",
  title = "Single-cell atlas overview", cell_type_order = NULL,
  feature_order = NULL, group_order = NULL, labels = "AUTO",
  marker_groups = NULL, data.out = FALSE, color_style = "balanced",
  feature_palette = NULL)
}
\details{
The package builds on \pkg{ncfigR} for shared theme, palette, composition, and export behavior.
Atlas panels must use the same cell-type categories. The composite function derives
one palette and cell-type order for both embedding and composition panels.
Composition proportions must sum to one per group for fill bars; use stack for subsets.
Marker tables must have unique feature/cell_type pairs, finite numeric average
expression, and fraction-expressing values. Module scores and coordinates must be
finite numeric values. Missing or blank required values raise an error.
}
\keyword{package}
