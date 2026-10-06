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
      if (ncol(emb) < 2L) stop("embedding must contain at least two dimensions.", call. = FALSE)
      meta <- x[[]]
      out <- data.frame(
        cell_id = rownames(emb),
        x = emb[, 1],
        y = emb[, 2],
        meta[rownames(emb), setdiff(names(meta), c("cell_id", "x", "y")), drop = FALSE],
        check.names = FALSE
      )
      return(out)
    }

    if (type == "expression") {
      features <- args$features
      if (!is.character(features) || !length(features) || anyNA(features) ||
          any(!nzchar(features)) || anyDuplicated(features)) {
        stop("features must be a non-empty vector of unique gene names.", call. = FALSE)
      }
      expr <- SeuratObject::GetAssayData(x, assay = assay, layer = args$layer %||% "data")
      missing <- setdiff(features, rownames(expr))
      if (length(missing)) stop("features not found in assay: ", paste(missing, collapse = ", "), call. = FALSE)
      expr <- expr[features, , drop = FALSE]
      data.frame(feature = rep(rownames(expr), times = ncol(expr)),
                 cell_id = rep(colnames(expr), each = nrow(expr)),
                 value = as.vector(as.matrix(expr)))
    }
  } else {
    stop("x must be a data frame or Seurat object.", call. = FALSE)
  }
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
