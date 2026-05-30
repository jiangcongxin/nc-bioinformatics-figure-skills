plot_marker_heatmap <- function(data, row_col = "feature", col_col = "cell_type",
                                value_col = "value", fill_limits = NULL,
                                title = NULL) {
  check_columns(data, c(row_col, col_col, value_col), "marker heatmap data")
  ggplot2::ggplot(
    data,
    ggplot2::aes(x = .data[[col_col]], y = .data[[row_col]], fill = .data[[value_col]])
  ) +
    ggplot2::geom_tile(colour = "white", linewidth = 0.15) +
    ggplot2::scale_fill_gradient2(
      low = "#3B4CC0",
      mid = "white",
      high = "#B40426",
      midpoint = 0,
      limits = fill_limits,
      name = value_col
    ) +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    nc_theme() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
}

plot_lr_heatmap <- function(data, source_col = "source", target_col = "target",
                            value_col = "score", title = NULL) {
  check_columns(data, c(source_col, target_col, value_col), "ligand-receptor data")
  plot_data <- data |>
    dplyr::group_by(.data[[source_col]], .data[[target_col]]) |>
    dplyr::summarise(score = mean(.data[[value_col]], na.rm = TRUE), .groups = "drop")

  ggplot2::ggplot(
    plot_data,
    ggplot2::aes(x = .data[[target_col]], y = .data[[source_col]], fill = .data$score)
  ) +
    ggplot2::geom_tile(colour = "white", linewidth = 0.2) +
    ggplot2::scale_fill_viridis_c(option = "C", name = value_col) +
    ggplot2::labs(title = title, x = "receiver", y = "sender") +
    nc_theme() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
}

plot_benchmark_heatmap <- function(data, method_col = "method", dataset_col = "dataset",
                                   value_col = "value", metric_col = NULL,
                                   title = NULL) {
  required <- c(method_col, dataset_col, value_col)
  if (!is.null(metric_col)) {
    required <- c(required, metric_col)
  }
  check_columns(data, required, "benchmark data")

  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(x = .data[[dataset_col]], y = .data[[method_col]], fill = .data[[value_col]])
  ) +
    ggplot2::geom_tile(colour = "white", linewidth = 0.2) +
    ggplot2::scale_fill_viridis_c(option = "D", name = value_col) +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    nc_theme() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))

  if (!is.null(metric_col)) {
    p <- p + ggplot2::facet_wrap(stats::as.formula(paste("~", metric_col)), scales = "free")
  }
  p
}
