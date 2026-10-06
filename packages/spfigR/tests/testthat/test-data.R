test_that("section-aware keys preserve repeated barcodes and explicit zeros", {
  x <- spatial_fixture()
  z <- prepare_spatial_data(x$coordinates, x$features, expression_scale = "log_normalized")
  expect_equal(nrow(z$coordinates), 8)
  expect_equal(nrow(z$mapped_features), 8)
  expect_equal(sum(z$features$value == 0), 2)
  expect_equal(z$composition$proportion[z$composition$section_id == "S1" & z$composition$domain == "Core"], 0.5)
  expect_equal(z$composition$proportion[z$composition$section_id == "S2" & z$composition$domain == "Edge"], 0)
  expect_equal(as.numeric(tapply(z$composition$proportion, z$composition$section_id, sum)), c(1, 1))
  expect_identical(z$coordinates$spot_id[1], "001")
  expect_equal(z$feature_limits, c(0, 1.2))
})

test_that("incomplete feature universes and ambiguous geometry fail", {
  x <- spatial_fixture()
  run <- function(c = x$coordinates, f = x$features, ...) prepare_spatial_data(c, f, expression_scale = "log_normalized", ...)
  expect_error(run(f = x$features[-1, ]), "every section/spot/feature")
  expect_error(run(f = rbind(x$features, x$features[1, ])), "Duplicate keys")
  expect_error(run(c = rbind(x$coordinates, x$coordinates[1, ])), "Duplicate keys")
  bad <- x$features; bad$spot_id[1] <- "unknown"
  expect_error(run(f = bad), "every section/spot/feature")
  bad <- x$features; bad$value[1] <- -1
  expect_error(run(f = bad), ">= 0")
  bad <- x$features; bad$x <- 1
  expect_error(run(f = bad), "conflicting")
  bad <- x$coordinates; bad$y <- 0
  expect_error(run(c = bad), "Degenerate")
  bad <- x$coordinates; bad$x[1] <- Inf
  expect_error(run(c = bad), "non-finite")
  bad <- x$coordinates; bad$domain[1] <- " "
  expect_error(run(c = bad), "blank")
  bad <- x$coordinates; bad[1, c("x", "y")] <- bad[2, c("x", "y")]
  expect_error(run(c = bad), "Duplicate keys")
  expect_error(run(feature_order = "absent"), "every observed")
  expect_error(prepare_spatial_data(x$coordinates, x$features), "Declare expression_scale")
  score <- x$features; score$value[1] <- -2
  expect_equal(prepare_spatial_data(x$coordinates, score, expression_scale = "signed_score")$feature_limits, c(-2, 2))
})

test_that("ROI membership is section-specific, inclusive and never a fraction denominator", {
  x <- spatial_fixture()
  regions <- data.frame(section_id = "S1", region_id = "ROI", xmin = 0, xmax = 0.5, ymin = 0, ymax = 1)
  z <- prepare_spatial_data(x$coordinates, x$features, regions, "log_normalized")
  expect_equal(nrow(z$zoom), 2)
  expect_identical(unique(z$zoom$section_id), "S1")
  expect_equal(sum(z$composition$spots), 8)
  regions$section_id <- "missing"
  expect_error(prepare_spatial_data(x$coordinates, x$features, regions, "log_normalized"), "observed section")
  regions$section_id <- "S1"; regions$xmin <- 5; regions$xmax <- 6
  expect_error(prepare_spatial_data(x$coordinates, x$features, regions, "log_normalized"), "Empty zoom")
  regions$xmax <- 4
  expect_error(prepare_spatial_data(x$coordinates, x$features, regions, "log_normalized"), "increasing bounds")
})

test_that("map panels preserve section and color limits with explicit y direction", {
  x <- spatial_fixture()
  z <- compose_spatial_overview(x$coordinates, x$features, expression_scale = "log_normalized",
    coordinate_unit = "pixel", y_axis = "down", data.out = TRUE)
  expect_s3_class(z$plot, "patchwork")
  expect_equal(z$data$coordinates$x, x$coordinates$x)
  expect_equal(z$data$coordinates$y, x$coordinates$y)
  expect_equal(z$data$feature_limits, c(0, 1.2))
  domain <- z$plot[[1]]
  mapped <- ggplot2::ggplot_build(domain)$data[[1]]
  expect_equal(mapped$y, -x$coordinates$y[x$coordinates$section_id == "S1"])
  feature <- z$plot[[2]]
  expect_equal(feature$scales$get_scales("colour")$limits, c(0, 1.2))
  expect_error(compose_spatial_overview(x$coordinates, x$features, expression_scale = "log_normalized"), "coordinate_unit")
})
