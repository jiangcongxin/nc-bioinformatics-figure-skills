atlas_inputs <- function() {
  embedding <- data.frame(cell_id = c("c1", "c2", "c3"), x = 1:3, y = 3:1,
    cell_type = c("T", "T", "B"), sample = c("s1", "s2", "s2"))
  expression <- expand.grid(cell_id = embedding$cell_id, feature = c("CD3D", "MS4A1"),
    stringsAsFactors = FALSE)
  expression$value <- c(2, 0, 0, 0, 0, 3)
  list(embedding = embedding, expression = expression)
}

test_that("cell-level preparation uses all cells including zeros", {
  inputs <- atlas_inputs()
  data <- prepare_sc_atlas_data(inputs$embedding, inputs$expression)
  expect_equal(as.numeric(tapply(data$composition$proportion, data$composition$group, sum)), c(1, 1))
  t_marker <- subset(data$markers, feature == "CD3D" & cell_type == "T")
  expect_equal(t_marker$avg_expression, 1)
  expect_equal(t_marker$pct_expression, .5)
  expect_equal(t_marker$n_cells, 2)
  expect_equal(subset(data$composition, group == "s1" & cell_type == "B")$n, 0)
  expect_no_error(patchwork::patchworkGrob(do.call(compose_sc_atlas_figure, data)))
})

test_that("incomplete or ambiguous expression is rejected", {
  inputs <- atlas_inputs()
  expect_error(prepare_sc_atlas_data(inputs$embedding, inputs$expression[-1, ]), "every cell-feature pair")
  bad <- inputs$expression; bad$cell_id[1] <- "unknown"
  expect_error(prepare_sc_atlas_data(inputs$embedding, bad), "exactly the same")
  expect_error(prepare_sc_atlas_data(inputs$embedding, rbind(inputs$expression, inputs$expression[1, ])), "duplicate")
  bad <- inputs$expression; bad$value[1] <- NA_real_
  expect_error(prepare_sc_atlas_data(inputs$embedding, bad), "missing")
  expect_error(prepare_sc_atlas_data(inputs$embedding, inputs$expression, detection_threshold = Inf), "finite")
})

test_that("dot sizes use fractions on a fixed area scale", {
  data <- load_sc_example()$markers
  bad <- data; bad$pct_expression[1] <- 80
  expect_error(plot_marker_dotplot_panel(bad), "fraction")
  expect_error(plot_marker_dotplot_panel(rbind(data, data[1, ])), "duplicate")
  expect_error(plot_marker_dotplot_panel(data, expression_limits = c(1, 0)), "increasing")
  data$pct_expression[1] <- 0
  p <- plot_marker_dotplot_panel(data, feature_order = rev(unique(data$feature)))
  expect_identical(levels(p$data$feature), rev(unique(data$feature)))
  expect_equal(ggplot2::ggplot_build(p)$data[[1]]$size[1], 0)
  expect_no_error(ggplot2::ggplotGrob(p))
})

test_that("atlas panels share categories, order, and colors", {
  data <- load_sc_example()
  data$composition <- data$composition[nrow(data$composition):1, ]
  data$palette <- NULL
  fig <- do.call(compose_sc_atlas_figure, data)
  expect_no_error(patchwork::patchworkGrob(fig))
  embedding <- fig$patches$plots[[1]]
  fractions <- fig$patches$plots[[2]]
  expect_identical(levels(embedding$data$cell_type), levels(fractions$data$cell_type))
  expect_identical(embedding$scales$get_scales("colour")$palette(4),
                   fractions$scales$get_scales("fill")$palette(4))
  data$markers$cell_type[1] <- "unknown"
  expect_error(do.call(compose_sc_atlas_figure, data), "same cell-type")
})

test_that("module scores must have finite numerical values", {
  data <- load_sc_example()$module_scores
  data$score[1] <- Inf
  expect_error(plot_module_score_panel(data), "finite numeric")
  data$score <- as.character(data$score)
  expect_error(plot_module_score_panel(data, mode = "violin"), "finite numeric")
})

test_that("facets accept non-syntactic column names", {
  data <- load_sc_example()$module_scores
  data[["module name"]] <- data$module
  expect_no_error(ggplot2::ggplotGrob(plot_module_score_panel(data, facet_col = "module name")))
})
