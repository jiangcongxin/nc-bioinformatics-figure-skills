test_that("communication panel functions return plot objects", {
  lr <- readr::read_tsv(system.file("extdata/lr_pairs.tsv", package = "commfigR"), show_col_types = FALSE)
  scores <- readr::read_tsv(system.file("extdata/communication_scores.tsv", package = "commfigR"), show_col_types = FALSE)
  diff <- readr::read_tsv(system.file("extdata/differential_lr.tsv", package = "commfigR"), show_col_types = FALSE)
  edges <- readr::read_tsv(system.file("extdata/network_edges.tsv", package = "commfigR"), show_col_types = FALSE)

  expect_s3_class(plot_lr_heatmap_panel(lr), "ggplot")
  expect_s3_class(plot_lr_heatmap_panel(lr, condition_col = "condition"), "ggplot")
  expect_s3_class(plot_lr_network_panel(edges, value_col = "weight"), "ggplot")
  expect_s3_class(plot_sender_receiver_score_panel(scores), "ggplot")
  expect_s3_class(plot_sender_receiver_score_panel(scores, condition_col = "condition"), "ggplot")
  expect_s3_class(plot_differential_communication_panel(diff), "ggplot")
})

test_that("communication composition and export work on toy source data", {
  lr <- readr::read_tsv(system.file("extdata/lr_pairs.tsv", package = "commfigR"), show_col_types = FALSE)
  scores <- readr::read_tsv(system.file("extdata/communication_scores.tsv", package = "commfigR"), show_col_types = FALSE)
  diff <- readr::read_tsv(system.file("extdata/differential_lr.tsv", package = "commfigR"), show_col_types = FALSE)
  edges <- readr::read_tsv(system.file("extdata/network_edges.tsv", package = "commfigR"), show_col_types = FALSE)

  fig <- compose_communication_figure(lr, scores, diff, edges)
  expect_s3_class(fig, "patchwork")

  out_dir <- tempfile("commfigR_export_")
  paths <- ncfigR::export_figure_bundle(fig, "toy_communication", out_dir = out_dir, width = 7, height = 5)
  expect_true(file.exists(paths$pdf))
  expect_true(file.exists(paths$svg))
  expect_true(file.exists(paths$png))
})

test_that("missing required columns fail early", {
  bad <- data.frame(source = "A", target = "B")
  expect_error(plot_lr_heatmap_panel(bad), "missing required columns")
  expect_error(plot_differential_communication_panel(bad), "missing required columns")
})
