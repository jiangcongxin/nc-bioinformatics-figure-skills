plot_embedding_panel <- function(data, color_col = "cell_type", palette = NULL,
                                 point_size = 0.5, alpha = 0.85,
                                 label = FALSE, title = NULL) {
  check_columns(data, c("x", "y", color_col), "embedding data")
  palette <- named_palette(palette)
  if (is.null(palette)) {
    palette <- default_discrete_palette(data[[color_col]])
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
      min.segment.length = 0
    )
  }

  p
}

plot_composition_panel <- function(data, group_col = "group", category_col = "cell_type",
                                   value_col = "proportion", palette = NULL,
                                   position = c("fill", "stack", "dodge"),
                                   title = NULL) {
  position <- match.arg(position)
  check_columns(data, c(group_col, category_col, value_col), "composition data")
  palette <- named_palette(palette)
  if (is.null(palette)) {
    palette <- default_discrete_palette(data[[category_col]])
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
    ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
    ggplot2::labs(title = title, x = NULL, y = value_col) +
    nc_theme()
}
