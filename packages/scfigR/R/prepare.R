prepare_sc_atlas_data <- function(embedding, expression, cell_type_col = "cell_type",
                                  group_col = "sample", detection_threshold = 0) {
  ncfigR::validate_panel_data(embedding,
    c("cell_id", "x", "y", cell_type_col, group_col), c("x", "y"),
    "cell_id", "embedding data")
  ncfigR::validate_panel_data(expression, c("cell_id", "feature", "value"),
    "value", c("cell_id", "feature"), "expression data")
  if (!is.numeric(detection_threshold) || length(detection_threshold) != 1L ||
      !is.finite(detection_threshold)) {
    stop("detection_threshold must be one finite number.", call. = FALSE)
  }
  cells <- as.character(embedding$cell_id)
  if (!setequal(as.character(expression$cell_id), cells)) {
    stop("expression and embedding must contain exactly the same cell IDs.", call. = FALSE)
  }
  features <- unique(as.character(expression$feature))
  # Explicit zero rows are required so missing observations cannot inflate detection fractions.
  if (nrow(expression) != length(cells) * length(features)) {
    stop("expression must contain every cell-feature pair, including explicit zero values.", call. = FALSE)
  }
  cell_types <- levels(sc_order(embedding[[cell_type_col]]))
  groups <- levels(sc_order(embedding[[group_col]]))
  annotations <- data.frame(
    cell_id = cells,
    cell_type = factor(as.character(embedding[[cell_type_col]]), levels = cell_types),
    group = factor(as.character(embedding[[group_col]]), levels = groups)
  )
  composition <- as.data.frame(table(annotations$group, annotations$cell_type),
                               stringsAsFactors = FALSE)
  names(composition) <- c("group", "cell_type", "n")
  composition$proportion <- composition$n / stats::ave(composition$n, composition$group, FUN = sum)
  expression$cell_type <- annotations$cell_type[match(expression$cell_id, cells)]
  markers <- expression |>
    dplyr::group_by(.data$feature, .data$cell_type) |>
    dplyr::summarise(avg_expression = mean(.data$value),
                     pct_expression = mean(.data$value > detection_threshold),
                     n_cells = dplyr::n(), .groups = "drop")
  markers$feature <- factor(markers$feature, levels = features)
  embedding$cell_type <- annotations$cell_type
  embedding$group <- annotations$group
  list(embedding = embedding, composition = composition, markers = as.data.frame(markers))
}

load_sc_example <- function() {
  read <- function(name) readr::read_tsv(
    system.file("extdata", name, package = "scfigR"), show_col_types = FALSE)
  list(embedding = read("embedding.tsv"), composition = read("composition.tsv"),
       markers = read("marker_dotplot.tsv"), module_scores = read("module_scores.tsv"),
       palette = ncfigR::read_nc_palette(read("cell_type_palette.tsv")))
}
