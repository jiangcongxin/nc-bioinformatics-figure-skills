test_that("coordinated styles preserve explicit category colors and scale semantics", {
  labels <- c("T", "B", "Mono")
  schemes <- lapply(nc_color_styles()$style, function(style) nc_color_scheme(labels, style))
  for (scheme in schemes) {
    expect_identical(names(scheme$colors), labels)
    expect_length(unique(scheme$colors), 3)
    expect_equal(nrow(scheme$feature_colors), 256)
    expect_identical(scheme$preview$category, labels)
  }
  custom <- c(T = "#112233", B = "#445566", Mono = "#778899")
  expect_equal(nc_color_scheme(labels, "vivid", palette = custom)$colors, custom)
  expect_error(nc_color_scheme(as.character(1:10), "okabe_ito"), "at most 9")
  expect_error(nc_color_scheme(labels, palette = c(T = "red", B = "#FF0000", Mono = "blue")), "distinct")
  expect_error(nc_color_scheme(labels, feature_palette = "vik"), "match")
  expect_error(nc_color_scheme(labels, expression_scale = "signed_score", feature_palette = "batlow"), "match")
  scale <- nc_continuous_scale(signed = TRUE, limits = c(-1, 2))
  expect_equal(scale$rescale(0), 0.5)
})

test_that("changing presentation does not mutate embedding or heatmap values", {
  data <- data.frame(x = c(0, 1, 2), y = c(2, 0, 1), cell_type = c("T", "B", "Mono"))
  a <- plot_embedding_panel(data, color_style = "balanced")
  b <- plot_embedding_panel(data, color_style = "muted")
  expect_equal(a$data, b$data)
  expect_false(identical(a$scales$get_scales("colour")$palette(3), b$scales$get_scales("colour")$palette(3)))
  values <- data.frame(feature = c("g1", "g2"), cell_type = "T", value = c(-1, 2))
  expect_equal(plot_marker_heatmap(values, color_style = "balanced")$data,
               plot_marker_heatmap(values, color_style = "vivid")$data)
})
