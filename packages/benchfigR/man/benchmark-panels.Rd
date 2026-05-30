\name{benchmark-panels}
\alias{plot_metric_heatmap_panel}
\alias{plot_rank_panel}
\alias{plot_runtime_panel}
\alias{plot_robustness_panel}
\alias{plot_case_embedding_panel}
\alias{compose_benchmark_case_figure}
\title{NC-style benchmark panel functions}
\description{
Build source-data-first benchmark panels and a composite benchmark plus biological case figure.
}
\usage{
plot_metric_heatmap_panel(
  data,
  method_col = "method",
  dataset_col = "dataset",
  metric_col = "metric",
  value_col = "value",
  title = NULL
)

plot_rank_panel(
  data,
  method_col = "method",
  metric_col = "metric",
  rank_col = "rank",
  value_col = NULL,
  title = NULL
)

plot_runtime_panel(
  data,
  method_col = "method",
  dataset_col = "dataset",
  runtime_col = "runtime_sec",
  memory_col = NULL,
  title = NULL
)

plot_robustness_panel(
  data,
  method_col = "method",
  perturbation_col = "perturbation",
  metric_col = "metric",
  value_col = "value",
  title = NULL
)

plot_case_embedding_panel(
  data,
  x_col = "x",
  y_col = "y",
  label_col = "label",
  score_col = NULL,
  palette = NULL,
  point_size = 0.6,
  alpha = 0.85,
  title = NULL
)

compose_benchmark_case_figure(
  benchmark_metrics,
  benchmark_ranks,
  runtime_metrics,
  robustness_metrics,
  case_embedding,
  title = "Benchmark and biological case"
)
}
\arguments{
\item{data}{A data frame containing the required source-data columns for one panel.}
\item{method_col}{Column containing method names.}
\item{dataset_col}{Column containing dataset or benchmark scenario names.}
\item{metric_col}{Column containing metric names.}
\item{value_col}{Column containing metric values.}
\item{title}{Panel or figure title.}
\item{rank_col}{Column containing rank values; lower rank is better by convention.}
\item{runtime_col}{Column containing runtime values.}
\item{memory_col}{Optional column containing memory values.}
\item{perturbation_col}{Column containing perturbation or sensitivity levels.}
\item{x_col, y_col}{Columns for case embedding coordinates.}
\item{label_col}{Column containing case labels, such as cell state or domain.}
\item{score_col}{Optional continuous score column for case colouring.}
\item{palette}{Named colour vector for case labels.}
\item{point_size, alpha}{Point size and transparency controls.}
\item{benchmark_metrics}{Source-data table for metric heatmaps.}
\item{benchmark_ranks}{Source-data table for rank summaries.}
\item{runtime_metrics}{Source-data table for runtime or memory panels.}
\item{robustness_metrics}{Source-data table for sensitivity / robustness panels.}
\item{case_embedding}{Source-data table for representative biological case embedding.}
}
\value{
A \code{ggplot} object for panel functions or a \code{patchwork} object for
\code{compose_benchmark_case_figure()}.
}
\details{
The intended figure grammar is not pure benchmark stacking. Pair metric,
rank, runtime, and robustness evidence with one representative biological
case panel.
}
