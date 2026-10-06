check_sp_columns <- function(data, required, data_name = "data") {
  if (!is.data.frame(data) || !nrow(data) || anyDuplicated(names(data))) {
    stop(data_name, " must be a non-empty data frame with unique columns.", call. = FALSE)
  }
  missing <- setdiff(required, names(data))
  if (length(missing) > 0) {
    stop(
      data_name,
      " is missing required columns: ",
      paste(missing, collapse = ", "),
      call. = FALSE
    )
  }
  for (name in required) {
    value <- data[[name]]
    if (anyNA(value) || (is.numeric(value) && any(!is.finite(value))) ||
        (!is.numeric(value) && any(!nzchar(trimws(as.character(value)))))) {
      stop(data_name, ": missing, blank or non-finite values in ", name, call. = FALSE)
    }
  }
  invisible(data)
}

sp_numeric <- function(data, names, nonnegative = FALSE) {
  for (name in names) {
    if (!is.numeric(data[[name]]) || any(!is.finite(data[[name]])) ||
        (nonnegative && any(data[[name]] < 0))) {
      stop(name, " must contain finite numeric values", if (nonnegative) " >= 0" else "", ".", call. = FALSE)
    }
  }
}

sp_unique <- function(data, keys) {
  if (anyDuplicated(data[keys])) stop("Duplicate keys: ", paste(keys, collapse = ", "), ".", call. = FALSE)
}

sp_geometry <- function(data, x_col, y_col, point_size, alpha) {
  sp_numeric(data, c(x_col, y_col))
  if (!is.numeric(point_size) || length(point_size) != 1L || !is.finite(point_size) || point_size <= 0 ||
      !is.numeric(alpha) || length(alpha) != 1L || !is.finite(alpha) || alpha <= 0 || alpha > 1) {
    stop("point_size must be positive; alpha must be in (0,1].", call. = FALSE)
  }
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
