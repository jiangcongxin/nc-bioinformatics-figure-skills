test_that("all styles build without mutating prototype source tables", {
  files <- c("benchmark_metrics.tsv", "benchmark_ranks.tsv", "runtime_metrics.tsv", "robustness_metrics.tsv", "case_embedding.tsv")
  inputs <- lapply(files, function(file) readr::read_tsv(system.file("extdata", file, package = "benchfigR"), show_col_types = FALSE))
  original <- inputs
  for (style in ncfigR::nc_color_styles()$style) {
    plot <- do.call(compose_benchmark_case_figure, c(inputs, list(color_style = style)))
    expect_no_error(patchwork::patchworkGrob(plot))
    expect_identical(inputs, original)
  }
})
