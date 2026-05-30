\name{trajectory-panels}
\alias{plot_pseudotime_embedding_panel}
\alias{plot_velocity_embedding_panel}
\alias{plot_branch_probability_panel}
\alias{plot_gene_trend_panel}
\alias{plot_state_transition_panel}
\alias{compose_trajectory_figure}
\title{NC-style trajectory panel functions}
\description{
Build source-data-first trajectory panels and a composite trajectory figure.
}
\usage{
plot_pseudotime_embedding_panel(
  data,
  x_col = "x",
  y_col = "y",
  pseudotime_col = "pseudotime",
  state_col = NULL,
  point_size = 0.7,
  alpha = 0.85,
  title = NULL
)

plot_velocity_embedding_panel(
  data,
  x_col = "x",
  y_col = "y",
  dx_col = "dx",
  dy_col = "dy",
  state_col = "state",
  palette = NULL,
  point_size = 0.45,
  arrow_alpha = 0.65,
  arrow_scale = 1,
  title = NULL
)

plot_branch_probability_panel(
  data,
  pseudotime_col = "pseudotime",
  branch_col = "branch",
  probability_col = "probability",
  group_col = NULL,
  palette = NULL,
  title = NULL
)

plot_gene_trend_panel(
  data,
  pseudotime_col = "pseudotime",
  value_col = "value",
  feature_col = "feature",
  branch_col = NULL,
  title = NULL
)

plot_state_transition_panel(
  data,
  from_col = "from_state",
  to_col = "to_state",
  weight_col = "weight",
  top_n = 30,
  title = NULL
)

compose_trajectory_figure(
  trajectory_cells,
  branch_probabilities,
  gene_trends,
  state_transitions,
  velocity_vectors = NULL,
  title = "Trajectory overview"
)
}
\arguments{
\item{data}{A data frame containing the required source-data columns for one panel.}
\item{x_col, y_col}{Columns for embedding coordinates.}
\item{pseudotime_col}{Column containing pseudotime values.}
\item{state_col}{Column containing trajectory state labels.}
\item{point_size, alpha}{Point size and transparency controls.}
\item{title}{Panel or figure title.}
\item{dx_col, dy_col}{Columns containing vector offsets for velocity or direction arrows.}
\item{palette}{Named colour vector for state or branch labels.}
\item{arrow_alpha, arrow_scale}{Arrow transparency and vector scaling controls.}
\item{branch_col}{Column containing branch labels.}
\item{probability_col}{Column containing branch probabilities.}
\item{group_col}{Optional faceting column for branch probability panels.}
\item{value_col}{Column containing gene, module, or signature values.}
\item{feature_col}{Column containing feature names for faceting gene trends.}
\item{from_col, to_col}{Columns containing directed transition endpoints.}
\item{weight_col}{Column containing transition weights.}
\item{top_n}{Maximum number of transition edges to draw.}
\item{trajectory_cells}{Source-data table for pseudotime embedding.}
\item{branch_probabilities}{Source-data table for branch probability trends.}
\item{gene_trends}{Source-data table for gene/module/signature trends.}
\item{state_transitions}{Source-data table for directed state transitions.}
\item{velocity_vectors}{Optional source-data table for velocity/direction arrows.}
}
\value{
A \code{ggplot} object for panel functions or a \code{patchwork} object for
\code{compose_trajectory_figure()}.
}
\details{
These functions are intentionally source-data-first. Export Monocle3, slingshot,
scVelo, dynamo, or custom trajectory outputs to TSV tables before plotting.
}
