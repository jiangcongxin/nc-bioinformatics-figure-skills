#' Compose a checked communication overview
#' @param data Canonical communication source table.
#' @param p_max Explicit optional upstream p-value filter.
#' @param top_n Display-only number of top ligand-receptor pairs (1-40).
#' @param cell_type_order Complete order of observed cell types.
#' @param max_pairs Display-only maximum sender-receiver pairs (1-40).
#' @param network_top_n Display-only top sender-receiver edges per condition.
#' @param title Optional figure title.
#' @param data.out Return the plot and exact panel tables if TRUE.
#' @return A patchwork plot, or list(plot, data) when data.out is TRUE.
#' @export
compose_communication_overview <- function(data, p_max = NULL, top_n = 12,
                                           cell_type_order = NULL, title = NULL,
                                           data.out = FALSE, max_pairs = 16, network_top_n = 20) {
  if (!is.logical(data.out) || length(data.out) != 1L || is.na(data.out)) stop("data.out must be TRUE or FALSE.")
  prepared <- prepare_communication_data(data, p_max, top_n, cell_type_order, max_pairs)
  top_by_abs(prepared$edges, "score", network_top_n)
  if (is.null(network_top_n) || network_top_n > 100) stop("network_top_n must be between 1 and 100.")
  edges <- prepared$edges
  display <- prepared$display
  theme <- ncfigR::nc_theme(base_size = 8) + ggplot2::theme(
    strip.background = ggplot2::element_blank(),
    strip.text = ggplot2::element_text(face = "bold"), legend.position = "bottom")
  limits <- c(0, max(prepared$selected$score))
  if (limits[2] == 0) limits[2] <- 1
  heat <- ggplot2::ggplot(edges, ggplot2::aes(.data$target, .data$source, fill = .data$score)) +
    ggplot2::geom_tile(colour = "white", linewidth = 0.2) +
    ggplot2::scale_fill_viridis_c(option = "D", limits = c(0, max(1e-12, edges$score)), name = "Score sum") +
    ggplot2::facet_wrap(~condition, nrow = 1) +
    ggplot2::scale_x_discrete(drop = FALSE) + ggplot2::scale_y_discrete(drop = FALSE) +
    ggplot2::labs(title = "Sender-receiver strength", x = "Receiver", y = "Sender") + theme +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 60, hjust = 1))
  dots <- ggplot2::ggplot(display, ggplot2::aes(.data$cell_pair, .data$lr_pair, colour = .data$score)) +
    ggplot2::geom_point(size = 1.7) +
    ggplot2::scale_colour_viridis_c(option = "D", limits = limits, name = "Upstream score") +
    ggplot2::facet_wrap(~condition, nrow = 1) +
    ggplot2::scale_x_discrete(drop = FALSE) + ggplot2::scale_y_discrete(drop = TRUE) +
    ggplot2::labs(title = "Selected ligand-receptor pairs", x = NULL, y = NULL) + theme +
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90, hjust = 1, size = 5))
  totals <- ggplot2::ggplot(prepared$totals, ggplot2::aes(.data$score, .data$cell_type, fill = .data$condition)) +
    ggplot2::geom_col(position = "dodge", width = 0.7) + ggplot2::facet_wrap(~direction, nrow = 1) +
    ggplot2::scale_fill_manual(values = stats::setNames(c("#5479A5", "#B86F87", "#477D72", "#CCAA66")[seq_along(prepared$conditions)], prepared$conditions)) +
    ggplot2::labs(title = "Incoming and outgoing strength", x = "Score sum", y = NULL, fill = "Condition") + theme
  network_data <- list()
  networks <- lapply(prepared$conditions, function(condition) {
    subset <- edges[edges$condition == condition, c("source", "target", "score")]
    subset <- subset[order(-subset$score, as.character(subset$source), as.character(subset$target)), , drop = FALSE]
    subset <- utils::head(subset, network_top_n)
    network_data[[condition]] <<- transform(subset, condition = condition)
    subset[] <- lapply(subset, function(x) if (is.factor(x)) as.character(x) else x)
    graph <- igraph::graph_from_data_frame(subset, directed = TRUE,
      vertices = data.frame(name = prepared$cell_types))
    layout <- ggraph::create_layout(graph, layout = "circle")
    ggraph::ggraph(layout) +
      ggraph::geom_edge_fan(ggplot2::aes(width = .data$score), colour = "#82929B", alpha = 0.6,
        arrow = grid::arrow(length = grid::unit(1.2, "mm")), end_cap = ggraph::circle(2, "mm")) +
      ggraph::geom_edge_loop(ggplot2::aes(width = .data$score), colour = "#82929B", alpha = 0.6,
        arrow = grid::arrow(length = grid::unit(1.2, "mm"))) +
      ggraph::scale_edge_width(range = c(0.15, 1.1), limits = c(0, max(1e-12, edges$score)), name = "Score sum") +
      ggraph::geom_node_point(size = 2, colour = "#477D72") +
      ggraph::geom_node_text(ggplot2::aes(x = .data$x * 1.22, y = .data$y * 1.22,
        label = .data$name, hjust = ifelse(.data$x > 0.1, 0, ifelse(.data$x < -0.1, 1, 0.5))), size = 2.2) +
      ggplot2::labs(title = condition) + ggplot2::coord_equal(xlim = c(-1.75, 1.75), ylim = c(-1.6, 1.6), clip = "off") +
      ggplot2::theme_void(base_size = 8) + ggplot2::theme(legend.position = "bottom",
        plot.margin = ggplot2::margin(8, 16, 8, 16))
  })
  prepared$network_edges <- do.call(rbind, network_data)
  network <- patchwork::wrap_plots(networks, nrow = 1, guides = "collect") &
    ggplot2::theme(legend.position = "bottom")
  figure <- patchwork::wrap_plots(
    patchwork::wrap_elements(full = heat), patchwork::wrap_elements(full = totals),
    patchwork::wrap_elements(full = dots), patchwork::wrap_elements(full = network),
    design = "AB\nCC\nDD", heights = c(1, 1.5, 1)) +
    patchwork::plot_annotation(title = title, tag_levels = "a",
      theme = ggplot2::theme(plot.title = ggplot2::element_text(size = 10, face = "bold")))
  if (data.out) list(plot = figure, data = prepared) else figure
}
