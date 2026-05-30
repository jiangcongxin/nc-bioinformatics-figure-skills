read_nc_palette <- function(x, key_col = NULL, color_col = "color") {
  pal <- if (is.character(x) && length(x) == 1) {
    readr::read_tsv(x, show_col_types = FALSE)
  } else if (is.data.frame(x)) {
    x
  } else {
    stop("x must be a palette path or data frame.", call. = FALSE)
  }

  if (!color_col %in% names(pal)) {
    stop("palette must contain a color column.", call. = FALSE)
  }
  if (is.null(key_col)) {
    key_col <- setdiff(names(pal), color_col)[1]
  }
  if (is.na(key_col) || !key_col %in% names(pal)) {
    stop("palette must contain one key column and one color column.", call. = FALSE)
  }

  out <- as.character(pal[[color_col]])
  names(out) <- as.character(pal[[key_col]])
  out
}

validate_palette <- function(values, palette, allow_extra = TRUE) {
  palette <- named_palette(palette)
  values <- sort(unique(as.character(values)))
  missing <- setdiff(values, names(palette))
  if (length(missing) > 0) {
    stop("palette is missing values: ", paste(missing, collapse = ", "), call. = FALSE)
  }
  if (!allow_extra) {
    extra <- setdiff(names(palette), values)
    if (length(extra) > 0) {
      stop("palette contains extra values: ", paste(extra, collapse = ", "), call. = FALSE)
    }
  }
  invisible(TRUE)
}
