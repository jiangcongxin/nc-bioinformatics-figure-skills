communication_fixture <- function() {
  readr::read_tsv(system.file("extdata/lr_pairs.tsv", package = "commfigR"), show_col_types = FALSE)
}

test_that("conditions and upstream values stay separate and traceable", {
  x <- communication_fixture()
  z <- prepare_communication_data(x)
  expect_equal(z$input$score, x$score)
  expect_equal(z$edges$score[z$edges$condition == "Disease" & z$edges$source == "T cell"], 1.37)
  expect_equal(z$edges$score[z$edges$condition == "Control" & z$edges$source == "T cell"], 0.70)
  expect_equal(sum(z$totals$score[z$totals$direction == "Outgoing"]), sum(x$score))
  expect_equal(sum(z$totals$score[z$totals$direction == "Incoming"]), sum(x$score))
  expect_equal(prepare_communication_data(x[nrow(x):1, ])$rank, z$rank)
  limited <- prepare_communication_data(x, top_n = 1, max_pairs = 1)
  expect_equal(limited$edges, z$edges)
  expect_equal(nrow(limited$rank), 1)
  expect_lte(length(unique(limited$display$cell_pair)), 1)
  filtered <- prepare_communication_data(x, p_max = 0.05)
  expect_equal(nrow(filtered$selected), 9)
  expect_true(any(filtered$selected$p_value == 0.05))
  expect_equal(nrow(filtered$input), nrow(x))
  expect_equal(sum(filtered$edges$score), sum(x$score[x$p_value <= 0.05]))
})

test_that("bad values and ambiguous keys fail before drawing", {
  x <- communication_fixture()
  expect_error(prepare_communication_data(rbind(x, x[1, ])), "Duplicate")
  for (value in c(NA, Inf, -1)) {
    bad <- x; bad$score[1] <- value
    expect_error(prepare_communication_data(bad))
  }
  bad <- x; bad$source[1] <- " "
  expect_error(prepare_communication_data(bad), "blank")
  bad <- x; bad$p_value[1] <- 1.1
  expect_error(prepare_communication_data(bad), "finite numeric")
  bad <- x; bad$score <- as.character(bad$score)
  expect_error(prepare_communication_data(bad), "finite numeric")
  expect_error(prepare_communication_data(x, top_n = 0), "positive integer")
  expect_error(prepare_communication_data(x, max_pairs = NA), "positive integer")
  expect_error(prepare_communication_data(x, cell_type_order = "T cell"), "all observed")
  expect_error(prepare_communication_data(x, p_max = 0.002), "empty condition")
  expect_error(prepare_communication_data(x, p_max = -1), "p_max")
  bad <- x; bad$score[] <- 1e308
  expect_error(prepare_communication_data(bad), "finite numeric")
  expect_error(prepare_communication_data(x[, names(x) != "p_value"], p_max = 0.05), "p_max")
  expect_error(plot_lr_network_panel(x), "one condition")
  expect_error(compose_communication_figure(x, data.frame()), "non-empty")
})

test_that("CellChat adapter retains complexes and leading-zero labels", {
  x <- data.frame(source = "001", target = "002", ligand = "TGFB1", receptor = "TGFBR1_TGFBR2",
    prob = 0.3, pval = 0, interaction_name = "TGFB1_TGFBR1_TGFBR2")
  z <- as_cellchat_table(x, "LS")
  expect_identical(z$source, "001")
  expect_identical(z$receptor, "TGFBR1_TGFBR2")
  expect_identical(z$score, x$prob)
  expect_identical(z$p_value, x$pval)
  expect_identical(z$interaction_name, x$interaction_name)
  expect_error(as_cellchat_table(z, "NL"), "overwrite")
})

test_that("LR heatmap does not average conditions or lose pair identity", {
  x <- communication_fixture()
  p <- plot_lr_heatmap_panel(x)
  expect_equal(nrow(p$data), nrow(x))
  expect_equal(length(unique(p$data$condition)), 2)
  expect_equal(p$data$score, x$score)
  expect_true(all(c("lr_pair", "cell_pair") %in% names(p$data)))
})
