plot_sc_embedding_panel <- function(data, color_col = "cell_type", palette = NULL,
                                    point_size = 0.45, alpha = 0.85,
                                    label = TRUE, title = NULL) {
  check_sc_columns(data, c("x", "y", color_col), "embedding data")
  ncfigR::plot_embedding_panel(
    data = data,
    color_col = color_col,
    palette = palette,
    point_size = point_size,
    alpha = alpha,
    label = label,
    title = title
  )
}

plot_cell_fraction_panel <- function(data, group_col = "group",
                                     category_col = "cell_type",
                                     value_col = "proportion",
                                     palette = NULL,
                                     position = c("fill", "stack", "dodge"),
                                     title = NULL) {
  position <- match.arg(position)
  check_sc_columns(data, c(group_col, category_col, value_col), "cell fraction data")
  ncfigR::plot_composition_panel(
    data = data,
    group_col = group_col,
    category_col = category_col,
    value_col = value_col,
    palette = palette,
    position = position,
    title = title
  )
}

plot_marker_dotplot_panel <- function(data, feature_col = "feature",
                                      cell_type_col = "cell_type",
                                      expression_col = "avg_expression",
                                      percent_col = "pct_expression",
                                      expression_limits = NULL,
                                      title = NULL) {
  check_sc_columns(
    data,
    c(feature_col, cell_type_col, expression_col, percent_col),
    "marker dotplot data"
  )

  ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = .data[[cell_type_col]],
      y = .data[[feature_col]],
      size = .data[[percent_col]],
      colour = .data[[expression_col]]
    )
  ) +
    ggplot2::geom_point(alpha = 0.9) +
    ggplot2::scale_size_continuous(
      range = c(0.5, 4),
      labels = scales::percent_format(accuracy = 1),
      name = percent_col
    ) +
    ggplot2::scale_colour_gradient2(
      low = "#3B4CC0",
      mid = "white",
      high = "#B40426",
      midpoint = 0,
      limits = expression_limits,
      name = expression_col
    ) +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    ncfigR::nc_theme() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
}

plot_module_score_panel <- function(data, score_col = "score",
                                    mode = c("embedding", "violin"),
                                    x_col = "x", y_col = "y",
                                    group_col = "group",
                                    facet_col = NULL,
                                    title = NULL) {
  mode <- match.arg(mode)
  required <- c(score_col)
  if (mode == "embedding") {
    required <- c(required, x_col, y_col)
  } else {
    required <- c(required, group_col)
  }
  if (!is.null(facet_col)) {
    required <- c(required, facet_col)
  }
  check_sc_columns(data, required, "module score data")

  if (mode == "embedding") {
    p <- ggplot2::ggplot(
      data,
      ggplot2::aes(x = .data[[x_col]], y = .data[[y_col]], colour = .data[[score_col]])
    ) +
      ggplot2::geom_point(size = 0.45, alpha = 0.85, stroke = 0) +
      ggplot2::scale_colour_viridis_c(option = "C", name = score_col) +
      ggplot2::coord_equal() +
      ggplot2::labs(title = title, x = NULL, y = NULL) +
      ncfigR::nc_theme() +
      ggplot2::theme(axis.text = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank())
  } else {
    p <- ggplot2::ggplot(
      data,
      ggplot2::aes(x = .data[[group_col]], y = .data[[score_col]], fill = .data[[group_col]])
    ) +
      ggplot2::geom_violin(scale = "width", width = 0.85, alpha = 0.75, colour = NA) +
      ggplot2::geom_boxplot(width = 0.14, outlier.size = 0.2, alpha = 0.9) +
      ggplot2::labs(title = title, x = NULL, y = score_col) +
      ncfigR::nc_theme() +
      ggplot2::theme(legend.position = "none")
  }

  if (!is.null(facet_col)) {
    p <- p + ggplot2::facet_wrap(stats::as.formula(paste("~", facet_col)))
  }
  p
}

compose_sc_atlas_figure <- function(embedding, composition, markers,
                                    module_scores = NULL,
                                    palette = NULL,
                                    embedding_color_col = "cell_type",
                                    title = "Single-cell atlas overview") {
  p_embedding <- plot_sc_embedding_panel(
    embedding,
    color_col = embedding_color_col,
    palette = palette,
    title = "Embedding"
  )
  p_fraction <- plot_cell_fraction_panel(
    composition,
    palette = palette,
    title = "Cell fraction"
  )
  p_markers <- plot_marker_dotplot_panel(
    markers,
    title = "Marker program"
  )

  panels <- list(p_embedding, p_fraction, p_markers)
  if (!is.null(module_scores)) {
    panels <- c(
      panels,
      list(plot_module_score_panel(module_scores, mode = "embedding", title = "Module score"))
    )
  }

  ncfigR::compose_nc_figure(panels, ncol = 2, title = title)
}
