#' Prepare section-aware spatial source data
#' @param coordinates Table with section_id, spot_id, x, y and domain.
#' @param features Complete long table with section_id, spot_id, feature, value,
#'   including explicit zero values.
#' @param regions Optional section_id, region_id, xmin, xmax, ymin, ymax table.
#' @param expression_scale counts, log_normalized or signed_score; must be declared.
#' @param feature_order Optional complete order of the 1-3 supplied features.
#' @param domain_order Optional complete order of observed domains.
#' @return Coordinates, matched feature rows, per-section composition, regions,
#'   zoom rows and metadata. No statistical tests or image registration.
#' @export
prepare_spatial_data <- function(coordinates, features, regions = NULL,
                                 expression_scale, feature_order = NULL, domain_order = NULL) {
  if (missing(expression_scale) || !is.character(expression_scale) || length(expression_scale) != 1L ||
      is.na(expression_scale) || !expression_scale %in% c("counts", "log_normalized", "signed_score")) {
    stop("Declare expression_scale as counts, log_normalized or signed_score.", call. = FALSE)
  }
  coordinates <- as.data.frame(coordinates)
  features <- as.data.frame(features)
  check_sp_columns(coordinates, c("section_id", "spot_id", "x", "y", "domain"), "coordinates")
  check_sp_columns(features, c("section_id", "spot_id", "feature", "value"), "features")
  sp_numeric(coordinates, c("x", "y"))
  sp_numeric(features, "value", nonnegative = expression_scale != "signed_score")
  sp_unique(coordinates, c("section_id", "spot_id"))
  sp_unique(features, c("section_id", "spot_id", "feature"))
  # Table keys, not concatenated strings, avoid collisions in section/spot labels.
  for (data_name in c("coordinates", "features")) {
    data <- get(data_name)
    for (name in intersect(names(data), c("section_id", "spot_id", "domain", "feature"))) data[[name]] <- as.character(data[[name]])
    assign(data_name, data)
  }
  sections <- sort(unique(coordinates$section_id))
  genes <- sort(unique(features$feature))
  domains <- sort(unique(coordinates$domain))
  if (nrow(coordinates) > 200000 || length(sections) > 4 || length(genes) > 3 ||
      nrow(features) > 600000 || length(domains) > 30) {
    stop("Limits: 200,000 spots, 4 sections, 1-3 features, 600,000 feature rows and 30 domains.", call. = FALSE)
  }
  order_values <- function(order, values, name) {
    if (is.null(order)) return(values)
    if (!is.character(order) || anyNA(order) || anyDuplicated(order) || !setequal(order, values)) {
      stop(name, " must contain every observed label exactly once.", call. = FALSE)
    }
    order
  }
  genes <- order_values(feature_order, genes, "feature_order")
  domains <- order_values(domain_order, domains, "domain_order")
  for (section in sections) {
    subset <- coordinates[coordinates$section_id == section, ]
    if (diff(range(subset$x)) == 0 || diff(range(subset$y)) == 0) stop("Degenerate two-dimensional coordinates for section ", section, ".", call. = FALSE)
    sp_unique(subset, c("x", "y"))
  }
  if (any(c("x", "y", "domain") %in% names(features))) {
    stop("Feature table must reference coordinates by section/spot keys, not supply conflicting x/y/domain columns.", call. = FALSE)
  }
  expected <- merge(coordinates[c("section_id", "spot_id")], data.frame(feature = genes), by = NULL)
  matched <- merge(expected, features, by = c("section_id", "spot_id", "feature"))
  if (nrow(matched) != nrow(expected) || nrow(features) != nrow(expected)) {
    stop("Features must cover every section/spot/feature exactly once, including zeros; missing and extra keys are not filled or dropped.", call. = FALSE)
  }
  mapped <- merge(features, coordinates[c("section_id", "spot_id", "x", "y", "domain")], by = c("section_id", "spot_id"), sort = FALSE)
  mapped$feature <- factor(mapped$feature, levels = genes)
  composition <- as.data.frame(table(section_id = factor(coordinates$section_id, levels = sections),
    domain = factor(coordinates$domain, levels = domains)), stringsAsFactors = FALSE)
  names(composition)[3] <- "spots"
  composition$total_spots <- as.numeric(table(coordinates$section_id)[as.character(composition$section_id)])
  composition$proportion <- composition$spots / composition$total_spots
  zoom <- NULL
  if (!is.null(regions)) {
    regions <- as.data.frame(regions)
    check_sp_columns(regions, c("section_id", "region_id", "xmin", "xmax", "ymin", "ymax"), "regions")
    sp_numeric(regions, c("xmin", "xmax", "ymin", "ymax"))
    sp_unique(regions, c("section_id", "region_id"))
    if (nrow(regions) > 4 || any(!regions$section_id %in% sections) ||
        any(regions$xmin >= regions$xmax | regions$ymin >= regions$ymax)) {
      stop("Regions need observed section IDs, increasing bounds and at most four boxes.", call. = FALSE)
    }
    zoom <- do.call(rbind, lapply(seq_len(nrow(regions)), function(i) {
      r <- regions[i, ]
      subset <- coordinates[coordinates$section_id == r$section_id &
        coordinates$x >= r$xmin & coordinates$x <= r$xmax &
        coordinates$y >= r$ymin & coordinates$y <= r$ymax, , drop = FALSE]
      if (!nrow(subset)) stop("Empty zoom region: ", r$section_id, "/", r$region_id, ".", call. = FALSE)
      subset$region_id <- as.character(r$region_id)
      subset
    }))
  }
  limits <- range(features$value)
  if (expression_scale == "signed_score") limits <- c(-1, 1) * max(abs(limits)) else limits[1] <- 0
  if (diff(limits) == 0) limits <- if (expression_scale == "signed_score") c(-1, 1) else c(0, 1)
  list(coordinates = coordinates, features = features, mapped_features = mapped,
    composition = composition, regions = regions, zoom = zoom,
    sections = sections, feature_order = genes, domain_order = domains, feature_limits = limits)
}
