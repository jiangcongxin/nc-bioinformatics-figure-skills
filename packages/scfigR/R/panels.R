plot_sc_embedding_panel <- function(data, color_col = "cell_type", palette = NULL,
                                    point_size = 0.45, alpha = 0.85,
                                    label = TRUE, title = NULL, cell_type_order = NULL, color_style = "balanced") {
  check_sc_columns(data, c("x", "y", color_col), "embedding data")
  ncfigR::plot_embedding_panel(
    data = data,
    color_col = color_col,
    palette = palette,
    point_size = point_size,
    alpha = alpha,
    label = label,
    title = title,
    category_order = cell_type_order, color_style = color_style
  )
}

plot_cell_fraction_panel <- function(data, group_col = "group",
                                     category_col = "cell_type",
                                     value_col = "proportion",
                                     palette = NULL,
                                     position = c("fill", "stack", "dodge"),
                                     title = NULL, cell_type_order = NULL, group_order = NULL, color_style = "balanced") {
  position <- match.arg(position)
  check_sc_columns(data, c(group_col, category_col, value_col), "cell fraction data")
  ncfigR::plot_composition_panel(
    data = data,
    group_col = group_col,
    category_col = category_col,
    value_col = value_col,
    palette = palette,
    position = position,
    title = title,
    category_order = cell_type_order,
    group_order = group_order, color_style = color_style
  )
}

plot_marker_dotplot_panel <- function(data, feature_col = "feature",
                                      cell_type_col = "cell_type",
                                      expression_col = "avg_expression",
                                      percent_col = "pct_expression",
                                      expression_limits = NULL,
                                      title = NULL, cell_type_order = NULL, feature_order = NULL,
                                      marker_groups = NULL, data.out = FALSE, color_style = "balanced") {
  sc_check_data_out(data.out)
  ncfigR::validate_panel_data(
    data,
    c(feature_col, cell_type_col, expression_col, percent_col),
    c(expression_col, percent_col), c(feature_col, cell_type_col), "marker dotplot data"
  )
  if (any(data[[percent_col]] < 0 | data[[percent_col]] > 1)) {
    stop("pct_expression must be a fraction in [0, 1], not a percentage in [0, 100].", call. = FALSE)
  }
  if (!is.null(expression_limits) && (!is.numeric(expression_limits) ||
      length(expression_limits) != 2L || any(!is.finite(expression_limits)) ||
      expression_limits[1] >= expression_limits[2])) {
    stop("expression_limits must be two finite increasing numbers.", call. = FALSE)
  }
  grouped <- sc_group_markers(data, feature_col, feature_order, marker_groups)
  data <- grouped$data
  feature_order <- grouped$features
  data[[cell_type_col]] <- sc_order(data[[cell_type_col]], cell_type_order, "cell_type_order")
  data[[feature_col]] <- sc_order(data[[feature_col]], feature_order, "feature_order")

  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = .data[[cell_type_col]],
      y = .data[[feature_col]],
      size = .data[[percent_col]],
      colour = .data[[expression_col]]
    )
  ) +
    ggplot2::geom_point(alpha = 0.9) +
    ggplot2::scale_size_area(
      max_size = 4,
      limits = c(0, 1),
      labels = scales::percent_format(accuracy = 1),
      name = percent_col
    ) +
    ncfigR::nc_continuous_scale(color_style = color_style, signed = TRUE,
      limits = expression_limits, name = expression_col) +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    ncfigR::nc_theme() +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
  if (!is.null(marker_groups)) p <- p +
    ggplot2::facet_grid(rows = ggplot2::vars(.data$marker_group), scales = "free_y", space = "free_y")
  if (data.out) list(plot = p, data = data) else p
}

