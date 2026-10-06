publication_theme <- function() {
  ncfigR::nc_theme(base_size = 7) + ggplot2::theme(
    plot.title = ggplot2::element_text(size = 7, face = "plain", margin = ggplot2::margin(b = 3)),
    plot.tag = ggplot2::element_text(size = 8, face = "bold"),
    plot.tag.position = "topleft",
    axis.title = ggplot2::element_text(size = 6.5),
    axis.text = ggplot2::element_text(size = 6, colour = "#333333"),
    axis.line = ggplot2::element_line(linewidth = 0.35),
    axis.ticks = ggplot2::element_line(linewidth = 0.35),
    axis.ticks.length = grid::unit(1, "mm"),
    legend.title = ggplot2::element_text(size = 6),
    legend.text = ggplot2::element_text(size = 6),
    legend.key.size = grid::unit(2.5, "mm"),
    legend.spacing.y = grid::unit(1, "mm"),
    legend.margin = ggplot2::margin(0, 0, 0, 0),
    plot.margin = ggplot2::margin(2, 2, 2, 2, unit = "mm")
  )
}

publication_map <- function(data, color_col, palette = NULL, limits = NULL,
                            title = NULL, tag = NULL, labels = NULL) {
  x_span <- diff(range(data$x)); y_span <- diff(range(data$y))
  if (x_span == 0 || y_span == 0) stop("publication maps require non-zero coordinate ranges.", call. = FALSE)
  x_origin <- min(data$x) - x_span * .02
  y_origin <- min(data$y) - y_span * .16
  point_size <- if (nrow(data) < 100L) 1.2 else if (nrow(data) < 500L) .8 else if (nrow(data) < 2000L) .45 else .22
  p <- ggplot2::ggplot(data, ggplot2::aes(.data$x, .data$y, colour = .data[[color_col]])) +
    ggplot2::geom_point(size = point_size, alpha = .9, stroke = 0) +
    ggplot2::coord_equal(xlim = c(min(data$x) - .17 * x_span, max(data$x) + .12 * x_span),
                         ylim = c(min(data$y) - .30 * y_span, max(data$y) + .12 * y_span)) +
    ggplot2::labs(title = title, tag = tag, x = NULL, y = NULL) +
    publication_theme() + ggplot2::theme(
      axis.line = ggplot2::element_blank(), axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank())
  if (is.null(palette)) {
    p <- p + ggplot2::scale_colour_gradientn(
      colours = c("#E5E5E5", "#D1B7DB", "#9670AF", "#57236B"), limits = limits,
      name = "Log-normalized\nexpression", breaks = scales::breaks_pretty(n = 3)) +
      ggplot2::guides(colour = ggplot2::guide_colourbar(
        barheight = grid::unit(12, "mm"), barwidth = grid::unit(2, "mm")))
  } else {
    p <- p + ggplot2::scale_colour_manual(values = palette, guide = "none")
  }
  p <- p + ggplot2::annotate("segment", x = x_origin, xend = x_origin + x_span * .13,
    y = y_origin, yend = y_origin, colour = "#333333", linewidth = .35,
    arrow = grid::arrow(length = grid::unit(1, "mm"), type = "closed")) +
    ggplot2::annotate("segment", x = x_origin, xend = x_origin,
      y = y_origin, yend = y_origin + y_span * .13, colour = "#333333", linewidth = .35,
      arrow = grid::arrow(length = grid::unit(1, "mm"), type = "closed")) +
    ggplot2::annotate("text", x = x_origin, y = y_origin - y_span * .09,
      label = "UMAP 1", size = 1.8, hjust = 0) +
    ggplot2::annotate("text", x = x_origin - x_span * .12, y = y_origin + y_span * .065,
      label = "UMAP 2", angle = 90, size = 1.8)
  if (!is.null(labels)) {
    centers <- data |>
      dplyr::group_by(.data[[color_col]]) |>
      dplyr::summarise(x = stats::median(.data$x), y = stats::median(.data$y), .groups = "drop")
    centers$label <- unname(labels[as.character(centers[[color_col]])])
    p <- p + ggrepel::geom_text_repel(data = centers,
      ggplot2::aes(.data$x, .data$y, label = .data$label), inherit.aes = FALSE,
      size = 2.1, seed = 1, colour = "#222222",
      box.padding = .25, point.padding = .15, min.segment.length = .5, max.overlaps = Inf)
  }
  p
}

