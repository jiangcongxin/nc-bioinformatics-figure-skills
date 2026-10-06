\name{prepare_sc_atlas_data}
\alias{prepare_sc_atlas_data}
\title{Prepare atlas panels from cell-level source tables}
\description{Calculate sample-level cell fractions and descriptive marker summaries with explicit cell denominators.}
\usage{
prepare_sc_atlas_data(embedding, expression, cell_type_col = "cell_type",
  group_col = "sample", detection_threshold = 0)
}
\arguments{
\item{embedding}{One row per cell, with unique cell_id, finite numeric x and y, a cell-type column, and a sample column.}
\item{expression}{Long table with cell_id, feature, and finite numeric value. Every cell-feature pair must be present, including zero values.}
\item{cell_type_col}{Cell annotation column in embedding.}
\item{group_col}{Sample column used as the composition denominator. Defaults to sample.}
\item{detection_threshold}{A cell expresses a feature when its value exceeds this threshold. Use unscaled counts or log-normalized expression with threshold zero.}
}
\details{
Input cell IDs must match exactly. Duplicate cell IDs or cell-feature pairs are rejected.
Marker means are calculated on the supplied value scale, pooled across cells of each
cell type. They are descriptive summaries, not differential expression tests or
sample-level statistical estimates. Zeros must not be dropped from the long table.
}
\value{A list containing embedding, composition, and markers, ready for compose_sc_atlas_figure. Composition includes n and proportion; markers include n_cells, avg_expression, and pct_expression.}
\examples{
embedding <- data.frame(cell_id = c("a", "b"), x = c(0, 1), y = c(1, 0),
  cell_type = c("T", "B"), sample = c("s1", "s1"))
expression <- data.frame(cell_id = c("a", "b"), feature = "CD3D", value = c(2, 0))
atlas <- prepare_sc_atlas_data(embedding, expression)
compose_sc_atlas_figure(atlas$embedding, atlas$composition, atlas$markers)
}
