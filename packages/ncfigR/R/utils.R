check_columns <- function(data, required, data_name = "data") {
  missing <- setdiff(required, names(data))
  if (length(missing) > 0) {
    stop(
      data_name,
      " is missing required columns: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }
  invisible(data)
}

require_pkg <- function(pkg, why = "this function") {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(pkg, " is required for ", why, ". Please install it first.", call. = FALSE)
  }
  invisible(TRUE)
}

named_palette <- function(palette) {
  if (is.null(palette)) {
    return(NULL)
  }
  if (is.character(palette) && !is.null(names(palette))) {
    return(palette)
  }
  if (is.data.frame(palette)) {
    return(read_nc_palette(palette))
  }
  stop("palette must be NULL, a named character vector, or a data frame.", call. = FALSE)
}

default_discrete_palette <- function(values) {
  values <- sort(unique(as.character(values)))
  stats::setNames(scales::hue_pal()(length(values)), values)
}

write_if_not_null <- function(x, path) {
  if (!is.null(x)) {
    readr::write_tsv(as.data.frame(x), path)
  }
}
