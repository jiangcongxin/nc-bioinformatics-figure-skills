#' Prepare existing communication results
#'
#' Preserves upstream scores and p-values. Summaries sum supplied scores within
#' each condition, with no inferred missing interactions or statistical tests.
#' @param data Table with source, target, ligand, receptor and score. Optional
#'   condition and p_value columns. Keys must be unique within conditions.
#' @param p_max Optional explicit upper bound on upstream p_value, inclusive.
#' @param top_n Number of ligand-receptor pairs selected by pooled score sum
#'   for the display only. Ties break lexically. All selected rows are retained.
#' @param cell_type_order Optional complete order of observed cell types.
#' @param max_pairs Display-only maximum sender-receiver pairs (1-40), ranked
#'   by summed retained score across conditions. Summaries keep all pairs.
#' @return List of full input, selected rows, edges, totals and display rows.
#' @export
prepare_communication_data <- function(data, p_max = NULL, top_n = 12,
                                       cell_type_order = NULL, max_pairs = 16) {
  required <- c("source", "target", "ligand", "receptor", "score")
  check_comm_columns(data, required, "communication data")
  data <- comm_condition(as.data.frame(data))
  comm_numeric(data, "score", c(0, Inf))
  if ("p_value" %in% names(data)) {
    check_comm_columns(data, "p_value")
    comm_numeric(data, "p_value", c(0, 1))
  }
  comm_unique(data, c("condition", "source", "target", "ligand", "receptor"))
  if (nrow(data) > 500000L || length(unique(data$condition)) > 4L ||
      length(unique(c(data$source, data$target))) > 30L) {
    stop("Supported limits: 500,000 rows, 4 conditions and 30 cell types. Select a documented task subset explicitly.", call. = FALSE)
  }
  if (!is.null(p_max)) {
    if (!is.numeric(p_max) || length(p_max) != 1L || !is.finite(p_max) || p_max < 0 || p_max > 1 ||
        !"p_value" %in% names(data)) stop("p_max needs a number in [0,1] and upstream p_value.", call. = FALSE)
  }
  top_by_abs(data, "score", top_n)
  if (is.null(top_n) || top_n > 40) stop("Display top_n must be between 1 and 40.", call. = FALSE)
  top_by_abs(data, "score", max_pairs)
  if (is.null(max_pairs) || max_pairs > 40) stop("Display max_pairs must be between 1 and 40.", call. = FALSE)
  types <- sort(unique(as.character(c(data$source, data$target))))
  if (!is.null(cell_type_order)) {
    if (!is.character(cell_type_order) || anyNA(cell_type_order) || anyDuplicated(cell_type_order) ||
        !setequal(cell_type_order, types)) stop("cell_type_order must contain all observed types exactly once.", call. = FALSE)
    types <- cell_type_order
  }
  selected <- if (is.null(p_max)) data else data[data$p_value <= p_max, , drop = FALSE]
  if (!nrow(selected)) stop("No interactions remain under the explicit p_max filter.", call. = FALSE)
  missing_conditions <- setdiff(unique(data$condition), unique(selected$condition))
  if (length(missing_conditions)) stop("Filtering leaves an empty condition: ", paste(missing_conditions, collapse = ", "),
    ". Do not silently omit it from a comparison.", call. = FALSE)
  edges <- dplyr::summarise(dplyr::group_by(selected, .data$condition, .data$source, .data$target),
    score = sum(.data$score), interactions = dplyr::n(), .groups = "drop")
  comm_numeric(edges, "score", c(0, Inf))
  totals <- rbind(
    as.data.frame(dplyr::summarise(dplyr::group_by(edges, .data$condition, cell_type = .data$source),
      score = sum(.data$score), .groups = "drop")) |>
      transform(direction = "Outgoing"),
    as.data.frame(dplyr::summarise(dplyr::group_by(edges, .data$condition, cell_type = .data$target),
      score = sum(.data$score), .groups = "drop")) |>
      transform(direction = "Incoming"))
  comm_numeric(totals, "score", c(0, Inf))
  rank <- as.data.frame(dplyr::summarise(dplyr::group_by(selected, .data$ligand, .data$receptor),
    pooled_score = sum(.data$score), .groups = "drop"))
  comm_numeric(rank, "pooled_score", c(0, Inf))
  rank <- rank[order(-rank$pooled_score, rank$ligand, rank$receptor), , drop = FALSE]
  rank <- utils::head(rank, top_n)
  display <- merge(selected, rank[c("ligand", "receptor")], by = c("ligand", "receptor"), sort = FALSE)
  pair_rank <- as.data.frame(dplyr::summarise(dplyr::group_by(edges, .data$source, .data$target),
    pooled_score = sum(.data$score), .groups = "drop"))
  comm_numeric(pair_rank, "pooled_score", c(0, Inf))
  pair_rank <- pair_rank[order(-pair_rank$pooled_score, as.character(pair_rank$source), as.character(pair_rank$target)), , drop = FALSE]
  pair_rank <- utils::head(pair_rank, max_pairs)
  display <- merge(display, pair_rank[c("source", "target")], by = c("source", "target"), sort = FALSE)
  if (!nrow(display)) stop("Top LR pairs and top cell pairs do not intersect; increase display limits explicitly.", call. = FALSE)
  labels <- paste(rank$ligand, rank$receptor, sep = " / ")
  if (anyDuplicated(labels)) stop("Ambiguous ligand/receptor display labels.", call. = FALSE)
  display$lr_pair <- factor(paste(display$ligand, display$receptor, sep = " / "), levels = rev(labels))
  pairs <- pair_rank[c("source", "target")]
  pairs <- pairs[order(match(pairs$source, types), match(pairs$target, types)), , drop = FALSE]
  pair_labels <- paste(pairs$source, pairs$target, sep = " -> ")
  if (anyDuplicated(pair_labels)) stop("Ambiguous sender/receiver display labels.", call. = FALSE)
  display$cell_pair <- factor(paste(display$source, display$target, sep = " -> "), levels = pair_labels)
  edges$source <- factor(edges$source, levels = rev(types))
  edges$target <- factor(edges$target, levels = types)
  totals$cell_type <- factor(totals$cell_type, levels = rev(types))
  list(input = data, selected = selected, edges = as.data.frame(edges),
    totals = totals, display = display, rank = rank, pair_rank = pair_rank, cell_types = types,
    conditions = sort(unique(data$condition)))
}

#' Adapt a CellChat exported communication table
#' @param data Data frame returned by CellChat::subsetCommunication().
#' @param condition Explicit condition label for this table.
#' @return Canonical source, target, ligand, receptor, score, p_value, condition
#'   table, preserving additional upstream columns.
#' @export
as_cellchat_table <- function(data, condition) {
  check_comm_columns(data, c("source", "target", "ligand", "receptor", "prob", "pval"))
  if (!is.character(condition) || length(condition) != 1L || is.na(condition) || !nzchar(trimws(condition))) {
    stop("condition must be one explicit non-empty label.", call. = FALSE)
  }
  if (any(c("score", "p_value", "condition") %in% names(data))) {
    stop("Adapter would overwrite score, p_value or condition. Supply an unmodified CellChat table.", call. = FALSE)
  }
  out <- as.data.frame(data)
  out$score <- out$prob
  out$p_value <- out$pval
  out$condition <- condition
  prepare_communication_data(out)
  out
}
