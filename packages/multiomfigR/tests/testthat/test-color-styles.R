test_that("supported styles build and insufficient color capacity fails explicitly", {
  files <- c("integration_embedding.tsv", "modality_metrics.tsv", "cross_dataset_validation.tsv", "feature_links.tsv", "pathway_programs.tsv")
  inputs <- lapply(files, function(file) readr::read_tsv(system.file("extdata", file, package = "multiomfigR"), show_col_types = FALSE))
  original <- inputs
  for (style in c("balanced", "muted", "vivid")) {
    plot <- do.call(compose_multiomics_figure, c(inputs, list(color_style = style)))
    expect_no_error(patchwork::patchworkGrob(plot))
    expect_identical(inputs, original)
  }
  expect_error(do.call(compose_multiomics_figure, c(inputs, list(color_style = "okabe_ito"))), "at most 9")
})
