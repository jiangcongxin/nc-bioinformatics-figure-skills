plot_embedding_panel <- function(data, color_col = "cell_type", palette = NULL,
                                 point_size = 0.5, alpha = 0.85,
                                 label = FALSE, title = NULL, category_order = NULL, color_style = "balanced") {
  validate_panel_data(data, c("x", "y", color_col), c("x", "y"),
                      if ("cell_id" %in% names(data)) "cell_id" else character(), "embedding data")
  if (!is.numeric(point_size) || length(point_size) != 1L || !is.finite(point_size) || point_size <= 0 ||
      !is.numeric(alpha) || length(alpha) != 1L || !is.finite(alpha) || alpha < 0 || alpha > 1) {
    stop("point_size must be positive and alpha must be between 0 and 1.", call. = FALSE)
  }
  data[[color_col]] <- ordered_values(data[[color_col]], category_order, "category_order")
  palette <- named_palette(palette)
  if (is.null(palette)) {
    palette <- nc_color_scheme(levels(data[[color_col]]), color_style)$colors
  } else {
    validate_palette(data[[color_col]], palette)
  }

  p <- ggplot2::ggplot(data, ggplot2::aes(x = .data$x, y = .data$y, colour = .data[[color_col]])) +
    ggplot2::geom_point(size = point_size, alpha = alpha, stroke = 0) +
    ggplot2::scale_colour_manual(values = palette, name = color_col) +
    ggplot2::coord_equal() +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    nc_theme() +
    ggplot2::theme(axis.text = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank())

  if (isTRUE(label)) {
    centers <- data |>
      dplyr::group_by(.data[[color_col]]) |>
      dplyr::summarise(x = stats::median(.data$x), y = stats::median(.data$y), .groups = "drop")
    p <- p + ggrepel::geom_text_repel(
      data = centers,
      ggplot2::aes(x = .data$x, y = .data$y, label = .data[[color_col]]),
      inherit.aes = FALSE,
      size = 2.5,
      seed = 1,
      min.segment.length = 0
    )
  }

  p
}

plot_composition_panel <- function(data, group_col = "group", category_col = "cell_type",
                                   value_col = "proportion", palette = NULL,
                                   position = c("fill", "stack", "dodge"),
                                   title = NULL, category_order = NULL,
                                   group_order = NULL, value_type = c("proportion", "count"), color_style = "balanced") {
  position <- match.arg(position)
  value_type <- match.arg(value_type)
  validate_panel_data(data, c(group_col, category_col, value_col), value_col,
                      c(group_col, category_col), "composition data")
  if (any(data[[value_col]] < 0) ||
      (value_type == "proportion" && any(data[[value_col]] > 1))) {
    stop("composition values must be non-negative; proportions must be in [0, 1].", call. = FALSE)
  }
  totals <- tapply(data[[value_col]], data[[group_col]], sum)
  if (position == "fill" && (any(totals <= 0) ||
      (value_type == "proportion" && any(abs(totals - 1) > 1e-6)))) {
    stop("fill bars require positive totals and proportions that sum to 1 per group; use stack for subsets.", call. = FALSE)
  }
  data[[category_col]] <- ordered_values(data[[category_col]], category_order, "category_order")
  data[[group_col]] <- ordered_values(data[[group_col]], group_order, "group_order")
  palette <- named_palette(palette)
  if (is.null(palette)) {
    palette <- nc_color_scheme(levels(data[[category_col]]), color_style)$colors
  } else {
    validate_palette(data[[category_col]], palette)
  }

  pos <- switch(
    position,
    fill = "fill",
    stack = "stack",
    dodge = ggplot2::position_dodge(width = 0.8)
  )

  ggplot2::ggplot(
    data,
    ggplot2::aes(x = .data[[group_col]], y = .data[[value_col]], fill = .data[[category_col]])
  ) +
    ggplot2::geom_col(position = pos, width = 0.75) +
    ggplot2::scale_fill_manual(values = palette, name = category_col) +
    ggplot2::scale_y_continuous(labels = if (value_type == "proportion" || position == "fill") {
      scales::percent_format(accuracy = 1)
    } else scales::label_number()) +
    ggplot2::labs(title = title, x = NULL, y = value_col) +
    nc_theme()
}
