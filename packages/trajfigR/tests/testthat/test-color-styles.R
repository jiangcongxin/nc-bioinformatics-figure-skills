test_that("all styles build without mutating prototype source tables", {
  files <- c("trajectory_cells.tsv", "branch_probabilities.tsv", "gene_trends.tsv", "state_transitions.tsv", "velocity_vectors.tsv")
  inputs <- lapply(files, function(file) readr::read_tsv(system.file("extdata", file, package = "trajfigR"), show_col_types = FALSE))
  original <- inputs
  for (style in ncfigR::nc_color_styles()$style) {
    plot <- do.call(compose_trajectory_figure, c(inputs, list(color_style = style)))
    expect_no_error(patchwork::patchworkGrob(plot))
    expect_identical(inputs, original)
  }
})
