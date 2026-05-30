library(trajfigR)

test_that("trajectory panel functions return plot objects", {
  cells <- readr::read_tsv(system.file("extdata/trajectory_cells.tsv", package = "trajfigR"), show_col_types = FALSE)
  branches <- readr::read_tsv(system.file("extdata/branch_probabilities.tsv", package = "trajfigR"), show_col_types = FALSE)
  trends <- readr::read_tsv(system.file("extdata/gene_trends.tsv", package = "trajfigR"), show_col_types = FALSE)
  transitions <- readr::read_tsv(system.file("extdata/state_transitions.tsv", package = "trajfigR"), show_col_types = FALSE)
  velocity <- readr::read_tsv(system.file("extdata/velocity_vectors.tsv", package = "trajfigR"), show_col_types = FALSE)

  expect_s3_class(plot_pseudotime_embedding_panel(cells), "ggplot")
  expect_s3_class(plot_pseudotime_embedding_panel(cells, state_col = "state"), "ggplot")
  expect_s3_class(plot_velocity_embedding_panel(velocity), "ggplot")
  expect_s3_class(plot_branch_probability_panel(branches), "ggplot")
  expect_s3_class(plot_branch_probability_panel(branches, group_col = "stage"), "ggplot")
  expect_s3_class(plot_gene_trend_panel(trends, branch_col = "branch"), "ggplot")
  expect_s3_class(plot_state_transition_panel(transitions), "ggplot")
})

test_that("trajectory composition and export work on toy source data", {
  cells <- readr::read_tsv(system.file("extdata/trajectory_cells.tsv", package = "trajfigR"), show_col_types = FALSE)
  branches <- readr::read_tsv(system.file("extdata/branch_probabilities.tsv", package = "trajfigR"), show_col_types = FALSE)
  trends <- readr::read_tsv(system.file("extdata/gene_trends.tsv", package = "trajfigR"), show_col_types = FALSE)
  transitions <- readr::read_tsv(system.file("extdata/state_transitions.tsv", package = "trajfigR"), show_col_types = FALSE)
  velocity <- readr::read_tsv(system.file("extdata/velocity_vectors.tsv", package = "trajfigR"), show_col_types = FALSE)

  fig <- compose_trajectory_figure(cells, branches, trends, transitions, velocity)
  expect_s3_class(fig, "patchwork")

  out_dir <- tempfile("trajfigR_export_")
  paths <- ncfigR::export_figure_bundle(fig, "toy_trajectory", out_dir = out_dir, width = 7, height = 5)
  expect_true(file.exists(paths$pdf))
  expect_true(file.exists(paths$svg))
  expect_true(file.exists(paths$png))
})

test_that("missing required columns fail early", {
  bad <- data.frame(cell_id = "A", pseudotime = 0.1)
  expect_error(plot_pseudotime_embedding_panel(bad), "missing required columns")
  expect_error(plot_branch_probability_panel(bad), "missing required columns")
  expect_error(plot_state_transition_panel(bad), "missing required columns")
})
