check_sc_columns <- function(data, required, data_name = "data") {
  ncfigR::validate_panel_data(data, required, data_name = data_name)
}

sc_order <- function(values, order = NULL, name = "order") {
  present <- unique(as.character(values))
  if (is.null(order)) order <- if (is.factor(values)) levels(droplevels(values)) else present
  if (!is.character(order) || anyNA(order) || anyDuplicated(order) ||
      any(!nzchar(order)) || length(setdiff(present, order))) {
    stop(name, " must contain every observed category once (extra levels are allowed).", call. = FALSE)
  }
  factor(as.character(values), levels = order)
}

default_sc_palette <- function(values) {
  values <- sort(unique(as.character(values)))
  stats::setNames(scales::hue_pal()(length(values)), values)
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

sc_group_markers <- function(data, feature_col, feature_order, marker_groups) {
  if (is.null(marker_groups)) return(list(data = data, features = feature_order))
  valid <- is.list(marker_groups) && length(marker_groups) &&
    !is.null(names(marker_groups)) && !anyNA(names(marker_groups)) &&
    !anyDuplicated(names(marker_groups)) && all(nzchar(trimws(names(marker_groups)))) &&
    all(vapply(marker_groups, function(x) is.character(x) && length(x) > 0L &&
      !anyNA(x) && all(nzchar(trimws(x))), logical(1)))
  if (!valid) stop("marker_groups must be a named list of non-empty gene vectors.", call. = FALSE)
  features <- unlist(marker_groups, use.names = FALSE)
  if (anyDuplicated(features) || !setequal(features, as.character(data[[feature_col]]))) {
    stop("marker_groups must assign every observed gene exactly once, without unknown genes.", call. = FALSE)
  }
  if (!is.null(feature_order) && !identical(feature_order, features)) {
    stop("feature_order must match the flattened marker_groups order when both are supplied.", call. = FALSE)
  }
  group_names <- rep(names(marker_groups), lengths(marker_groups))
  data$marker_group <- factor(group_names[match(as.character(data[[feature_col]]), features)],
    levels = names(marker_groups))
  list(data = data, features = features)
}

sc_check_data_out <- function(data.out) {
  if (!is.logical(data.out) || length(data.out) != 1L || is.na(data.out)) {
    stop("data.out must be TRUE or FALSE.", call. = FALSE)
  }
}