compose_sc_publication_figure <- function(embedding, composition, markers,
                                          expression = NULL, feature_genes = NULL,
                                          palette = NULL, cell_type_order = NULL,
                                          feature_order = NULL,
                                          marker_scale = c("gene_zscore", "raw"),
                                          title = NULL, marker_groups = NULL, data.out = FALSE) {
  sc_check_data_out(data.out)
  marker_scale <- match.arg(marker_scale)
  grouped <- sc_group_markers(markers, "feature", feature_order, marker_groups)
  markers <- grouped$data
  feature_order <- grouped$features
  # Reuse the atlas contracts; publication layout changes presentation, not the source data.
  compose_sc_atlas_figure(embedding, composition, markers, palette = palette,
    cell_type_order = cell_type_order, feature_order = feature_order)
  cell_types <- levels(sc_order(embedding$cell_type, cell_type_order, "cell_type_order"))
  features <- levels(sc_order(markers$feature, feature_order, "feature_order"))
  if (is.null(palette)) palette <- stats::setNames(
    if (length(cell_types) <= 12L) {
      c("#5479A5", "#8BA9C7", "#477D72", "#A4B89B", "#B86F87", "#CCAA66",
        "#A87850", "#8E7CA8", "#6E9FA8", "#A0A0A0", "#A9594E", "#668B9E")[seq_along(cell_types)]
    } else grDevices::hcl.colors(length(cell_types), "Dark 3"), cell_types)
  if (is.data.frame(palette)) palette <- ncfigR::read_nc_palette(palette)
  ncfigR::validate_palette(cell_types, palette)
  ids <- stats::setNames(as.character(seq_along(cell_types)), cell_types)
  category_labels <- stats::setNames(paste(ids, cell_types), cell_types)

  a <- publication_map(embedding, "cell_type", palette = palette,
    title = "Cell identities", tag = "a", labels = ids)
  groups <- unique(as.character(composition$group))
  if (length(groups) == 1L) {
    use_counts <- "n" %in% names(composition)
    column <- if (use_counts) "n" else "proportion"
    ncfigR::validate_panel_data(composition, c("cell_type", column), column)
    if (use_counts && (any(composition$n < 0) || sum(composition$n) <= 0 ||
        any(abs(composition$n / sum(composition$n) - composition$proportion) > 1e-6))) {
      stop("counts and proportions must agree in single-sample composition data.", call. = FALSE)
    }
    b <- ggplot2::ggplot(composition,
      ggplot2::aes(.data[[column]], .data$cell_type, fill = .data$cell_type)) +
      ggplot2::geom_col(width = .62) +
      ggplot2::scale_fill_manual(values = palette, guide = "none") +
      ggplot2::scale_y_discrete(limits = rev(cell_types), labels = category_labels) +
      ggplot2::scale_x_continuous(expand = ggplot2::expansion(mult = c(0, .05)),
        breaks = scales::breaks_pretty(n = 3),
        labels = if (use_counts) scales::label_number() else scales::label_percent()) +
      ggplot2::labs(title = "Cell abundance", tag = "b",
        x = if (use_counts) "Cells" else "Cells (%)", y = NULL) + publication_theme() +
      ggplot2::theme(axis.ticks.y = ggplot2::element_blank(), axis.line.y = ggplot2::element_blank())
  } else {
    b <- plot_cell_fraction_panel(composition, palette = palette, cell_type_order = cell_types) +
      ggplot2::labs(title = "Sample composition", tag = "b", y = "Cells (%)") + publication_theme() +
      ggplot2::theme(legend.position = "none", axis.text.x = ggplot2::element_text(angle = 45, hjust = 1))
  }

  marker_data <- markers
  marker_data$plot_expression <- marker_data$avg_expression
  if (marker_scale == "gene_zscore") {
    marker_data$plot_expression <- stats::ave(marker_data$avg_expression, marker_data$feature,
      FUN = function(values) {
        spread <- stats::sd(values)
        if (length(values) < 2L || is.na(spread) || spread == 0) return(rep(0, length(values)))
        (values - mean(values)) / spread
      })
  }
  marker_data$feature <- factor(as.character(marker_data$feature), levels = features)
  c <- ggplot2::ggplot(marker_data, ggplot2::aes(.data$feature, .data$cell_type,
    size = .data$pct_expression, colour = .data$plot_expression)) +
    ggplot2::geom_point() +
    ggplot2::scale_x_discrete(limits = if (is.null(marker_groups)) features else NULL) +
    ggplot2::scale_y_discrete(limits = rev(cell_types), labels = category_labels) +
    ggplot2::scale_size_area(max_size = 2.5, limits = c(0, 1), breaks = c(.25, .5, .75, 1),
      labels = c("25", "50", "75", "100"), name = "Expressing cells (%)") +
    ggplot2::labs(title = "Marker expression", tag = "c", x = NULL, y = NULL) +
    publication_theme() + ggplot2::theme(
      axis.line = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank(),
      axis.text.x = ggplot2::element_text(angle = 90, hjust = 1, vjust = .5, face = "italic"),
      panel.grid.major = ggplot2::element_line(colour = "#EEEEEE", linewidth = .15),
      legend.position = "bottom", legend.box = "vertical") +
    ggplot2::guides(size = ggplot2::guide_legend(order = 2, direction = "horizontal",
      title.position = "top", nrow = 1), colour = ggplot2::guide_colourbar(order = 1,
      direction = "horizontal", title.position = "top",
      barwidth = grid::unit(20, "mm"), barheight = grid::unit(2, "mm")))
  if (marker_scale == "gene_zscore") {
    c <- c + ggplot2::scale_colour_gradient2(low = "#487CA8", mid = "#F1F1F1", high = "#A44769",
      limits = c(-2, 2), oob = scales::squish, breaks = c(-2, 0, 2), name = "Mean expression (gene z-score)")
  } else {
    c <- c + ggplot2::scale_colour_gradientn(colours = c("#E5E5E5", "#9670AF", "#57236B"),
      name = "Mean expression")
  }
  if (!is.null(marker_groups)) c <- c +
    ggplot2::facet_grid(cols = ggplot2::vars(.data$marker_group), scales = "free_x", space = "free_x") +
    ggplot2::theme(strip.text = ggplot2::element_text(size = 6),
      strip.background = ggplot2::element_blank())
  top <- patchwork::wrap_plots(list(a, b, c), ncol = 3, widths = c(1.15, 1, 1.65))
  figure <- top
  if (!is.null(expression)) {
    ncfigR::validate_panel_data(embedding, c("cell_id", "x", "y"), c("x", "y"), "cell_id")
    ncfigR::validate_panel_data(expression, c("cell_id", "feature", "value"), "value", c("cell_id", "feature"))
    if (!is.character(feature_genes) || length(feature_genes) != 3L ||
        anyNA(feature_genes) || anyDuplicated(feature_genes)) {
      stop("feature_genes must contain three distinct genes for the expression maps.", call. = FALSE)
    }
    if (length(setdiff(feature_genes, expression$feature))) stop("feature genes are absent from expression data.", call. = FALSE)
    selected <- expression[expression$feature %in% feature_genes, , drop = FALSE]
    if (!setequal(selected$cell_id, embedding$cell_id) || nrow(selected) != nrow(embedding) * 3L) {
      stop("expression maps require every cell for each selected gene, including zeros.", call. = FALSE)
    }
    if (any(selected$value < 0)) stop("expression maps require non-negative log-normalized values.", call. = FALSE)
    limits <- c(0, max(selected$value))
    if (limits[2] == 0) limits[2] <- 1
    maps <- lapply(seq_along(feature_genes), function(i) {
      values <- selected[selected$feature == feature_genes[i], , drop = FALSE]
      data <- embedding
      data$value <- values$value[match(data$cell_id, values$cell_id)]
      data <- data[order(data$value), , drop = FALSE]
      publication_map(data, "value", limits = limits, title = feature_genes[i], tag = letters[i + 3L]) +
        ggplot2::theme(plot.title = ggplot2::element_text(size = 7, face = "italic"))
    })
    # Keep marker guides local; collect only the identical feature-expression guide.
    marker_panel <- patchwork::wrap_elements(full = c)
    figure <- ncfigR::compose_nc_figure(
      list(A = a, B = patchwork::wrap_elements(full = b), C = marker_panel,
        D = maps[[1]], E = maps[[2]], F = maps[[3]],
        G = patchwork::guide_area()), labels = NULL,
      design = "AABBCCC\nDDEEFFG", widths = rep(1, 7), heights = c(1.25, 1), guides = "collect")
  } else if (!is.null(feature_genes)) {
    stop("expression is required when feature_genes are supplied.", call. = FALSE)
  }
  figure <- figure + patchwork::plot_annotation(title = title, theme = publication_theme())
  if (data.out) list(plot = figure, data = list(embedding = embedding, composition = composition,
    markers = marker_data, expression = expression,
    palette = data.frame(cell_type = names(palette), color = unname(palette)))) else figure
}
