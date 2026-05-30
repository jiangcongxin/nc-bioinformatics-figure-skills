test_that("single-cell panel functions return plot objects", {
  embedding <- readr::read_tsv(system.file("extdata/embedding.tsv", package = "scfigR"), show_col_types = FALSE)
  composition <- readr::read_tsv(system.file("extdata/composition.tsv", package = "scfigR"), show_col_types = FALSE)
  markers <- readr::read_tsv(system.file("extdata/marker_dotplot.tsv", package = "scfigR"), show_col_types = FALSE)
  scores <- readr::read_tsv(system.file("extdata/module_scores.tsv", package = "scfigR"), show_col_types = FALSE)
  palette <- ncfigR::read_nc_palette(system.file("extdata/cell_type_palette.tsv", package = "scfigR"))

  expect_s3_class(plot_sc_embedding_panel(embedding, palette = palette), "ggplot")
  expect_s3_class(plot_cell_fraction_panel(composition, palette = palette), "ggplot")
  expect_s3_class(plot_marker_dotplot_panel(markers), "ggplot")
  expect_s3_class(plot_module_score_panel(scores, mode = "embedding"), "ggplot")
  expect_s3_class(plot_module_score_panel(scores, mode = "violin"), "ggplot")
})

test_that("atlas composition and export work on toy source data", {
  embedding <- readr::read_tsv(system.file("extdata/embedding.tsv", package = "scfigR"), show_col_types = FALSE)
  composition <- readr::read_tsv(system.file("extdata/composition.tsv", package = "scfigR"), show_col_types = FALSE)
  markers <- readr::read_tsv(system.file("extdata/marker_dotplot.tsv", package = "scfigR"), show_col_types = FALSE)
  scores <- readr::read_tsv(system.file("extdata/module_scores.tsv", package = "scfigR"), show_col_types = FALSE)
  palette <- ncfigR::read_nc_palette(system.file("extdata/cell_type_palette.tsv", package = "scfigR"))

  fig <- compose_sc_atlas_figure(embedding, composition, markers, scores, palette = palette)
  expect_s3_class(fig, "patchwork")

  out_dir <- tempfile("scfigR_export_")
  paths <- ncfigR::export_figure_bundle(fig, "toy_sc_atlas", out_dir = out_dir, width = 6, height = 5)
  expect_true(file.exists(paths$pdf))
  expect_true(file.exists(paths$svg))
  expect_true(file.exists(paths$png))
})

test_that("missing required columns fail early", {
  bad <- data.frame(x = 1, y = 2)
  expect_error(plot_sc_embedding_panel(bad), "missing required columns")
})
