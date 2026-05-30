test_that("spatial panel functions return plot objects", {
  coords <- readr::read_tsv(system.file("extdata/spatial_coordinates.tsv", package = "spfigR"), show_col_types = FALSE)
  features <- readr::read_tsv(system.file("extdata/spatial_features.tsv", package = "spfigR"), show_col_types = FALSE)
  composition <- readr::read_tsv(system.file("extdata/spatial_composition.tsv", package = "spfigR"), show_col_types = FALSE)
  regions <- readr::read_tsv(system.file("extdata/spatial_zoom_regions.tsv", package = "spfigR"), show_col_types = FALSE)
  palette <- ncfigR::read_nc_palette(system.file("extdata/domain_palette.tsv", package = "spfigR"))

  expect_s3_class(plot_spatial_domain_panel(coords, palette = palette), "ggplot")
  expect_s3_class(plot_spatial_feature_panel(features), "ggplot")
  expect_s3_class(plot_spatial_feature_panel(features, feature_col = "feature"), "ggplot")
  expect_s3_class(plot_spatial_composition_panel(composition, palette = palette), "ggplot")
  expect_s3_class(plot_spatial_zoom_panel(coords, regions, palette = palette), "ggplot")
})

test_that("spatial niche composition and export work on toy source data", {
  coords <- readr::read_tsv(system.file("extdata/spatial_coordinates.tsv", package = "spfigR"), show_col_types = FALSE)
  features <- readr::read_tsv(system.file("extdata/spatial_features.tsv", package = "spfigR"), show_col_types = FALSE)
  composition <- readr::read_tsv(system.file("extdata/spatial_composition.tsv", package = "spfigR"), show_col_types = FALSE)
  regions <- readr::read_tsv(system.file("extdata/spatial_zoom_regions.tsv", package = "spfigR"), show_col_types = FALSE)
  palette <- ncfigR::read_nc_palette(system.file("extdata/domain_palette.tsv", package = "spfigR"))

  fig <- compose_spatial_niche_figure(coords, features, composition, regions, palette = palette)
  expect_s3_class(fig, "patchwork")

  out_dir <- tempfile("spfigR_export_")
  paths <- ncfigR::export_figure_bundle(fig, "toy_spatial_niche", out_dir = out_dir, width = 6, height = 5)
  expect_true(file.exists(paths$pdf))
  expect_true(file.exists(paths$svg))
  expect_true(file.exists(paths$png))
})

test_that("missing required columns fail early", {
  bad <- data.frame(x = 1, y = 2)
  expect_error(plot_spatial_domain_panel(bad), "missing required columns")
  expect_error(plot_spatial_zoom_panel(bad, data.frame(region_id = "a")), "missing required columns")
})
