args <- commandArgs(trailingOnly = FALSE)
script <- gsub("~+~", " ", sub("^--file=", "", args[grepl("^--file=", args)][1]), fixed = TRUE)
directory <- dirname(normalizePath(script, winslash = "/", mustWork = TRUE))
root <- dirname(dirname(directory))
source(file.path(root, "scripts", "runtime.R")); activate_runtime(root)
if (!requireNamespace("CellChat", quietly = TRUE)) stop("Install CellChat explicitly to read this existing example object; CSV/TSV tasks do not need it.")
if (!requireNamespace("Matrix", quietly = TRUE)) stop("Matrix is required to read the stored expression matrix.")
cache <- file.path(directory, "cache"); dir.create(cache, showWarnings = FALSE)
path <- file.path(cache, "mouse-cortex.rds")
if (!file.exists(path)) utils::download.file("https://api.figshare.com/v2/file/download/43061620", path, mode = "wb")
if (!identical(unname(tools::md5sum(path)), "4caf7f60423f75ab7870fb7a30c6c412")) stop("Example object checksum mismatch.")
object <- readRDS(path)
coordinates <- object@images$coordinates
genes <- c("Igf1", "Igf1r", "Tgfb1")
if (!all(genes %in% rownames(object@data)) || !identical(rownames(coordinates), colnames(object@data)) ||
    !identical(rownames(object@meta), colnames(object@data)) ||
    !identical(as.character(object@meta$labels), as.character(object@idents))) stop("Object keys or example features do not match.")
# The official CellChat spatialFeaturePlot swaps the stored columns and reverses
# y for image display. Record that export mapping; the task runner never guesses it.
spots <- data.frame(section_id = "mouse-cortex", spot_id = rownames(coordinates),
  x = coordinates$y_cent, y = coordinates$x_cent, domain = as.character(object@idents))
matrix <- as.matrix(object@data[genes, , drop = FALSE])
features <- data.frame(section_id = "mouse-cortex", spot_id = rep(colnames(matrix), each = nrow(matrix)),
  feature = rep(rownames(matrix), times = ncol(matrix)), value = as.vector(matrix))
readr::write_tsv(spots, file.path(cache, "coordinates.tsv"))
readr::write_tsv(features, file.path(cache, "features.tsv"))
readr::write_tsv(data.frame(section_id = "mouse-cortex", region_id = "ROI-1",
  xmin = 4200, xmax = 6500, ymin = 3500, ymax = 5500), file.path(cache, "regions.tsv"))
writeLines(c("Suoqin Jin (2023), CellChat object of mouse brain 10X Visium dataset, CC BY 4.0.",
  "https://doi.org/10.6084/m9.figshare.24516436.v1", "File 43061620; MD5 4caf7f60423f75ab7870fb7a30c6c412.",
  "Existing SCT normalized data from object@data; selected Igf1, Igf1r, Tgfb1 including zeros; no new analysis.",
  "Existing Seurat-derived labels from object@idents, not independently validated spatial domains.",
  "Image coordinates: x=stored y_cent, y=stored x_cent, y increases down; follows upstream spatialFeaturePlot.",
  "Units: full-resolution image pixels; no physical distance conversion or histology overlay.",
  "ROI-1 is a demonstration rectangle, not an anatomical or inferred biological niche."), file.path(cache, "provenance.txt"))
cat("Exported", nrow(spots), "spots and", nrow(features), "feature rows.\n")
