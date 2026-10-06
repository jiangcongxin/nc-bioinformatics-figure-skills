marker_interface_inputs <- function() {
  embedding <- data.frame(cell_id = c("c1", "c2", "c3"), x = c(0, 1, 2), y = c(0, 2, 1),
    cell_type = c("T", "T", "B"), sample = "sample")
  expression <- expand.grid(cell_id = embedding$cell_id, feature = c("g1", "g2", "g3"), stringsAsFactors = FALSE)
  expression$value <- c(2, 1, 0, 0, 0, 3, 1, 1, 1)
  list(atlas = prepare_sc_atlas_data(embedding, expression), expression = expression)
}

test_that("marker groups preserve values and return explicit plot data", {
  inputs <- marker_interface_inputs()
  markers <- inputs$atlas$markers
  original <- markers
  groups <- list(First = c("g1", "g2"), Second = "g3")
  result <- plot_marker_dotplot_panel(markers, marker_groups = groups, data.out = TRUE)
  expect_s3_class(result$plot, "ggplot")
  expect_identical(result$data$avg_expression, markers$avg_expression)
  expect_identical(result$data$pct_expression, markers$pct_expression)
  expect_identical(levels(result$data$feature), c("g1", "g2", "g3"))
  expect_identical(levels(result$data$marker_group), c("First", "Second"))
  expect_identical(markers, original)
  expect_no_error(ggplot2::ggplotGrob(result$plot))
  expect_error(plot_marker_dotplot_panel(markers, marker_groups = list(A = "g1")), "every observed")
  expect_error(plot_marker_dotplot_panel(markers, marker_groups = list(A = c("g1", "g2"), B = c("g1", "g3"))), "every observed")
  expect_error(plot_marker_dotplot_panel(markers, marker_groups = groups, feature_order = c("g3", "g2", "g1")), "flattened")
  expect_error(plot_marker_dotplot_panel(markers, marker_groups = list(c("g1", "g2", "g3"))), "named list")
  expect_error(plot_marker_dotplot_panel(markers, data.out = NA), "data.out")
})

test_that("publication data output separates supplied means from display transformation", {
  inputs <- marker_interface_inputs()
  render <- function(...) do.call(compose_sc_publication_figure,
    c(inputs$atlas, list(expression = inputs$expression, feature_genes = c("g1", "g2", "g3"),
      marker_groups = list(First = c("g1", "g2"), Second = "g3"), data.out = TRUE), list(...)))
  result <- render()
  expect_s3_class(result$plot, "patchwork")
  expect_identical(result$data$markers$avg_expression, inputs$atlas$markers$avg_expression)
  expect_identical(result$data$markers$pct_expression, inputs$atlas$markers$pct_expression)
  expect_identical(result$data$embedding, inputs$atlas$embedding)
  expect_identical(result$data$expression, inputs$expression)
  expect_true(all(is.finite(result$data$markers$plot_expression)))
  expect_no_error(patchwork::patchworkGrob(result$plot))
  raw <- render(marker_scale = "raw")
  expect_identical(raw$data$markers$plot_expression, raw$data$markers$avg_expression)
  expect_identical(levels(result$data$markers$feature), c("g1", "g2", "g3"))
})

test_that("standard atlas supports the same optional source-data interface", {
  inputs <- marker_interface_inputs()
  result <- do.call(compose_sc_atlas_figure, c(inputs$atlas,
    list(marker_groups = list(First = c("g1", "g2"), Second = "g3"), data.out = TRUE)))
  expect_s3_class(result$plot, "patchwork")
  expect_identical(result$data$markers$avg_expression, inputs$atlas$markers$avg_expression)
  expect_no_error(patchwork::patchworkGrob(result$plot))
})
