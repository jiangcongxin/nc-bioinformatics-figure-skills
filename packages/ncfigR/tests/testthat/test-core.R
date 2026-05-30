test_that("palette validation works", {
  pal <- c(T_cell = "#1F77B4", B_cell = "#FF7F0E")
  expect_true(isTRUE(validate_palette(c("T_cell", "B_cell"), pal)))
  expect_error(validate_palette(c("T_cell", "Myeloid"), pal), "missing")
})

test_that("panel functions return ggplot objects", {
  embedding <- readr::read_tsv(system.file("extdata/embedding.tsv", package = "ncfigR"), show_col_types = FALSE)
  comp <- readr::read_tsv(system.file("extdata/composition.tsv", package = "ncfigR"), show_col_types = FALSE)
  markers <- readr::read_tsv(system.file("extdata/marker_matrix.tsv", package = "ncfigR"), show_col_types = FALSE)
  lr <- readr::read_tsv(system.file("extdata/lr_pairs.tsv", package = "ncfigR"), show_col_types = FALSE)
  traj <- readr::read_tsv(system.file("extdata/trajectory.tsv", package = "ncfigR"), show_col_types = FALSE)
  bench <- readr::read_tsv(system.file("extdata/benchmark_metrics.tsv", package = "ncfigR"), show_col_types = FALSE)

  expect_s3_class(plot_embedding_panel(embedding), "ggplot")
  expect_s3_class(plot_composition_panel(comp), "ggplot")
  expect_s3_class(plot_marker_heatmap(markers), "ggplot")
  expect_s3_class(plot_lr_heatmap(lr), "ggplot")
  expect_s3_class(plot_lr_network(lr, top_n = 5), "ggplot")
  expect_s3_class(plot_trajectory_trend(traj), "ggplot")
  expect_s3_class(plot_benchmark_heatmap(bench), "ggplot")
})

test_that("compose and export bundle work", {
  embedding <- readr::read_tsv(system.file("extdata/embedding.tsv", package = "ncfigR"), show_col_types = FALSE)
  comp <- readr::read_tsv(system.file("extdata/composition.tsv", package = "ncfigR"), show_col_types = FALSE)
  p1 <- plot_embedding_panel(embedding)
  p2 <- plot_composition_panel(comp)
  fig <- compose_nc_figure(list(p1, p2), ncol = 2)
  expect_s3_class(fig, "patchwork")

  out_dir <- tempfile("ncfigR_export_")
  paths <- export_figure_bundle(fig, "toy_fig", out_dir = out_dir, width = 5, height = 3)
  expect_true(file.exists(paths$pdf))
  expect_true(file.exists(paths$svg))
  expect_true(file.exists(paths$png))
})
