as_panel_data <- function(x, type = c("embedding", "metadata", "expression"), ...) {
  type <- match.arg(type)
  if (is.data.frame(x)) {
    return(x)
  }

  if (inherits(x, "Seurat")) {
    require_pkg("SeuratObject", "Seurat object adapters")
    args <- list(...)
    reduction <- args$reduction %||% "umap"
    assay <- args$assay %||% NULL

    if (type == "metadata") {
      meta <- x[[]]
      meta$cell_id <- rownames(meta)
      return(meta)
    }

    if (type == "embedding") {
      emb <- SeuratObject::Embeddings(x, reduction = reduction)
      meta <- x[[]]
      out <- data.frame(
        cell_id = rownames(emb),
        x = emb[, 1],
        y = emb[, 2],
        meta[rownames(emb), , drop = FALSE],
        check.names = FALSE
      )
      return(out)
    }

    if (type == "expression") {
      features <- args$features
      if (is.null(features)) {
        stop("features must be supplied for Seurat expression extraction.", call. = FALSE)
      }
      expr <- SeuratObject::GetAssayData(x, assay = assay, layer = args$layer %||% "data")
      expr <- expr[intersect(features, rownames(expr)), , drop = FALSE]
      long <- as.data.frame(as.matrix(expr))
      long$feature <- rownames(long)
      tidyr::pivot_longer(
        long,
        cols = setdiff(names(long), "feature"),
        names_to = "cell_id",
        values_to = "value"
      )
    }
  } else {
    stop("x must be a data frame or Seurat object.", call. = FALSE)
  }
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
