check_bench_columns <- function(data, required, data_name = "data") {
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
  if (is.null(names(palette)) || any(names(palette) == "")) {
    stop("palette must be a named character vector.", call. = FALSE)
  }
  palette
}

default_bench_palette <- function(values) {
  levels <- sort(unique(as.character(values)))
  stats::setNames(grDevices::hcl.colors(length(levels), "Dark 3"), levels)
}
