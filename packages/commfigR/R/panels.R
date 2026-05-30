plot_lr_heatmap_panel <- function(data, source_col = "source", target_col = "target",
                                  value_col = "score", ligand_col = "ligand",
                                  receptor_col = "receptor", condition_col = NULL,
                                  title = NULL) {
  required <- c(source_col, target_col, value_col)
  if (!is.null(condition_col)) {
    required <- c(required, condition_col)
  }
  check_comm_columns(data, required, "ligand-receptor data")

  p <- ncfigR::plot_lr_heatmap(
    data = data,
    source_col = source_col,
    target_col = target_col,
    value_col = value_col,
    title = title
  )

  if (!is.null(condition_col)) {
    p <- p + ggplot2::facet_wrap(stats::as.formula(paste("~", condition_col)))
  }
  p
}

plot_lr_network_panel <- function(data, source_col = "source", target_col = "target",
                                  value_col = "score", top_n = 30,
                                  title = NULL) {
  check_comm_columns(data, c(source_col, target_col, value_col), "network data")
  ncfigR::plot_lr_network(
    data = data,
    source_col = source_col,
    target_col = target_col,
    value_col = value_col,
    top_n = top_n,
    title = title
  )
}

plot_sender_receiver_score_panel <- function(data, source_col = "source",
                                             target_col = "target",
                                             score_col = "score",
                                             score_type_col = "score_type",
                                             condition_col = NULL,
                                             title = NULL) {
  required <- c(source_col, target_col, score_col, score_type_col)
  if (!is.null(condition_col)) {
    required <- c(required, condition_col)
  }
  check_comm_columns(data, required, "communication score data")

  data$pair <- paste(data[[source_col]], data[[target_col]], sep = " -> ")
  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(x = .data[[score_type_col]], y = .data$pair, colour = .data[[score_col]], size = .data[[score_col]])
  ) +
    ggplot2::geom_point(alpha = 0.9) +
    ggplot2::scale_colour_viridis_c(option = "C", name = score_col) +
    ggplot2::scale_size_continuous(range = c(1, 4), guide = "none") +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    ncfigR::nc_theme()

  if (!is.null(condition_col)) {
    p <- p + ggplot2::facet_wrap(stats::as.formula(paste("~", condition_col)))
  }
  p
}

plot_differential_communication_panel <- function(data, source_col = "source",
                                                  target_col = "target",
                                                  ligand_col = "ligand",
                                                  receptor_col = "receptor",
                                                  logfc_col = "logFC",
                                                  p_col = "p_adj",
                                                  top_n = 20,
                                                  title = NULL) {
  check_comm_columns(
    data,
    c(source_col, target_col, ligand_col, receptor_col, logfc_col, p_col),
    "differential communication data"
  )
  plot_data <- data
  plot_data$lr_pair <- paste(plot_data[[ligand_col]], plot_data[[receptor_col]], sep = "-")
  plot_data$cell_pair <- paste(plot_data[[source_col]], plot_data[[target_col]], sep = " -> ")
  plot_data$rank_value <- -log10(pmax(plot_data[[p_col]], .Machine$double.xmin))
  plot_data <- top_by_abs(plot_data, logfc_col, top_n)

  ggplot2::ggplot(
    plot_data,
    ggplot2::aes(x = .data[[logfc_col]], y = stats::reorder(.data$lr_pair, .data[[logfc_col]]))
  ) +
    ggplot2::geom_vline(xintercept = 0, colour = "grey75", linewidth = 0.3) +
    ggplot2::geom_segment(
      ggplot2::aes(x = 0, xend = .data[[logfc_col]], yend = stats::reorder(.data$lr_pair, .data[[logfc_col]])),
      colour = "grey70",
      linewidth = 0.35
    ) +
    ggplot2::geom_point(ggplot2::aes(size = .data$rank_value, colour = .data[[logfc_col]]), alpha = 0.9) +
    ggplot2::scale_colour_gradient2(low = "#3B4CC0", mid = "white", high = "#B40426", midpoint = 0, name = logfc_col) +
    ggplot2::scale_size_continuous(range = c(1, 4), name = paste0("-log10(", p_col, ")")) +
    ggplot2::labs(title = title, x = logfc_col, y = NULL) +
    ncfigR::nc_theme()
}

compose_communication_figure <- function(lr_pairs,
                                         communication_scores,
                                         differential_lr = NULL,
                                         network_edges = NULL,
                                         title = "Cell-cell communication overview") {
  p_heatmap <- plot_lr_heatmap_panel(lr_pairs, title = "LR heatmap")
  p_scores <- plot_sender_receiver_score_panel(communication_scores, title = "Sender / receiver score")

  if (is.null(network_edges)) {
    network_edges <- lr_pairs
    p_network <- plot_lr_network_panel(network_edges, value_col = "score", title = "Filtered network")
  } else {
    network_value_col <- if ("weight" %in% names(network_edges)) "weight" else "score"
    p_network <- plot_lr_network_panel(network_edges, value_col = network_value_col, title = "Filtered network")
  }

  panels <- list(p_heatmap, p_network, p_scores)
  if (!is.null(differential_lr)) {
    panels <- c(
      panels,
      list(plot_differential_communication_panel(differential_lr, title = "Differential LR"))
    )
  }

  ncfigR::compose_nc_figure(panels, ncol = 2, title = title)
}
