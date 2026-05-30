plot_lr_network <- function(data, source_col = "source", target_col = "target",
                            value_col = "score", top_n = 30,
                            title = NULL) {
  check_columns(data, c(source_col, target_col, value_col), "ligand-receptor data")
  edges <- data |>
    dplyr::group_by(.data[[source_col]], .data[[target_col]]) |>
    dplyr::summarise(weight = mean(.data[[value_col]], na.rm = TRUE), .groups = "drop") |>
    dplyr::arrange(dplyr::desc(.data$weight)) |>
    utils::head(top_n)

  graph <- igraph::graph_from_data_frame(edges, directed = TRUE)
  ggraph::ggraph(graph, layout = "circle") +
    ggraph::geom_edge_link(
      ggplot2::aes(width = .data$weight),
      alpha = 0.65,
      arrow = grid::arrow(length = grid::unit(2, "mm")),
      end_cap = ggraph::circle(3, "mm")
    ) +
    ggraph::geom_node_point(size = 4, colour = "#4C78A8") +
    ggraph::geom_node_text(ggplot2::aes(label = .data$name), repel = TRUE, size = 2.8) +
    ggraph::scale_edge_width(range = c(0.2, 1.8), guide = "none") +
    ggplot2::labs(title = title) +
    nc_theme() +
    ggplot2::theme(
      axis.line = ggplot2::element_blank(),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.title = ggplot2::element_blank()
    )
}

plot_trajectory_trend <- function(data, pseudotime_col = "pseudotime",
                                  value_col = "value", feature_col = "feature",
                                  group_col = NULL, title = NULL) {
  required <- c(pseudotime_col, value_col, feature_col)
  if (!is.null(group_col)) {
    required <- c(required, group_col)
  }
  check_columns(data, required, "trajectory trend data")

  mapping <- ggplot2::aes(x = .data[[pseudotime_col]], y = .data[[value_col]])
  if (!is.null(group_col)) {
    mapping <- ggplot2::aes(
      x = .data[[pseudotime_col]],
      y = .data[[value_col]],
      colour = .data[[group_col]]
    )
  }

  ggplot2::ggplot(data, mapping) +
    ggplot2::geom_smooth(method = "loess", formula = y ~ x, se = FALSE, linewidth = 0.6) +
    ggplot2::facet_wrap(stats::as.formula(paste("~", feature_col)), scales = "free_y") +
    ggplot2::labs(title = title, x = "pseudotime", y = value_col) +
    nc_theme()
}
