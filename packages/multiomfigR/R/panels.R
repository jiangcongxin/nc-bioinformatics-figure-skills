plot_integration_embedding_panel <- function(data, x_col = "x", y_col = "y",
                                             color_col = "cell_type",
                                             shape_col = NULL,
                                             palette = NULL,
                                             point_size = 0.65,
                                             alpha = 0.85,
                                             label = TRUE,
                                             title = NULL) {
  required <- c(x_col, y_col, color_col)
  if (!is.null(shape_col)) {
    required <- c(required, shape_col)
  }
  check_multiom_columns(data, required, "integration embedding data")

  plot_data <- data
  names(plot_data)[names(plot_data) == x_col] <- "x"
  names(plot_data)[names(plot_data) == y_col] <- "y"
  palette <- as_named_palette(palette)
  if (is.null(palette)) {
    palette <- default_multiom_palette(plot_data[[color_col]])
  } else {
    ncfigR::validate_palette(plot_data[[color_col]], palette)
  }

  mapping <- ggplot2::aes(x = .data$x, y = .data$y, colour = .data[[color_col]])
  if (!is.null(shape_col)) {
    mapping <- ggplot2::aes(
      x = .data$x,
      y = .data$y,
      colour = .data[[color_col]],
      shape = .data[[shape_col]]
    )
  }

  p <- ggplot2::ggplot(plot_data, mapping) +
    ggplot2::geom_point(size = point_size, alpha = alpha, stroke = 0) +
    ggplot2::scale_colour_manual(values = palette, name = color_col) +
    ggplot2::coord_equal() +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    ncfigR::nc_theme() +
    ggplot2::theme(axis.text = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank())

  if (isTRUE(label)) {
    centers <- stats::aggregate(
      plot_data[, c("x", "y")],
      by = list(label = plot_data[[color_col]]),
      FUN = stats::median
    )
    p <- p + ggplot2::geom_text(
      data = centers,
      ggplot2::aes(x = .data$x, y = .data$y, label = .data$label),
      inherit.aes = FALSE,
      size = 2.5
    )
  }
  p
}

plot_modality_metric_panel <- function(data, modality_col = "modality",
                                       dataset_col = "dataset",
                                       metric_col = "metric",
                                       value_col = "value",
                                       title = NULL) {
  check_multiom_columns(
    data,
    c(modality_col, dataset_col, metric_col, value_col),
    "modality metric data"
  )
  ncfigR::plot_benchmark_heatmap(
    data = data,
    method_col = modality_col,
    dataset_col = dataset_col,
    metric_col = metric_col,
    value_col = value_col,
    title = title
  )
}

plot_cross_dataset_validation_panel <- function(data, source_col = "source_dataset",
                                                target_col = "target_dataset",
                                                metric_col = "metric",
                                                value_col = "value",
                                                title = NULL) {
  check_multiom_columns(
    data,
    c(source_col, target_col, metric_col, value_col),
    "cross-dataset validation data"
  )

  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(x = .data[[target_col]], y = .data[[source_col]], fill = .data[[value_col]])
  ) +
    ggplot2::geom_tile(colour = "white", linewidth = 0.2) +
    ggplot2::scale_fill_viridis_c(option = "C", name = value_col) +
    ggplot2::labs(title = title, x = "target", y = "source") +
    ncfigR::nc_theme() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))

  p + ggplot2::facet_wrap(stats::as.formula(paste("~", metric_col)))
}

plot_feature_link_panel <- function(data, source_col = "source_feature",
                                    target_col = "target_feature",
                                    weight_col = "weight",
                                    top_n = 30,
                                    title = NULL) {
  check_multiom_columns(data, c(source_col, target_col, weight_col), "feature link data")
  ncfigR::plot_lr_network(
    data = data,
    source_col = source_col,
    target_col = target_col,
    value_col = weight_col,
    top_n = top_n,
    title = title
  )
}

plot_pathway_program_panel <- function(data, program_col = "program",
                                       group_col = "group",
                                       value_col = "score",
                                       title = NULL) {
  check_multiom_columns(data, c(program_col, group_col, value_col), "pathway program data")
  ncfigR::plot_marker_heatmap(
    data = data,
    row_col = program_col,
    col_col = group_col,
    value_col = value_col,
    title = title
  )
}

compose_multiomics_figure <- function(integration_embedding,
                                      modality_metrics,
                                      cross_dataset_validation,
                                      feature_links,
                                      pathway_programs,
                                      title = "Multi-omics integration overview") {
  panels <- list(
    plot_integration_embedding_panel(integration_embedding, title = "Integrated embedding"),
    plot_modality_metric_panel(modality_metrics, title = "Modality metrics"),
    plot_cross_dataset_validation_panel(cross_dataset_validation, title = "Cross-dataset validation"),
    plot_feature_link_panel(feature_links, title = "Regulatory / feature links"),
    plot_pathway_program_panel(pathway_programs, title = "Pathway / program panel")
  )
  ncfigR::compose_nc_figure(panels, ncol = 2, title = title)
}
