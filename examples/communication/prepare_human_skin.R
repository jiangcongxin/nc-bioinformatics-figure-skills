args <- commandArgs(trailingOnly = FALSE)
script <- gsub("~+~", " ", sub("^--file=", "", args[grepl("^--file=", args)][1]), fixed = TRUE)
directory <- dirname(normalizePath(script, winslash = "/", mustWork = TRUE))
root <- dirname(dirname(directory))
source(file.path(root, "scripts", "runtime.R"))
activate_runtime(root)
if (!requireNamespace("CellChat", quietly = TRUE)) stop("Install CellChat explicitly to export this existing object; the normal task runner does not need CellChat.")
cache <- file.path(directory, "cache")
dir.create(cache, showWarnings = FALSE)
files <- data.frame(condition = c("LS", "NL"), id = c("43061488", "43061485"),
  md5 = c("4365ad2b28cb7569c1d685baf6a88754", "754bc00ee5a0ab4c968f295004867507"))
tables <- lapply(seq_len(nrow(files)), function(i) {
  path <- file.path(cache, paste0("humanSkin-", files$condition[i], ".rds"))
  if (!file.exists(path)) utils::download.file(paste0("https://api.figshare.com/v2/file/download/", files$id[i]), path, mode = "wb")
  if (!identical(unname(tools::md5sum(path)), files$md5[i])) stop("Downloaded object checksum mismatch.")
  object <- readRDS(path)
  # Export existing inference only. CellChat's threshold and its strict comparison
  # are explicit; no computeCommunProb or re-analysis is performed here.
  result <- CellChat::subsetCommunication(object, thresh = 0.05)
  commfigR::as_cellchat_table(result, files$condition[i])
})
combined <- do.call(rbind, tables)
readr::write_tsv(combined, file.path(cache, "human-skin.tsv"))
writeLines(c("Suoqin Jin (2023), CellChat objects of human skin from patients with atopic dermatitis.",
  "https://doi.org/10.6084/m9.figshare.24516340.v1", "CC BY 4.0; extraction from LS and NL objects.",
  paste("CellChat exporter version:", as.character(utils::packageVersion("CellChat"))),
  "subsetCommunication(thresh=0.05): upstream pval < 0.05; no new inference.",
  "All exported cell types and ligand-receptor pairs retained in the canonical table.",
  paste(files$condition, files$id, files$md5)), file.path(cache, "provenance.txt"))
cat("Exported", nrow(combined), "existing interactions to", file.path(cache, "human-skin.tsv"), "\n")
