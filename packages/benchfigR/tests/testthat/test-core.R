library(benchfigR)

test_that("benchmark panel functions return plot objects", {
  metrics <- readr::read_tsv(system.file("extdata/benchmark_metrics.tsv", package = "benchfigR"), show_col_types = FALSE)
  ranks <- readr::read_tsv(system.file("extdata/benchmark_ranks.tsv", package = "benchfigR"), show_col_types = FALSE)
  runtime <- readr::read_tsv(system.file("extdata/runtime_metrics.tsv", package = "benchfigR"), show_col_types = FALSE)
  robustness <- readr::read_tsv(system.file("extdata/robustness_metrics.tsv", package = "benchfigR"), show_col_types = FALSE)
  case <- readr::read_tsv(system.file("extdata/case_embedding.tsv", package = "benchfigR"), show_col_types = FALSE)

  expect_s3_class(plot_metric_heatmap_panel(metrics), "ggplot")
  expect_s3_class(plot_rank_panel(ranks), "ggplot")
  expect_s3_class(plot_rank_panel(ranks, value_col = "value"), "ggplot")
  expect_s3_class(plot_runtime_panel(runtime), "ggplot")
  expect_s3_class(plot_runtime_panel(runtime, memory_col = "memory_gb"), "ggplot")
  expect_s3_class(plot_robustness_panel(robustness), "ggplot")
  expect_s3_class(plot_case_embedding_panel(case), "ggplot")
  expect_s3_class(plot_case_embedding_panel(case, score_col = "score"), "ggplot")
})

test_that("benchmark composition and export work on toy source data", {
  metrics <- readr::read_tsv(system.file("extdata/benchmark_metrics.tsv", package = "benchfigR"), show_col_types = FALSE)
  ranks <- readr::read_tsv(system.file("extdata/benchmark_ranks.tsv", package = "benchfigR"), show_col_types = FALSE)
  runtime <- readr::read_tsv(system.file("extdata/runtime_metrics.tsv", package = "benchfigR"), show_col_types = FALSE)
  robustness <- readr::read_tsv(system.file("extdata/robustness_metrics.tsv", package = "benchfigR"), show_col_types = FALSE)
  case <- readr::read_tsv(system.file("extdata/case_embedding.tsv", package = "benchfigR"), show_col_types = FALSE)

  fig <- compose_benchmark_case_figure(metrics, ranks, runtime, robustness, case)
  expect_s3_class(fig, "patchwork")

  out_dir <- tempfile("benchfigR_export_")
  paths <- ncfigR::export_figure_bundle(fig, "toy_benchmark_case", out_dir = out_dir, width = 7, height = 5)
  expect_true(file.exists(paths$pdf))
  expect_true(file.exists(paths$svg))
  expect_true(file.exists(paths$png))
})

test_that("missing required columns fail early", {
  bad <- data.frame(method = "A", value = 1)
  expect_error(plot_metric_heatmap_panel(bad), "missing required columns")
  expect_error(plot_rank_panel(bad), "missing required columns")
  expect_error(plot_case_embedding_panel(bad), "missing required columns")
})
