test_that("communication colors do not change retained scores or conditions", {
  input <- readr::read_tsv(system.file("extdata/lr_pairs.tsv", package = "commfigR"), show_col_types = FALSE)
  a <- compose_communication_overview(input, color_style = "balanced", data.out = TRUE)
  b <- compose_communication_overview(input, color_style = "muted", data.out = TRUE)
  for (table in c("input", "selected", "edges", "totals", "display", "network_edges")) {
    expect_equal(a$data[[table]], b$data[[table]])
  }
  expect_false(identical(a$data$palette, b$data$palette))
  expect_identical(a$data$condition_palette$condition, a$data$conditions)
  expect_equal(nrow(a$data$feature_colors), 256)
})
