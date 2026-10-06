suppressPackageStartupMessages({
  library(ncfigR)
  library(scfigR)
  library(SeuratObject)
})

args <- commandArgs(trailingOnly = TRUE)
cache <- if (length(args)) args[1] else "examples/single-cell/cache"
out_dir <- if (length(args) > 1L) args[2] else "examples/single-cell/pbmc3k-output"
dir.create(cache, recursive = TRUE, showWarnings = FALSE)
url <- "https://seurat.nygenome.org/src/contrib/pbmc3k.SeuratData_3.1.4.tar.gz"
archive <- file.path(cache, "pbmc3k.SeuratData_3.1.4.tar.gz")
expected_md5 <- "5fa763b229e38a44d0b6abec650b60a3"
if (!file.exists(archive)) utils::download.file(url, archive, mode = "wb")
if (unname(tools::md5sum(archive)) != expected_md5) {
  stop("PBMC3k archive checksum mismatch. Remove the cache and verify the source before retrying.")
}
dataset <- "pbmc3k.SeuratData/data/pbmc3k.final.rda"
utils::untar(archive, files = dataset, exdir = cache)
environment <- new.env()
load(file.path(cache, dataset), envir = environment)
pbmc <- SeuratObject::UpdateSeuratObject(environment$pbmc3k.final)
embedding <- as_panel_data(pbmc, "embedding")
embedding$cell_type <- as.character(SeuratObject::Idents(pbmc))[match(embedding$cell_id, colnames(pbmc))]
embedding$sample <- "PBMC3k"
features <- c("CD3D", "IL7R", "MS4A1", "CD14", "LYZ", "FCGR3A", "NKG7", "FCER1A", "PPBP")
expression <- as_panel_data(pbmc, "expression", features = features, assay = "RNA", layer = "data")
data <- prepare_sc_atlas_data(embedding, expression)
cell_type_order <- c("Naive CD4 T", "Memory CD4 T", "CD8 T", "NK", "B",
                     "CD14+ Mono", "FCGR3A+ Mono", "DC", "Platelet")
palette <- c("Naive CD4 T" = "#5479A5", "Memory CD4 T" = "#8BA9C7", "CD8 T" = "#477D72",
             "NK" = "#A4B89B", "B" = "#B86F87", "CD14+ Mono" = "#CCAA66",
             "FCGR3A+ Mono" = "#A87850", "DC" = "#8E7CA8", "Platelet" = "#6E9FA8")
figure <- compose_sc_publication_figure(data$embedding, data$composition, data$markers,
  expression = expression, feature_genes = c("CD3D", "MS4A1", "LYZ"),
  cell_type_order = cell_type_order, feature_order = features, palette = palette)

source_dir <- file.path(out_dir, "source-data")
dir.create(source_dir, recursive = TRUE, showWarnings = FALSE)
for (name in names(data)) readr::write_tsv(data[[name]], file.path(source_dir, paste0(name, ".tsv")))
readr::write_tsv(expression, file.path(source_dir, "expression.tsv"))
readr::write_tsv(data.frame(cell_type = names(palette), color = unname(palette)),
  file.path(source_dir, "cell_type_palette.tsv"))
source_paths <- list.files(source_dir, full.names = TRUE)
manifest <- data.frame(
  file = basename(source_paths), md5 = unname(tools::md5sum(source_paths)),
  source_url = url, source_archive_md5 = expected_md5,
  annotation = "SeuratData pbmc3k.final existing identities and UMAP",
  expression_scale = "RNA data layer; mean of supplied log-normalized values",
  detection = "fraction of cells with expression > 0",
  marker_color = "Per-gene z-score across cell-type means; display clipped to [-2, 2]",
  feature_maps = "CD3D, MS4A1, LYZ; same UMAP coordinates and common raw log-expression color limits",
  sample_note = "One sample; composition is descriptive, not a biological replicate comparison"
)
paths <- export_figure_bundle(figure, "pbmc3k_atlas", out_dir,
  width = 183 / 25.4, height = 126 / 25.4, source_manifest = manifest)
print(paths)
cat("Cells:", nrow(embedding), " Cell types:", length(unique(embedding$cell_type)), "\n")
