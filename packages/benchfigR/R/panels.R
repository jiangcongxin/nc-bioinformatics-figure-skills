plot_metric_heatmap_panel <- function(data, method_col = "method",
                                      dataset_col = "dataset",
                                      metric_col = "metric",
                                      value_col = "value",
                                      title = NULL) {
  check_bench_columns(data, c(method_col, dataset_col, metric_col, value_col), "benchmark metric data")
  ncfigR::plot_benchmark_heatmap(
    data = data,
    method_col = method_col,
    dataset_col = dataset_col,
    metric_col = metric_col,
    value_col = value_col,
    title = title
  )
}

plot_rank_panel <- function(data, method_col = "method",
                            metric_col = "metric",
                            rank_col = "rank",
                            value_col = NULL,
                            title = NULL) {
  required <- c(method_col, metric_col, rank_col)
  if (!is.null(value_col)) {
    required <- c(required, value_col)
  }
  check_bench_columns(data, required, "benchmark rank data")

  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = .data[[metric_col]],
      y = stats::reorder(.data[[method_col]], -.data[[rank_col]]),
      colour = .data[[rank_col]],
      size = if (is.null(value_col)) 1 else .data[[value_col]]
    )
  ) +
    ggplot2::geom_point(alpha = 0.9) +
    ggplot2::scale_colour_viridis_c(option = "C", direction = -1, name = rank_col) +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    ncfigR::nc_theme()

  if (is.null(value_col)) {
    p <- p + ggplot2::scale_size_continuous(range = c(2.2, 2.2), guide = "none")
  } else {
    p <- p + ggplot2::scale_size_continuous(range = c(1.5, 4), name = value_col)
  }
  p
}

plot_runtime_panel <- function(data, method_col = "method",
                               dataset_col = "dataset",
                               runtime_col = "runtime_sec",
                               memory_col = NULL,
                               title = NULL) {
  required <- c(method_col, dataset_col, runtime_col)
  if (!is.null(memory_col)) {
    required <- c(required, memory_col)
  }
  check_bench_columns(data, required, "runtime data")

  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = stats::reorder(.data[[method_col]], .data[[runtime_col]]),
      y = .data[[runtime_col]]
    )
  ) +
    ggplot2::geom_col(width = 0.72, fill = "#4C78A8") +
    ggplot2::facet_wrap(stats::as.formula(paste("~", dataset_col)), scales = "free_y") +
    ggplot2::labs(title = title, x = NULL, y = runtime_col) +
    ncfigR::nc_theme() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))

  if (!is.null(memory_col)) {
    p <- ggplot2::ggplot(
      data,
      ggplot2::aes(
        x = .data[[runtime_col]],
        y = .data[[memory_col]],
        colour = .data[[method_col]]
      )
    ) +
      ggplot2::geom_point(size = 2.2, alpha = 0.9) +
      ggplot2::facet_wrap(stats::as.formula(paste("~", dataset_col)), scales = "free") +
      ggplot2::labs(title = title, x = runtime_col, y = memory_col) +
      ncfigR::nc_theme()
  }
  p
}

plot_robustness_panel <- function(data, method_col = "method",
                                  perturbation_col = "perturbation",
                                  metric_col = "metric",
                                  value_col = "value",
                                  title = NULL) {
  check_bench_columns(
    data,
    c(method_col, perturbation_col, metric_col, value_col),
    "robustness data"
  )

  ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = .data[[perturbation_col]],
      y = .data[[value_col]],
      colour = .data[[method_col]],
      group = .data[[method_col]]
    )
  ) +
    ggplot2::geom_line(linewidth = 0.55, alpha = 0.85) +
    ggplot2::geom_point(size = 1.4, alpha = 0.9) +
    ggplot2::facet_wrap(stats::as.formula(paste("~", metric_col)), scales = "free_y") +
    ggplot2::labs(title = title, x = perturbation_col, y = value_col) +
    ncfigR::nc_theme()
}

plot_case_embedding_panel <- function(data, x_col = "x", y_col = "y",
                                      label_col = "label",
                                      score_col = NULL,
                                      palette = NULL,
                                      point_size = 0.6,
                                      alpha = 0.85,
                                      title = NULL) {
  required <- c(x_col, y_col, label_col)
  if (!is.null(score_col)) {
    required <- c(required, score_col)
  }
  check_bench_columns(data, required, "case embedding data")

  plot_data <- data
  names(plot_data)[names(plot_data) == x_col] <- "x"
  names(plot_data)[names(plot_data) == y_col] <- "y"

  if (is.null(score_col)) {
    ncfigR::plot_embedding_panel(
      plot_data,
      color_col = label_col,
      palette = palette,
      point_size = point_size,
      alpha = alpha,
      label = TRUE,
      title = title
    )
  } else {
    ggplot2::ggplot(
      plot_data,
      ggplot2::aes(x = .data$x, y = .data$y, colour = .data[[score_col]])
    ) +
      ggplot2::geom_point(size = point_size, alpha = alpha, stroke = 0) +
      ggplot2::scale_colour_viridis_c(option = "C", name = score_col) +
      ggplot2::coord_equal() +
      ggplot2::labs(title = title, x = NULL, y = NULL) +
      ncfigR::nc_theme() +
      ggplot2::theme(axis.text = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank())
  }
}

compose_benchmark_case_figure <- function(benchmark_metrics,
                                          benchmark_ranks,
                                          runtime_metrics,
                                          robustness_metrics,
                                          case_embedding,
                                          title = "Benchmark and biological case") {
  panels <- list(
    plot_metric_heatmap_panel(benchmark_metrics, title = "Metric heatmap"),
    plot_rank_panel(benchmark_ranks, value_col = if ("value" %in% names(benchmark_ranks)) "value" else NULL, title = "Rank summary"),
    plot_runtime_panel(
      runtime_metrics,
      memory_col = if ("memory_gb" %in% names(runtime_metrics)) "memory_gb" else NULL,
      title = "Runtime / memory"
    ),
    plot_robustness_panel(robustness_metrics, title = "Robustness"),
    plot_case_embedding_panel(
      case_embedding,
      score_col = if ("score" %in% names(case_embedding)) "score" else NULL,
      title = "Representative case"
    )
  )
  ncfigR::compose_nc_figure(panels, ncol = 2, title = title)
}
