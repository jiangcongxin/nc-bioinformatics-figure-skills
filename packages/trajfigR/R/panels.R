plot_pseudotime_embedding_panel <- function(data, x_col = "x", y_col = "y",
                                            pseudotime_col = "pseudotime",
                                            state_col = NULL,
                                            point_size = 0.7, alpha = 0.85,
                                            title = NULL) {
  required <- c(x_col, y_col, pseudotime_col)
  if (!is.null(state_col)) {
    required <- c(required, state_col)
  }
  check_traj_columns(data, required, "trajectory cell data")

  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(x = .data[[x_col]], y = .data[[y_col]], colour = .data[[pseudotime_col]])
  ) +
    ggplot2::geom_point(size = point_size, alpha = alpha, stroke = 0) +
    ggplot2::scale_colour_viridis_c(option = "C", name = pseudotime_col) +
    ggplot2::coord_equal() +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    ncfigR::nc_theme() +
    ggplot2::theme(axis.text = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank())

  if (!is.null(state_col)) {
    p <- p + ggplot2::facet_wrap(stats::as.formula(paste("~", state_col)))
  }
  p
}

plot_velocity_embedding_panel <- function(data, x_col = "x", y_col = "y",
                                          dx_col = "dx", dy_col = "dy",
                                          state_col = "state",
                                          palette = NULL,
                                          point_size = 0.45, arrow_alpha = 0.65,
                                          arrow_scale = 1,
                                          title = NULL) {
  check_traj_columns(data, c(x_col, y_col, dx_col, dy_col, state_col), "velocity vector data")
  palette <- as_named_palette(palette)
  if (is.null(palette)) {
    palette <- default_traj_palette(data[[state_col]])
  } else {
    ncfigR::validate_palette(data[[state_col]], palette)
  }

  data$xend <- data[[x_col]] + data[[dx_col]] * arrow_scale
  data$yend <- data[[y_col]] + data[[dy_col]] * arrow_scale

  ggplot2::ggplot(
    data,
    ggplot2::aes(x = .data[[x_col]], y = .data[[y_col]], colour = .data[[state_col]])
  ) +
    ggplot2::geom_point(size = point_size, alpha = 0.45, stroke = 0) +
    ggplot2::geom_segment(
      ggplot2::aes(xend = .data$xend, yend = .data$yend),
      alpha = arrow_alpha,
      linewidth = 0.25,
      arrow = grid::arrow(length = grid::unit(1.2, "mm"), type = "closed")
    ) +
    ggplot2::scale_colour_manual(values = palette, name = state_col) +
    ggplot2::coord_equal() +
    ggplot2::labs(title = title, x = NULL, y = NULL) +
    ncfigR::nc_theme() +
    ggplot2::theme(axis.text = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank())
}

plot_branch_probability_panel <- function(data, pseudotime_col = "pseudotime",
                                          branch_col = "branch",
                                          probability_col = "probability",
                                          group_col = NULL,
                                          palette = NULL,
                                          title = NULL) {
  required <- c(pseudotime_col, branch_col, probability_col)
  if (!is.null(group_col)) {
    required <- c(required, group_col)
  }
  check_traj_columns(data, required, "branch probability data")
  palette <- as_named_palette(palette)
  if (is.null(palette)) {
    palette <- default_traj_palette(data[[branch_col]])
  } else {
    ncfigR::validate_palette(data[[branch_col]], palette)
  }

  p <- ggplot2::ggplot(
    data,
    ggplot2::aes(
      x = .data[[pseudotime_col]],
      y = .data[[probability_col]],
      colour = .data[[branch_col]],
      group = .data[[branch_col]]
    )
  ) +
    ggplot2::geom_point(size = 0.7, alpha = 0.3) +
    ggplot2::geom_line(linewidth = 0.65, alpha = 0.9) +
    ggplot2::scale_colour_manual(values = palette, name = branch_col) +
    ggplot2::scale_y_continuous(limits = c(0, 1)) +
    ggplot2::labs(title = title, x = pseudotime_col, y = probability_col) +
    ncfigR::nc_theme()

  if (!is.null(group_col)) {
    p <- p + ggplot2::facet_wrap(stats::as.formula(paste("~", group_col)))
  }
  p
}

plot_gene_trend_panel <- function(data, pseudotime_col = "pseudotime",
                                  value_col = "value", feature_col = "feature",
                                  branch_col = NULL,
                                  title = NULL) {
  required <- c(pseudotime_col, value_col, feature_col)
  if (!is.null(branch_col)) {
    required <- c(required, branch_col)
  }
  check_traj_columns(data, required, "gene trend data")
  data <- data[order(data[[feature_col]], data[[pseudotime_col]]), , drop = FALSE]
  if (is.null(branch_col)) {
    p <- ggplot2::ggplot(
      data,
      ggplot2::aes(x = .data[[pseudotime_col]], y = .data[[value_col]], group = .data[[feature_col]])
    ) +
      ggplot2::geom_point(size = 0.8, alpha = 0.45) +
      ggplot2::geom_line(linewidth = 0.6)
  } else {
    data$trend_group <- interaction(data[[feature_col]], data[[branch_col]], drop = TRUE)
    p <- ggplot2::ggplot(
      data,
      ggplot2::aes(
        x = .data[[pseudotime_col]],
        y = .data[[value_col]],
        colour = .data[[branch_col]],
        group = .data$trend_group
      )
    ) +
      ggplot2::geom_point(size = 0.8, alpha = 0.45) +
      ggplot2::geom_line(linewidth = 0.6)
  }

  p +
    ggplot2::facet_wrap(stats::as.formula(paste("~", feature_col)), scales = "free_y") +
    ggplot2::labs(title = title, x = pseudotime_col, y = value_col) +
    ncfigR::nc_theme()
}

plot_state_transition_panel <- function(data, from_col = "from_state",
                                        to_col = "to_state",
                                        weight_col = "weight",
                                        top_n = 30,
                                        title = NULL) {
  check_traj_columns(data, c(from_col, to_col, weight_col), "state transition data")
  ncfigR::plot_lr_network(
    data = data,
    source_col = from_col,
    target_col = to_col,
    value_col = weight_col,
    top_n = top_n,
    title = title
  )
}

compose_trajectory_figure <- function(trajectory_cells,
                                      branch_probabilities,
                                      gene_trends,
                                      state_transitions,
                                      velocity_vectors = NULL,
                                      title = "Trajectory overview") {
  p_pseudotime <- plot_pseudotime_embedding_panel(
    trajectory_cells,
    title = "Pseudotime map"
  )
  p_branch <- plot_branch_probability_panel(
    branch_probabilities,
    title = "Branch probability"
  )
  p_gene <- plot_gene_trend_panel(
    gene_trends,
    branch_col = if ("branch" %in% names(gene_trends)) "branch" else NULL,
    title = "Gene trend"
  )
  p_transition <- plot_state_transition_panel(
    state_transitions,
    title = "State transition"
  )

  panels <- list(p_pseudotime, p_branch, p_gene, p_transition)
  if (!is.null(velocity_vectors)) {
    panels <- c(
      list(plot_velocity_embedding_panel(velocity_vectors, title = "Velocity / direction")),
      panels
    )
  }

  ncfigR::compose_nc_figure(panels, ncol = 2, title = title)
}
