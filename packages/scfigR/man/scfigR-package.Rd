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
\item{percent_col}{Percent-expressing column, usually 0 to 1.}
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
}
\usage{
plot_sc_embedding_panel(data, color_col = "cell_type", palette = NULL,
  point_size = 0.45, alpha = 0.85, label = TRUE, title = NULL)

plot_cell_fraction_panel(data, group_col = "group", category_col = "cell_type",
  value_col = "proportion", palette = NULL, position = c("fill", "stack", "dodge"),
  title = NULL)

plot_marker_dotplot_panel(data, feature_col = "feature", cell_type_col = "cell_type",
  expression_col = "avg_expression", percent_col = "pct_expression",
  expression_limits = NULL, title = NULL)

plot_module_score_panel(data, score_col = "score", mode = c("embedding", "violin"),
  x_col = "x", y_col = "y", group_col = "group", facet_col = NULL, title = NULL)

compose_sc_atlas_figure(embedding, composition, markers, module_scores = NULL,
  palette = NULL, embedding_color_col = "cell_type",
  title = "Single-cell atlas overview")
}
\details{
The package builds on \pkg{ncfigR} for shared theme, palette, composition, and export behavior.
}
\keyword{package}
