check_columns <- function(data, required, data_name = "data") {
  if (!is.data.frame(data)) {
    stop(data_name, " must be a data frame.", call. = FALSE)
  }
  if (nrow(data) == 0L) {
    stop(data_name, " must contain at least one row.", call. = FALSE)
  }
  if (anyDuplicated(names(data))) {
    stop(data_name, " has duplicate column names.", call. = FALSE)
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
  invisible(data)
}

validate_panel_data <- function(data, required, numeric_cols = character(),
                                key_cols = character(), data_name = "data") {
  check_columns(data, unique(c(required, numeric_cols, key_cols)), data_name)
  for (column in unique(c(required, numeric_cols, key_cols))) {
    values <- data[[column]]
    if (anyNA(values) || any(!nzchar(trimws(as.character(values))))) {
      stop(data_name, "$", column, " contains missing or blank values.", call. = FALSE)
    }
  }
  for (column in numeric_cols) {
    if (!is.numeric(data[[column]]) || any(!is.finite(data[[column]]))) {
      stop(data_name, "$", column, " must contain finite numeric values.", call. = FALSE)
    }
  }
  if (length(key_cols) && anyDuplicated(data[key_cols])) {
    stop(data_name, " has duplicate rows for key: ",
         paste(key_cols, collapse = ", "), ".", call. = FALSE)
  }
  invisible(data)
}

ordered_values <- function(values, order = NULL, name = "order") {
  present <- unique(as.character(values))
  if (is.null(order)) {
    order <- if (is.factor(values)) levels(droplevels(values)) else present
  }
  if (!is.character(order) || anyNA(order) || anyDuplicated(order) ||
      any(!nzchar(order)) || length(setdiff(present, order))) {
    stop(name, " must contain every observed category once (extra levels are allowed).",
         call. = FALSE)
  }
  factor(as.character(values), levels = order)
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
    if (!length(palette) || anyNA(names(palette)) || any(!nzchar(names(palette))) ||
        anyDuplicated(names(palette)) || anyNA(palette)) {
      stop("palette must have unique, non-empty names and non-missing colors.", call. = FALSE)
    }
    tryCatch(grDevices::col2rgb(palette), error = function(e) {
      stop("palette contains an invalid color.", call. = FALSE)
    })
    return(palette)
  }
  if (is.data.frame(palette)) {
    return(read_nc_palette(palette))
  }
  stop("palette must be NULL, a named character vector, or a data frame.", call. = FALSE)
}

default_discrete_palette <- function(values) {
  values <- levels(ordered_values(values))
  colors <- c("#0072B2", "#E69F00", "#009E73", "#CC79A7", "#56B4E9", "#D55E00", "#000000", "#F0E442")
  if (length(values) > length(colors)) colors <- grDevices::hcl.colors(length(values), "Dark 3")
  stats::setNames(colors[seq_along(values)], values)
}

write_if_not_null <- function(x, path) {
  if (!is.null(x)) {
    readr::write_tsv(as.data.frame(x), path)
  }
}
