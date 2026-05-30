check_comm_columns <- function(data, required, data_name = "data") {
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

top_by_abs <- function(data, value_col, n) {
  if (is.null(n)) {
    return(data)
  }
  ord <- order(abs(data[[value_col]]), decreasing = TRUE, na.last = NA)
  data[utils::head(ord, n), , drop = FALSE]
}
