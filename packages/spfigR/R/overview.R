#' Compose a section-aware spatial overview
#' @param coordinates Canonical section-aware coordinate table.
#' @param features Complete long feature table including zeros.
#' @param regions Optional section-specific zoom boxes.
#' @param expression_scale Declared counts, log_normalized or signed_score.
#' @param coordinate_unit Declared pixel, micrometer or arbitrary units.
#' @param y_axis up for Cartesian coordinates or down for image row coordinates.
#' @param palette Named domain colors or palette table; default is shared across maps.
#' @param feature_order Optional complete feature order.
#' @param domain_order Optional complete domain order.
#' @param point_size Display point diameter in mm, not physical spot diameter.
#' @param title Optional figure title.
#' @param data.out Return list(plot, data) rather than just the plot.
#' @param color_style Coordinated categorical and continuous palette preset.
#' @param feature_palette Optional scico palette override with matching scale semantics.
#' @return Patchwork or plot and exact source-data tables.
#' @export
compose_spatial_overview <- function(coordinates, features, regions = NULL,
                                     expression_scale, coordinate_unit, y_axis,
                                     palette = NULL, feature_order = NULL, domain_order = NULL,
                                     point_size = 0.65, title = NULL, data.out = FALSE,
                                     color_style = "balanced", feature_palette = NULL) {
  if (missing(coordinate_unit) || !is.character(coordinate_unit) || length(coordinate_unit) != 1L || is.na(coordinate_unit) ||
      !coordinate_unit %in% c("pixel", "micrometer", "arbitrary")) stop("Declare coordinate_unit: pixel, micrometer or arbitrary.")
  if (missing(y_axis) || !is.character(y_axis) || length(y_axis) != 1L || is.na(y_axis) || !y_axis %in% c("up", "down")) stop("Declare y_axis: up or down.")
  if (!is.logical(data.out) || length(data.out) != 1L || is.na(data.out)) stop("data.out must be TRUE or FALSE.")
  prepared <- prepare_spatial_data(coordinates, features, regions, expression_scale, feature_order, domain_order)
  sp_geometry(prepared$coordinates, "x", "y", point_size, 1)
  scheme <- sp_color_scheme(prepared$domain_order, color_style, expression_scale, palette, feature_palette)
  palette <- scheme$domain_colors
  prepared$color_scheme <- scheme
  prepared$color_preview <- scheme$preview
  prepared$feature_colors <- data.frame(position = seq(0, 1, length.out = 256),
    color = scico::scico(256, palette = scheme$feature_palette, direction = if (expression_scale == "signed_score") 1 else -1))
  prepared$palette <- data.frame(domain = names(palette), color = unname(palette))
  base_theme <- cowplot::theme_half_open(font_size = 8, font_family = "sans", line_size = 0.3) +
    ggplot2::theme(plot.title = ggplot2::element_text(size = 9, face = "bold"),
      plot.tag.position = "topleft", plot.tag = ggplot2::element_text(size = 9, face = "bold"),
      legend.title = ggplot2::element_text(size = 8), legend.text = ggplot2::element_text(size = 7),
      plot.margin = ggplot2::margin(3, 3, 3, 3), plot.background = ggplot2::element_rect(fill = "white", colour = NA))
  theme <- base_theme + ggplot2::theme(legend.position = "bottom",
    axis.line = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank(),
    axis.text = ggplot2::element_blank(), axis.title = ggplot2::element_blank())
  maps <- list()
  make_map <- function(data, limits, section, feature = NULL, region = NULL) {
    p <- ggplot2::ggplot(data, ggplot2::aes(.data$x, .data$y))
    if (is.null(feature)) p <- p + ggplot2::geom_point(ggplot2::aes(colour = .data$domain), size = point_size, stroke = 0, show.legend = TRUE) +
      ggplot2::scale_colour_manual(values = palette, limits = prepared$domain_order, drop = FALSE, name = "Annotation") +
      ggplot2::guides(colour = ggplot2::guide_legend(nrow = 2, override.aes = list(size = 1.5))) else {
      p <- p + ggplot2::geom_point(colour = "#DADADA", size = point_size + 0.12, stroke = 0, show.legend = FALSE) +
        ggplot2::geom_point(ggplot2::aes(colour = .data$value), size = point_size, stroke = 0)
      p <- p + ggplot2::scale_colour_gradientn(colors = prepared$feature_colors$color,
        limits = prepared$feature_limits, name = if (expression_scale == "signed_score") "Signed score" else expression_scale)
    }
    if (y_axis == "down") p <- p + ggplot2::scale_y_reverse()
    p <- p + ggplot2::coord_fixed(xlim = limits[1:2], ylim = if (y_axis == "down") rev(limits[3:4]) else limits[3:4], expand = TRUE) +
      ggplot2::labs(title = if (is.null(region)) paste(section, if (is.null(feature)) "Annotation" else feature, sep = " | ") else paste(section, region, sep = " | ")) + theme
    if (is.null(feature) && is.null(region) && !is.null(prepared$regions)) {
      boxes <- prepared$regions[prepared$regions$section_id == section, , drop = FALSE]
      p <- p + ggplot2::geom_rect(data = boxes, ggplot2::aes(xmin = .data$xmin, xmax = .data$xmax,
        ymin = .data$ymin, ymax = .data$ymax), inherit.aes = FALSE, fill = NA, colour = "#222222", linewidth = 0.35) +
        ggplot2::geom_text(data = boxes, ggplot2::aes(x = .data$xmin, y = .data$ymin, label = .data$region_id),
          inherit.aes = FALSE, hjust = 0, vjust = -0.3, size = 2.2)
    }
    p
  }
  for (section in prepared$sections) {
    data <- prepared$coordinates[prepared$coordinates$section_id == section, ]
    limits <- c(range(data$x), range(data$y))
    maps[[length(maps) + 1L]] <- make_map(data, limits, section)
    for (feature in prepared$feature_order) {
      data <- prepared$mapped_features[prepared$mapped_features$section_id == section & prepared$mapped_features$feature == feature, ]
      maps[[length(maps) + 1L]] <- make_map(data, limits, section, feature)
    }
  }
  if (!is.null(prepared$regions)) for (i in seq_len(nrow(prepared$regions))) {
    r <- prepared$regions[i, ]
    data <- prepared$zoom[prepared$zoom$section_id == r$section_id & prepared$zoom$region_id == r$region_id, ]
    maps[[length(maps) + 1L]] <- make_map(data, unlist(r[c("xmin", "xmax", "ymin", "ymax")]), r$section_id, region = r$region_id)
  }
  composition <- ggplot2::ggplot(prepared$composition, ggplot2::aes(.data$section_id, .data$proportion, fill = .data$domain)) +
    ggplot2::geom_col(width = 0.6) + ggplot2::scale_fill_manual(values = palette, limits = prepared$domain_order, drop = FALSE, guide = "none") +
    ggplot2::scale_y_continuous(labels = scales::label_percent(), limits = c(0, 1), expand = c(0, 0)) +
    ggplot2::labs(title = "Annotated spot fractions", x = "Section", y = "Fraction of supplied spots") +
    base_theme + ggplot2::theme(legend.position = "bottom")
  maps[[length(maps) + 1L]] <- composition
  ncol <- if (length(prepared$sections) == 1L) 2L else min(4L, length(prepared$feature_order) + 1L)
  plot <- patchwork::wrap_plots(maps, ncol = ncol, guides = "collect") +
    patchwork::plot_annotation(title = title, tag_levels = "a", subtitle = paste("Coordinates:", coordinate_unit, "| y increases", y_axis)) &
    ggplot2::theme(legend.position = "bottom", legend.box = "vertical")
  if (data.out) list(plot = plot, data = prepared) else plot
}
