plot_spatial_domain_panel <- function(data, domain_col = "domain",
                                      x_col = "x", y_col = "y",
                                      palette = NULL,
                                      point_size = 0.8, alpha = 0.9,
                                      title = NULL) {
  check_sp_columns(data, c(x_col, y_col, domain_col), "spatial coordinate data")
  palette <- as_named_palette(palette)
  if (is.null(palette)) {
    palette <- default_sp_palette(data[[domain_col]])
  } else {
    ncfigR::validate_palette(data[[domain_col]], palette)
  }

  ggplot2::ggplot(
    data,
    ggplot2::aes(x = .data[[x_col]], y = .data[[y_col]], colour = .data[[domain_col]])
  ) +
    ggplot2::geom_point(size = point_size, alpha = alpha, stroke = 0) +
    ggplot2::scale_colour_manual(values = palette, name = domain_col) +
    ggplot2::coord_fixed() +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    ncfigR::nc_theme() +
    ggplot2::theme(axis.text = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank())
}

plot_spatial_feature_panel <- function(data, value_col = "feature_value",
                                       x_col = "x", y_col = "y",
                                       feature_col = NULL,
                                       point_size = 0.8, alpha = 0.9,
                                       title = NULL) {
  required <- c(x_col, y_col, value_col)
  if (!is.null(feature_col)) {
    required <- c(required, feature_col)
  }
  check_sp_columns(data, required, "spatial feature data")

  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(x = .data[[x_col]], y = .data[[y_col]], colour = .data[[value_col]])
  ) +
    ggplot2::geom_point(size = point_size, alpha = alpha, stroke = 0) +
    ggplot2::scale_colour_viridis_c(option = "C", name = value_col) +
    ggplot2::coord_fixed() +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    ncfigR::nc_theme() +
    ggplot2::theme(axis.text = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank())

  if (!is.null(feature_col)) {
    p <- p + ggplot2::facet_wrap(stats::as.formula(paste("~", feature_col)))
  }
  p
}

plot_spatial_composition_panel <- function(data, group_col = "sample",
                                           category_col = "domain",
                                           value_col = "proportion",
                                           palette = NULL,
                                           position = c("fill", "stack", "dodge"),
                                           title = NULL) {
  position <- match.arg(position)
  check_sp_columns(data, c(group_col, category_col, value_col), "spatial composition data")
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

plot_spatial_zoom_panel <- function(data, regions, region_id = NULL,
                                    domain_col = "domain",
                                    x_col = "x", y_col = "y",
                                    palette = NULL,
                                    point_size = 1.2, alpha = 0.95,
                                    title = NULL) {
  check_sp_columns(data, c(x_col, y_col, domain_col), "spatial coordinate data")
  check_sp_columns(regions, c("region_id", "xmin", "xmax", "ymin", "ymax"), "zoom region data")

  if (!is.null(region_id)) {
    regions <- regions[as.character(regions$region_id) %in% as.character(region_id), , drop = FALSE]
  }
  if (nrow(regions) == 0) {
    stop("no zoom regions remain after filtering.", call. = FALSE)
  }

  pieces <- lapply(seq_len(nrow(regions)), function(i) {
    r <- regions[i, , drop = FALSE]
    keep <- data[[x_col]] >= r$xmin & data[[x_col]] <= r$xmax &
      data[[y_col]] >= r$ymin & data[[y_col]] <= r$ymax
    out <- data[keep, , drop = FALSE]
    out$region_id <- as.character(r$region_id)
    out
  })
  zoom_data <- do.call(rbind, pieces)
  if (is.null(zoom_data) || nrow(zoom_data) == 0) {
    stop("zoom regions contain no spatial observations.", call. = FALSE)
  }

  p <- plot_spatial_domain_panel(
    zoom_data,
    domain_col = domain_col,
    x_col = x_col,
    y_col = y_col,
    palette = palette,
    point_size = point_size,
    alpha = alpha,
    title = title
  )

  if (length(unique(zoom_data$region_id)) > 1) {
    p <- p + ggplot2::facet_wrap(~region_id)
  }
  p
}

compose_spatial_niche_figure <- function(spatial_coordinates,
                                         spatial_features,
                                         spatial_composition,
                                         zoom_regions = NULL,
                                         palette = NULL,
                                         domain_col = "domain",
                                         title = "Spatial tissue niche overview") {
  p_domain <- plot_spatial_domain_panel(
    spatial_coordinates,
    domain_col = domain_col,
    palette = palette,
    title = "Spatial domains"
  )
  p_feature <- plot_spatial_feature_panel(
    spatial_features,
    title = "Spatial feature"
  )
  p_composition <- plot_spatial_composition_panel(
    spatial_composition,
    category_col = domain_col,
    palette = palette,
    title = "Domain composition"
  )

  panels <- list(p_domain, p_feature, p_composition)
  if (!is.null(zoom_regions)) {
    panels <- c(
      panels,
      list(plot_spatial_zoom_panel(
        spatial_coordinates,
        zoom_regions,
        domain_col = domain_col,
        palette = palette,
        title = "Zoom-in"
      ))
    )
  }

  ncfigR::compose_nc_figure(panels, ncol = 2, title = title)
}
