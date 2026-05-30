\name{commfigR-package}
\alias{commfigR-package}
\alias{commfigR}
\alias{plot_lr_heatmap_panel}
\alias{plot_lr_network_panel}
\alias{plot_sender_receiver_score_panel}
\alias{plot_differential_communication_panel}
\alias{compose_communication_figure}
\docType{package}
\title{NC-Style Cell-Cell Communication Figure Toolkit}
\description{
Source-data-first R functions for training and generating NC-style cell-cell communication figures.
}
\arguments{
\item{data}{A source-data data frame for one panel.}
\item{source_col}{Sender/source cell type column.}
\item{target_col}{Receiver/target cell type column.}
\item{value_col}{Numeric communication value column.}
\item{ligand_col}{Ligand column.}
\item{receptor_col}{Receptor column.}
\item{condition_col}{Optional condition column for faceting.}
\item{title}{Panel or figure title.}
\item{top_n}{Number of top edges or differential pairs to show.}
\item{score_col}{Numeric sender/receiver score column.}
\item{score_type_col}{Score type column, for example sender or receiver.}
\item{logfc_col}{Differential log fold-change column.}
\item{p_col}{P-value or adjusted P-value column.}
\item{lr_pairs}{Ligand-receptor source-data table.}
\item{communication_scores}{Sender-receiver score source-data table.}
\item{differential_lr}{Optional differential ligand-receptor table.}
\item{network_edges}{Optional filtered network edge table.}
}
\usage{
plot_lr_heatmap_panel(data, source_col = "source", target_col = "target",
  value_col = "score", ligand_col = "ligand", receptor_col = "receptor",
  condition_col = NULL, title = NULL)

plot_lr_network_panel(data, source_col = "source", target_col = "target",
  value_col = "score", top_n = 30, title = NULL)

plot_sender_receiver_score_panel(data, source_col = "source", target_col = "target",
  score_col = "score", score_type_col = "score_type", condition_col = NULL,
  title = NULL)

plot_differential_communication_panel(data, source_col = "source",
  target_col = "target", ligand_col = "ligand", receptor_col = "receptor",
  logfc_col = "logFC", p_col = "p_adj", top_n = 20, title = NULL)

compose_communication_figure(lr_pairs, communication_scores, differential_lr = NULL,
  network_edges = NULL, title = "Cell-cell communication overview")
}
\details{
The package builds on \pkg{ncfigR} for shared theme, LR heatmap, network, composition, and export behavior.
}
\keyword{package}
