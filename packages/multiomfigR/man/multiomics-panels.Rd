\name{multiomics-panels}
\alias{plot_integration_embedding_panel}
\alias{plot_modality_metric_panel}
\alias{plot_cross_dataset_validation_panel}
\alias{plot_feature_link_panel}
\alias{plot_pathway_program_panel}
\alias{compose_multiomics_figure}
\title{NC-style multi-omics panel functions}
\description{
Build source-data-first multi-omics panels and a composite multi-omics figure.
}
\usage{
plot_integration_embedding_panel(
  data,
  x_col = "x",
  y_col = "y",
  color_col = "cell_type",
  shape_col = NULL,
  palette = NULL,
  point_size = 0.65,
  alpha = 0.85,
  label = TRUE,
  title = NULL
)

plot_modality_metric_panel(
  data,
  modality_col = "modality",
  dataset_col = "dataset",
  metric_col = "metric",
  value_col = "value",
  title = NULL
)

plot_cross_dataset_validation_panel(
  data,
  source_col = "source_dataset",
  target_col = "target_dataset",
  metric_col = "metric",
  value_col = "value",
  title = NULL
)

plot_feature_link_panel(
  data,
  source_col = "source_feature",
  target_col = "target_feature",
  weight_col = "weight",
  top_n = 30,
  title = NULL
)

plot_pathway_program_panel(
  data,
  program_col = "program",
  group_col = "group",
  value_col = "score",
  title = NULL
)

compose_multiomics_figure(
  integration_embedding,
  modality_metrics,
  cross_dataset_validation,
  feature_links,
  pathway_programs,
  title = "Multi-omics integration overview"
)
}
\arguments{
\item{data}{A data frame containing the required source-data columns for one panel.}
\item{x_col, y_col}{Columns for embedding coordinates.}
\item{color_col}{Column for discrete embedding colours.}
\item{shape_col}{Optional column for point shapes, usually modality or dataset.}
\item{palette}{Named colour vector for discrete labels.}
\item{point_size, alpha}{Point size and transparency controls.}
\item{label}{Whether to label embedding cluster centers.}
\item{title}{Panel or figure title.}
\item{modality_col}{Column containing modality names.}
\item{dataset_col}{Column containing dataset names.}
\item{metric_col}{Column containing metric names.}
\item{value_col}{Column containing numeric values.}
\item{source_col, target_col}{Columns containing source and target datasets or features.}
\item{weight_col}{Column containing feature-link weights.}
\item{top_n}{Maximum number of feature links to draw.}
\item{program_col}{Column containing pathway or program names.}
\item{group_col}{Column containing biological groups, domains, or cell types.}
\item{integration_embedding}{Source-data table for integrated embedding.}
\item{modality_metrics}{Source-data table for modality metrics.}
\item{cross_dataset_validation}{Source-data table for cross-dataset validation.}
\item{feature_links}{Source-data table for regulatory or feature links.}
\item{pathway_programs}{Source-data table for pathway or program scores.}
}
\value{
A \code{ggplot} object for panel functions or a \code{patchwork} object for
\code{compose_multiomics_figure()}.
}
\details{
The intended figure grammar is integration structure plus validation plus
mechanistic interpretation. Avoid presenting an embedding without quantitative
cross-dataset or regulatory/pathway evidence.
}
