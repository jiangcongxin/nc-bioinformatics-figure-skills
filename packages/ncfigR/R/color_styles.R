#' Available coordinated figure color styles
#' @return Table of style names and their categorical, sequential and diverging bases.
#' @export
nc_color_styles <- function() {
  data.frame(style = c("balanced", "muted", "vivid", "okabe_ito"),
    categorical = c("colorspace Dark 2", "colorspace Set 2", "colorspace Dark 3", "R Okabe-Ito"),
    sequential = c("lapaz", "lajolla", "batlow", "grayC"),
    diverging = c("vik", "broc", "roma", "vik"),
    max_categories = c(64L, 64L, 64L, 9L))
}

#' Build a coordinated continuous color scale
#' @param aesthetic colour or fill.
#' @param color_style Coordinated style name.
#' @param signed Use a diverging palette centered at zero by symmetric limits.
#' @param feature_palette Optional scale-compatible scico palette.
#' @param ... Additional arguments passed to scale_colour_gradientn or scale_fill_gradientn.
#' @return A ggplot2 scale. Supplied data values are not modified.
#' @export
nc_continuous_scale <- function(aesthetic = "colour", color_style = "balanced", signed = FALSE,
                                feature_palette = NULL, ...) {
  if (!is.character(aesthetic) || length(aesthetic) != 1L || !aesthetic %in% c("colour", "fill")) stop("aesthetic must be colour or fill.")
  if (!is.logical(signed) || length(signed) != 1L || is.na(signed)) stop("signed must be TRUE or FALSE.")
  scheme <- nc_color_scheme("value", color_style, if (signed) "signed_score" else "log_normalized", feature_palette = feature_palette)
  arguments <- list(...)
  if (signed && is.null(arguments$limits)) arguments$limits <- function(x) c(-1, 1) * max(1e-12, abs(x))
  if (signed && is.null(arguments$rescaler)) arguments$rescaler <- function(x, to = c(0, 1), from = range(x, na.rm = TRUE)) scales::rescale_mid(x, to, from, mid = 0)
  do.call(if (aesthetic == "fill") ggplot2::scale_fill_gradientn else ggplot2::scale_colour_gradientn,
    c(list(colours = scheme$feature_colors$color), arguments))
}

#' Resolve an explicit, coordinated figure palette
#' @param categories Unique annotation labels in their intended display order.
#' @param style balanced, muted, vivid or okabe_ito.
#' @param expression_scale counts, log_normalized or signed_score.
#' @param palette Optional user-supplied named colors or domain/color table.
#' @param feature_palette Optional supported scico palette with matching scale semantics.
#' @return Named domain colors, feature palette and color-vision preview table.
#' @export
nc_color_scheme <- function(categories, style = "balanced", expression_scale = "log_normalized",
                            palette = NULL, feature_palette = NULL) {
  styles <- nc_color_styles()
  if (!is.character(style) || length(style) != 1L || is.na(style) || !style %in% styles$style) stop("Unknown color_style; use balanced, muted, vivid or okabe_ito.")
  if (!is.character(categories) || !length(categories) || anyNA(categories) || any(!nzchar(trimws(categories))) || anyDuplicated(categories)) stop("categories must be unique non-empty labels.")
  if (!is.character(expression_scale) || length(expression_scale) != 1L || is.na(expression_scale) || !expression_scale %in% c("counts", "log_normalized", "signed_score")) stop("Declare a supported expression_scale.")
  row <- styles[styles$style == style, ]
  colors <- named_palette(palette)
  if (is.null(colors)) {
    if (length(categories) > row$max_categories) stop("This color_style supports at most ", row$max_categories, " categories; choose another style or supply an explicit palette.")
    colors <- if (style == "okabe_ito") grDevices::palette.colors(palette = "Okabe-Ito")[c(6, 7, 4, 8, 2, 3, 1, 5, 9)][seq_along(categories)] else
      colorspace::qualitative_hcl(length(categories), palette = sub("colorspace ", "", row$categorical, fixed = TRUE))
    if (style == "muted") colors <- colorspace::qualitative_hcl(length(categories), palette = "Set 2", c = 35, l = 65)
    colors <- stats::setNames(unname(colors), categories)
  }
  validate_palette(categories, colors)
  colors <- colors[categories]
  rgba <- grDevices::col2rgb(colors, alpha = TRUE)
  if (any(rgba[4, ] != 255)) stop("Annotation colors must be opaque; transparent keys do not match the displayed colors.")
  normalized <- grDevices::rgb(rgba[1, ], rgba[2, ], rgba[3, ], maxColorValue = 255)
  if (anyDuplicated(normalized)) stop("Annotation colors must be distinct; repeated or equivalent colors are ambiguous.")
  colors <- stats::setNames(normalized, categories)
  signed <- expression_scale == "signed_score"
  if (is.null(feature_palette)) feature_palette <- if (signed) row$diverging else row$sequential
  permitted <- if (signed) c("vik", "broc", "roma", "bam") else c("lapaz", "lajolla", "batlow", "grayC", "davos", "oslo")
  if (!is.character(feature_palette) || length(feature_palette) != 1L || is.na(feature_palette) || !feature_palette %in% permitted) {
    stop("feature_palette must match the declared expression scale; supported: ", paste(permitted, collapse = ", "), ".")
  }
  list(style = style, colors = colors, feature_palette = feature_palette,
    feature_colors = data.frame(position = seq(0, 1, length.out = 256),
      color = scico::scico(256, palette = feature_palette, direction = if (signed) 1 else -1)),
    preview = data.frame(category = categories, color = unname(colors),
      deutan = unname(colorspace::deutan(colors)), protan = unname(colorspace::protan(colors)),
      tritan = unname(colorspace::tritan(colors))))
}
