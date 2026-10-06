test_that("styles call upstream palettes and never recycle categorical colors", {
  expect_equal(sp_color_styles()$style, c("balanced", "muted", "vivid", "okabe_ito"))
  labels <- paste0("Type", 1:8)
  for (style in sp_color_styles()$style) {
    x <- sp_color_scheme(labels, style)
    expect_identical(names(x$domain_colors), labels)
    expect_equal(length(unique(x$domain_colors)), 8)
    expect_equal(nrow(x$preview), 8)
    expect_true(all(c("deutan", "protan", "tritan") %in% names(x$preview)))
  }
  expect_error(sp_color_scheme(paste0("Type", 1:10), "okabe_ito"), "at most 9")
  expect_error(sp_color_scheme(labels, "absent"), "Unknown color_style")
  expect_error(sp_color_scheme(labels, feature_palette = "roma"), "match the declared")
  expect_error(sp_color_scheme(labels, expression_scale = "signed_score", feature_palette = "lapaz"), "match the declared")
  expect_equal(sp_color_scheme(labels, expression_scale = "signed_score")$feature_palette, "vik")
  expect_error(sp_color_scheme(c("A", "B"), palette = c(A = "red", B = "#FF0000")), "equivalent")
  expect_error(sp_color_scheme(c("A", "B"), palette = c(A = "#FF000080", B = "blue")), "opaque")
})

test_that("explicit colors keep group identity and new styles preserve scientific values", {
  x <- spatial_fixture()
  custom <- c(Stroma = "#AA3377", Edge = "#EE7733", Core = "#0077BB")
  resolve <- sp_color_scheme(c("Core", "Edge", "Stroma"), palette = custom)
  expect_equal(resolve$domain_colors, custom[c("Core", "Edge", "Stroma")])
  balanced <- compose_spatial_overview(x$coordinates, x$features, expression_scale = "log_normalized",
    coordinate_unit = "arbitrary", y_axis = "up", color_style = "balanced", data.out = TRUE)
  muted <- compose_spatial_overview(x$coordinates, x$features, expression_scale = "log_normalized",
    coordinate_unit = "arbitrary", y_axis = "up", color_style = "muted", data.out = TRUE)
  expect_equal(balanced$data$coordinates, muted$data$coordinates)
  expect_equal(balanced$data$features, muted$data$features)
  expect_equal(balanced$data$composition, muted$data$composition)
  expect_equal(balanced$data$feature_limits, muted$data$feature_limits)
  expect_false(identical(balanced$data$palette, muted$data$palette))
  expect_equal(balanced$data$feature_colors$color, scico::scico(256, palette = "lapaz", direction = -1))
  expect_equal(balanced$plot[[2]]$scales$get_scales("colour")$limits, c(0, 1.2))
  points <- ggplot2::ggplot_build(balanced$plot[[2]])$data
  expect_equal(nrow(points[[1]]), nrow(points[[2]]))
  expect_equal(points[[1]]$colour, rep("#DADADA", nrow(points[[1]])))
  expect_equal(points[[1]]$size - points[[2]]$size, rep(0.12, nrow(points[[1]])))
  expect_equal(balanced$plot[[1]]$theme$plot.tag.position, "topleft")
})
