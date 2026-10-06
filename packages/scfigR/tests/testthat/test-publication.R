test_that("publication layout renders three panels without changing inputs", {
  data <- load_sc_example()
  original <- data$markers
  figure <- compose_sc_publication_figure(data$embedding, data$composition, data$markers)
  expect_s3_class(figure, "patchwork")
  expect_no_error(patchwork::patchworkGrob(figure))
  expect_identical(data$markers, original)
})

publication_inputs <- function() {
  embedding <- data.frame(cell_id = c("c1", "c2", "c3"), x = c(0, 1, 2), y = c(0, 2, 1),
    cell_type = c("T", "T", "B"), sample = "sample")
  expression <- expand.grid(cell_id = embedding$cell_id, feature = c("g1", "g2", "g3"),
    stringsAsFactors = FALSE)
  expression$value <- c(2, 1, 0, 0, 0, 3, 1, 1, 1)
  list(atlas = prepare_sc_atlas_data(embedding, expression), expression = expression)
}

test_that("publication maps keep sparse examples visible without enlarging dense atlases", {
  sparse <- publication_inputs()$atlas$embedding
  dense <- sparse[rep(seq_len(nrow(sparse)), 1000L), ]
  palette <- c(T = "#5479A5", B = "#8BA9C7")
  expect_equal(scfigR:::publication_map(sparse, "cell_type", palette)$layers[[1]]$aes_params$size, 1.2)
  expect_equal(scfigR:::publication_map(dense, "cell_type", palette)$layers[[1]]$aes_params$size, .22)
})

test_that("publication layout renders six panels with complete expression", {
  inputs <- publication_inputs()
  figure <- do.call(compose_sc_publication_figure,
    c(inputs$atlas, list(expression = inputs$expression, feature_genes = c("g1", "g2", "g3"))))
  expect_no_error(patchwork::patchworkGrob(figure))
  paths <- ncfigR::export_figure_bundle(figure, "publication", tempfile(),
    width = 183 / 25.4, height = 126 / 25.4)
  expect_true(all(file.info(unlist(paths))$size > 0))
})

test_that("publication layout rejects ambiguous feature maps and inconsistent counts", {
  inputs <- publication_inputs()
  render <- function(expression, genes = c("g1", "g2", "g3")) do.call(compose_sc_publication_figure,
    c(inputs$atlas, list(expression = expression, feature_genes = genes)))
  expect_error(render(inputs$expression, c("g1", "g1", "g3")), "three distinct")
  expect_error(render(inputs$expression, c("g1", "g2", "missing")), "absent")
  expect_error(render(inputs$expression[-1, ]), "every cell")
  negative <- inputs$expression; negative$value[1] <- -1
  expect_error(render(negative), "non-negative")
  inputs$atlas$composition$n[1] <- 10
  expect_error(do.call(compose_sc_publication_figure, inputs$atlas), "counts and proportions")
})
