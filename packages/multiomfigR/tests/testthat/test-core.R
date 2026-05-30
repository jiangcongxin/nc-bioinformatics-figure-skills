library(multiomfigR)

test_that("multi-omics panel functions return plot objects", {
  embedding <- readr::read_tsv(system.file("extdata/integration_embedding.tsv", package = "multiomfigR"), show_col_types = FALSE)
  metrics <- readr::read_tsv(system.file("extdata/modality_metrics.tsv", package = "multiomfigR"), show_col_types = FALSE)
  validation <- readr::read_tsv(system.file("extdata/cross_dataset_validation.tsv", package = "multiomfigR"), show_col_types = FALSE)
  links <- readr::read_tsv(system.file("extdata/feature_links.tsv", package = "multiomfigR"), show_col_types = FALSE)
  programs <- readr::read_tsv(system.file("extdata/pathway_programs.tsv", package = "multiomfigR"), show_col_types = FALSE)

  expect_s3_class(plot_integration_embedding_panel(embedding), "ggplot")
  expect_s3_class(plot_integration_embedding_panel(embedding, shape_col = "modality"), "ggplot")
  expect_s3_class(plot_modality_metric_panel(metrics), "ggplot")
  expect_s3_class(plot_cross_dataset_validation_panel(validation), "ggplot")
  expect_s3_class(plot_feature_link_panel(links), "ggplot")
  expect_s3_class(plot_pathway_program_panel(programs), "ggplot")
})

test_that("multi-omics composition and export work on toy source data", {
  embedding <- readr::read_tsv(system.file("extdata/integration_embedding.tsv", package = "multiomfigR"), show_col_types = FALSE)
  metrics <- readr::read_tsv(system.file("extdata/modality_metrics.tsv", package = "multiomfigR"), show_col_types = FALSE)
  validation <- readr::read_tsv(system.file("extdata/cross_dataset_validation.tsv", package = "multiomfigR"), show_col_types = FALSE)
  links <- readr::read_tsv(system.file("extdata/feature_links.tsv", package = "multiomfigR"), show_col_types = FALSE)
  programs <- readr::read_tsv(system.file("extdata/pathway_programs.tsv", package = "multiomfigR"), show_col_types = FALSE)

  fig <- compose_multiomics_figure(embedding, metrics, validation, links, programs)
  expect_s3_class(fig, "patchwork")

  out_dir <- tempfile("multiomfigR_export_")
  paths <- ncfigR::export_figure_bundle(fig, "toy_multiomics", out_dir = out_dir, width = 7, height = 5)
  expect_true(file.exists(paths$pdf))
  expect_true(file.exists(paths$svg))
  expect_true(file.exists(paths$png))
})

test_that("missing required columns fail early", {
  bad <- data.frame(cell_id = "A", value = 1)
  expect_error(plot_integration_embedding_panel(bad), "missing required columns")
  expect_error(plot_cross_dataset_validation_panel(bad), "missing required columns")
  expect_error(plot_feature_link_panel(bad), "missing required columns")
})
