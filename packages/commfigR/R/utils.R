check_comm_columns <- function(data, required, data_name = "data") {
  if (!is.data.frame(data) || !nrow(data) || anyDuplicated(names(data))) {
    stop(data_name, " must be a non-empty data frame with unique column names.", call. = FALSE)
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

top_by_abs <- function(data, value_col, n) {
  if (is.null(n)) {
    return(data)
  }
  if (!is.numeric(n) || length(n) != 1L || !is.finite(n) || n < 1 || n != floor(n)) {
    stop("top_n must be NULL or a positive integer.", call. = FALSE)
  }
  ord <- order(abs(data[[value_col]]), decreasing = TRUE, na.last = NA)
  data[utils::head(ord, n), , drop = FALSE]
}

comm_numeric <- function(data, name, range = c(-Inf, Inf)) {
  if (!is.numeric(data[[name]]) || any(!is.finite(data[[name]])) ||
      any(data[[name]] < range[1] | data[[name]] > range[2])) {
    stop(name, " must contain finite numeric values in [", paste(range, collapse = ", "), "].", call. = FALSE)
  }
}

comm_unique <- function(data, keys) {
  if (anyDuplicated(data[keys])) stop("Duplicate communication keys: ", paste(keys, collapse = ", "),
    ". Export one row per interaction and condition; no automatic averaging.", call. = FALSE)
}

comm_condition <- function(data, column = NULL) {
  if (is.null(column) && "condition" %in% names(data)) column <- "condition"
  if (!is.null(column)) check_comm_columns(data, column)
  data$condition <- if (is.null(column)) "Dataset" else as.character(data[[column]])
  data
}
