\name{compose_sc_publication_figure}
\alias{compose_sc_publication_figure}
\title{Compose a compact publication-layout atlas figure}
\description{Arrange cell identities, abundance, and marker expression with optional expression maps. This is a layout preset, not a guarantee of journal acceptance or biological validity.}
\usage{
compose_sc_publication_figure(embedding, composition, markers,
  expression = NULL, feature_genes = NULL, palette = NULL,
  cell_type_order = NULL, feature_order = NULL,
  marker_scale = c("gene_zscore", "raw"), title = NULL,
  marker_groups = NULL, data.out = FALSE)
}
\arguments{
\item{embedding, composition, markers}{Atlas source tables with the same contracts as compose_sc_atlas_figure. Embedding must have cell_type; cell_id is required for expression maps.}
\item{expression}{Optional complete long table of cell_id, feature, and non-negative log-normalized value. Zero values must be included.}
\item{feature_genes}{Three distinct genes in expression, for panels d through f.}
\item{palette}{Named cell-type color vector or palette data frame.}
\item{cell_type_order, feature_order}{Category and gene ordering vectors. Defaults to factor levels or first appearance.}
\item{marker_scale}{gene_zscore standardizes each gene's cell-type means using sample standard deviation, maps constant genes to zero, and clips display colors to [-2, 2]. raw retains the supplied means.}
\item{title}{Optional figure title. Defaults to none.}
\item{marker_groups}{Optional named list of gene vectors. Each observed gene must appear exactly once. List order sets grouped gene order; an explicit feature_order must match it. Groups annotate the display, not inferred biology.}
\item{data.out}{If TRUE, return a list with plot and data containing embedding, composition, marker plotting values, expression, and palette. Marker means and detection fractions are not recomputed or changed.}
}
\details{
Panels use lower-case bold tags, 7-point base typography and compact legends.
For one sample, abundance is shown as horizontal count bars when n is supplied,
or fraction bars otherwise. Counts must agree with supplied fractions. Multiple
samples use stacked composition bars. Cluster IDs link the map to category labels.
Marker dot area uses a fixed zero-to-one detection scale. Expression maps preserve
the same UMAP coordinates and share raw log-expression color limits; values are not
clipped or rescaled independently by gene. No inferential statistics are calculated.
For six panels, export at about 183 by 126 mm, adjusting height for longer labels
or additional categories. Inspect final-size PDF/SVG before publication.
}
\value{A patchwork figure, or a list containing plot and data when data.out is TRUE. Marker plotting data include plot_expression (before display clipping) and optional marker_group. Input tables are not modified.}
