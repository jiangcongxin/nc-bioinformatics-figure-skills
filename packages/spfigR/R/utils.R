check_sp_columns <- function(data, required, data_name = "data") {
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

as_named_palette <- function(palette) {
  if (is.null(palette)) {
    return(NULL)
  }
  if (is.character(palette) && !is.null(names(palette))) {
    return(palette)
  }
  if (is.data.frame(palette)) {
    return(ncfigR::read_nc_palette(palette))
  }
  stop("palette must be NULL, a named character vector, or a data frame.", call. = FALSE)
}

default_sp_palette <- function(values) {
  values <- sort(unique(as.character(values)))
  stats::setNames(scales::hue_pal()(length(values)), values)
}