plot_module_score_panel <- function(data, score_col = "score",
                                    mode = c("embedding", "violin"),
                                    x_col = "x", y_col = "y",
                                    group_col = "group",
                                    facet_col = NULL,
                                    title = NULL, color_style = "balanced") {
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
  ncfigR::validate_panel_data(data, required,
    if (mode == "embedding") c(score_col, x_col, y_col) else score_col,
    data_name = "module score data")

  if (mode == "embedding") {
    p <- ggplot2::ggplot(
      data,
      ggplot2::aes(x = .data[[x_col]], y = .data[[y_col]], colour = .data[[score_col]])
    ) +
      ggplot2::geom_point(size = 0.45, alpha = 0.85, stroke = 0) +
      ncfigR::nc_continuous_scale(color_style = color_style, signed = TRUE, name = score_col) +
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
      ggplot2::scale_fill_manual(values = ncfigR::nc_color_scheme(sort(unique(as.character(data[[group_col]]))), color_style)$colors) +
      ggplot2::labs(title = title, x = NULL, y = score_col) +
      ncfigR::nc_theme() +
      ggplot2::theme(legend.position = "none")
  }

  if (!is.null(facet_col)) {
    p <- p + ggplot2::facet_wrap(ggplot2::vars(.data[[facet_col]]))
  }
  p
}

compose_sc_atlas_figure <- function(embedding, composition, markers,
                                    module_scores = NULL,
                                    palette = NULL,
                                    embedding_color_col = "cell_type",
                                    title = "Single-cell atlas overview",
                                    cell_type_order = NULL, feature_order = NULL,
                                    group_order = NULL, labels = "AUTO",
                                    marker_groups = NULL, data.out = FALSE,
                                    color_style = "balanced", feature_palette = NULL) {
  sc_check_data_out(data.out)
  check_sc_columns(embedding, c("x", "y", embedding_color_col), "embedding data")
  check_sc_columns(composition, c("group", "cell_type", "proportion"), "composition data")
  check_sc_columns(markers, c("feature", "cell_type", "avg_expression", "pct_expression"), "marker data")
  cell_types <- levels(sc_order(embedding[[embedding_color_col]], cell_type_order, "cell_type_order"))
  for (data in list(composition, markers)) {
    if (!setequal(as.character(data$cell_type), as.character(embedding[[embedding_color_col]]))) {
      stop("embedding, composition, and markers must use the same cell-type categories.", call. = FALSE)
    }
  }
  scheme <- ncfigR::nc_color_scheme(cell_types, color_style, palette = palette, feature_palette = feature_palette)
  palette <- scheme$colors
  p_embedding <- plot_sc_embedding_panel(
    embedding,
    color_col = embedding_color_col,
    palette = palette,
    title = "Embedding", cell_type_order = cell_types
  )
  p_fraction <- plot_cell_fraction_panel(
    composition,
    palette = palette,
    title = "Cell fraction", cell_type_order = cell_types, group_order = group_order
  )
  p_markers <- plot_marker_dotplot_panel(
    markers,
    title = "Marker program", cell_type_order = cell_types, feature_order = feature_order,
    marker_groups = marker_groups, data.out = TRUE
  )
  marker_data <- p_markers$data
  p_markers <- p_markers$plot
  p_markers$scales$scales <- Filter(function(x) !"colour" %in% x$aesthetics, p_markers$scales$scales)
  p_markers <- p_markers + ncfigR::nc_continuous_scale(color_style = color_style,
    feature_palette = scheme$feature_palette, name = "Mean expression")
  p_embedding <- p_embedding + ggplot2::theme(legend.position = "none")
  p_fraction <- p_fraction + ggplot2::labs(y = "Cell fraction") +
    ggplot2::guides(fill = ggplot2::guide_legend(title = "Cell type"))
  p_markers <- p_markers + ggplot2::guides(
    size = ggplot2::guide_legend(title = "Expressing cells"),
    colour = ggplot2::guide_colourbar(title = "Mean expression"))

  panels <- list(p_embedding, p_fraction, p_markers)
  if (!is.null(module_scores)) {
    panels <- c(
      panels,
      list(plot_module_score_panel(module_scores, mode = "embedding", title = "Module score", color_style = color_style))
    )
  }

  figure <- ncfigR::compose_nc_figure(panels, ncol = 2, labels = labels, title = title,
    design = if (length(panels) == 3L) "AB\nCC" else NULL)
  if (data.out) list(plot = figure, data = list(embedding = embedding, composition = composition,
    markers = marker_data, module_scores = module_scores, palette = palette, color_scheme = scheme)) else figure
}
