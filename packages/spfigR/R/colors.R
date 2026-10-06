#' Available coordinated spatial color styles
#' @return Table of categorical and continuous style choices.
#' @export
sp_color_styles <- function() ncfigR::nc_color_styles()

#' Resolve a coordinated spatial palette
#' @param domains Unique annotation labels in their intended display order.
#' @param style balanced, muted, vivid or okabe_ito.
#' @param expression_scale counts, log_normalized or signed_score.
#' @param palette Optional named colors or domain/color table.
#' @param feature_palette Optional scale-compatible continuous palette.
#' @return Domain colors, feature palette and color-vision preview.
#' @export
sp_color_scheme <- function(domains, style = "balanced", expression_scale = "log_normalized",
                            palette = NULL, feature_palette = NULL) {
  scheme <- ncfigR::nc_color_scheme(domains, style, expression_scale, palette, feature_palette)
  scheme$domain_colors <- scheme$colors
  scheme$colors <- NULL
  names(scheme$preview)[1] <- "domain"
  scheme
}
