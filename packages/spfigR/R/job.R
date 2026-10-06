sp_job_abort <- function(code, message) {
  stop(structure(list(message = message, call = NULL, code = code), class = c("sp_job_error", "error", "condition")))
}

sp_job_json <- function(value, path) {
  temporary <- tempfile(tmpdir = dirname(path))
  on.exit(unlink(temporary), add = TRUE)
  jsonlite::write_json(value, temporary, auto_unbox = TRUE, pretty = TRUE, null = "null", digits = NA)
  if (!file.copy(temporary, path, overwrite = TRUE)) stop("Cannot write JSON: ", path)
}

sp_job_string <- function(value, name) {
  if (!is.character(value) || length(value) != 1L || is.na(value) || !nzchar(trimws(value))) {
    sp_job_abort("invalid_spec", paste(name, "must be a non-empty string."))
  }
  value
}

sp_job_object <- function(value, allowed, required, name) {
  if (!is.list(value) || is.null(names(value)) || anyDuplicated(names(value)) ||
      length(setdiff(names(value), allowed)) || length(setdiff(required, names(value)))) {
    sp_job_abort("invalid_spec", paste(name, "has unknown, duplicate or missing keys."))
  }
}

sp_job_path <- function(path, base) {
  path <- sp_job_string(path, "path")
  if (grepl("^(/|[A-Za-z]:[/\\\\]|\\\\\\\\)", path)) path else file.path(base, path)
}

sp_job_spec <- function(spec) {
  sp_job_object(spec, c("schema_version", "task", "job_id", "inputs", "figure", "output_dir"),
    c("schema_version", "task", "job_id", "inputs"), "job")
  if (!identical(spec$schema_version, "1.0") || !identical(spec$task, "spatial_overview")) {
    sp_job_abort("unsupported_task", "Use schema_version 1.0 and task spatial_overview.")
  }
  if (!grepl("^[A-Za-z0-9][A-Za-z0-9_-]{0,63}$", sp_job_string(spec$job_id, "job_id"))) {
    sp_job_abort("invalid_spec", "Invalid job_id.")
  }
  sp_job_object(spec$inputs, c("coordinates", "features", "regions", "palette", "expression_scale", "coordinate_unit", "y_axis", "provenance"),
    c("coordinates", "features", "expression_scale", "coordinate_unit", "y_axis", "provenance"), "inputs")
  for (name in names(spec$inputs)) sp_job_string(spec$inputs[[name]], paste0("inputs.", name))
  if (!spec$inputs$expression_scale %in% c("counts", "log_normalized", "signed_score") ||
      !spec$inputs$coordinate_unit %in% c("pixel", "micrometer", "arbitrary") ||
      !spec$inputs$y_axis %in% c("up", "down")) {
    sp_job_abort("unconfirmed_scale", "Declare supported expression_scale, coordinate_unit and y_axis; no guessing or unit conversion.")
  }
  figure <- spec$figure
  if (is.null(figure)) figure <- list(point_size = 0.65)
  sp_job_object(figure, c("width_mm", "height_mm", "point_size", "feature_order", "domain_order", "title", "color_style", "feature_palette"), character(), "figure")
  defaults <- list(width_mm = 183, height_mm = 190, point_size = 0.65, color_style = "balanced")
  for (name in names(defaults)) if (is.null(figure[[name]])) figure[[name]] <- defaults[[name]]
  for (name in c("width_mm", "height_mm")) {
    value <- figure[[name]]
    if (!is.numeric(value) || length(value) != 1L || !is.finite(value) || value < 100 || value > 300) {
      sp_job_abort("invalid_spec", paste(name, "must lie between 100 and 300 mm."))
    }
  }
  if (!is.numeric(figure$point_size) || length(figure$point_size) != 1L || !is.finite(figure$point_size) ||
      figure$point_size < 0.1 || figure$point_size > 4) sp_job_abort("invalid_spec", "point_size must lie between 0.1 and 4 mm.")
  for (name in c("feature_order", "domain_order")) {
    value <- figure[[name]]
    if (!is.null(value)) {
      if (!is.list(value) || !is.null(names(value)) || !length(value) ||
          !all(vapply(value, function(x) is.character(x) && length(x) == 1L && !is.na(x) && nzchar(trimws(x)), logical(1)))) {
        sp_job_abort("invalid_spec", paste(name, "must be an array of strings."))
      }
      figure[[name]] <- unlist(value, use.names = FALSE)
      if (anyDuplicated(figure[[name]])) sp_job_abort("invalid_spec", paste(name, "contains duplicate labels."))
    }
  }
  if (!is.null(figure$title)) sp_job_string(figure$title, "figure.title")
  sp_job_string(figure$color_style, "figure.color_style")
  if (!is.null(figure$feature_palette)) sp_job_string(figure$feature_palette, "figure.feature_palette")
  if (!is.null(spec$output_dir)) sp_job_string(spec$output_dir, "output_dir")
  spec$figure <- figure
  spec
}

sp_job_read <- function(path, numeric = character()) {
  if (!file.exists(path) || dir.exists(path)) sp_job_abort("input_missing", paste("Missing file:", path))
  if (file.info(path)$size > 100 * 1024^2) sp_job_abort("input_too_large", "Each source table must be <= 100 MiB.")
  extension <- tolower(tools::file_ext(path))
  if (!extension %in% c("csv", "tsv")) sp_job_abort("unsupported_input", "Export CSV/TSV tables; serialized objects and raw matrices are not task inputs.")
  data <- readr::read_delim(path, delim = if (extension == "csv") "," else "\t",
    col_types = readr::cols(.default = readr::col_character()), name_repair = "minimal", progress = FALSE)
  if (anyDuplicated(names(data)) || nrow(readr::problems(data))) sp_job_abort("parse_error", "Duplicate columns or malformed delimited fields.")
  for (name in intersect(numeric, names(data))) {
    value <- suppressWarnings(readr::parse_double(data[[name]]))
    if (nrow(readr::problems(value))) sp_job_abort("parse_error", paste("Invalid numeric field:", name))
    data[[name]] <- value
  }
  as.data.frame(data)
}

#' Execute a spatial source-table task
#' @param spec_path Schema 1.0 spatial_overview JSON configuration.
#' @param output_dir Optional output root override.
#' @return Status, exit code (1 failed, 2 needs_review), report and run paths.
#' @export
run_sp_job <- function(spec_path, output_dir = NULL) {
  spec_path <- normalizePath(spec_path, winslash = "/", mustWork = FALSE)
  base <- dirname(spec_path)
  parse_error <- NULL
  spec <- tryCatch(jsonlite::read_json(spec_path, simplifyVector = FALSE),
    error = function(e) { parse_error <<- conditionMessage(e); NULL })
  id <- if (is.list(spec) && is.character(spec$job_id) && length(spec$job_id) == 1L && !is.na(spec$job_id) &&
    grepl("^[A-Za-z0-9][A-Za-z0-9_-]{0,63}$", spec$job_id)) spec$job_id else "invalid-job"
  root <- output_dir
  if (is.null(root) && is.list(spec) && is.character(spec$output_dir) && length(spec$output_dir) == 1L && !is.na(spec$output_dir)) root <- spec$output_dir
  if (is.null(root)) root <- "runs"
  parent <- file.path(sp_job_path(root, base), id)
  dir.create(parent, recursive = TRUE, showWarnings = FALSE)
  run_dir <- tempfile(paste0(format(Sys.time(), "%Y%m%dT%H%M%SZ", tz = "UTC"), "-"), tmpdir = parent)
  if (!dir.create(run_dir)) stop("Cannot create run directory.")
  run_dir <- normalizePath(run_dir, winslash = "/")
  report <- list(schema_version = "1.0", task = "spatial_overview", job_id = id, run_id = basename(run_dir),
    status = "failed", stage = "configuration", scope = "Descriptive maps and annotated spot fractions; no clustering, cell deconvolution, image registration or spatial statistics.",
    checks = list(), warnings = list(), errors = list(), artifacts = list(), artifact_checksums = list(), review = NULL,
    software = list(R = R.version.string, ncfigR = as.character(getNamespaceVersion("ncfigR")), spfigR = as.character(getNamespaceVersion("spfigR"))),
    started_at = format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"), next_action = "Read errors; fix or confirm inputs.")
  if (file.exists(spec_path) && !dir.exists(spec_path)) file.copy(spec_path, file.path(run_dir, "submitted_job.json"))
  check <- function(id, status, detail) report$checks[[length(report$checks) + 1L]] <<- list(id = id, status = status, detail = detail)
  tryCatch(withCallingHandlers({
    if (!is.null(parse_error)) sp_job_abort("invalid_json", parse_error)
    spec <- sp_job_spec(spec)
    check("configuration", "pass", "Explicit expression scale, coordinate units and y-axis direction.")
    report$stage <- "input"
    fields <- intersect(c("coordinates", "features", "regions", "palette"), names(spec$inputs))
    paths <- stats::setNames(vapply(fields, function(name) sp_job_path(spec$inputs[[name]], base), character(1)), fields)
    if (any(!file.exists(paths)) || any(dir.exists(paths))) sp_job_abort("input_missing", "One or more configured source files are missing.")
    hashes <- unname(tools::md5sum(paths))
    coordinates <- sp_job_read(paths[["coordinates"]], c("x", "y"))
    features <- sp_job_read(paths[["features"]], "value")
    regions <- if ("regions" %in% fields) sp_job_read(paths[["regions"]], c("xmin", "xmax", "ymin", "ymax")) else NULL
    palette <- if ("palette" %in% fields) ncfigR::read_nc_palette(sp_job_read(paths[["palette"]])) else NULL
    plotted <- compose_spatial_overview(coordinates, features, regions, spec$inputs$expression_scale,
      spec$inputs$coordinate_unit, spec$inputs$y_axis, palette, spec$figure$feature_order,
      spec$figure$domain_order, spec$figure$point_size, spec$figure$title, data.out = TRUE,
      color_style = spec$figure$color_style, feature_palette = spec$figure$feature_palette)
    check("color_base", "pass", paste("cowplot theme; coordinated", plotted$data$color_scheme$style,
      "annotation style and scico", plotted$data$color_scheme$feature_palette, "feature colors. Inspect frozen CVD previews; simulations are not an accessibility certificate."))
    check("source_contracts", "pass", "Unique section/spot keys and distinct finite coordinates; complete spot-feature rows including explicit zeros.")
    check("geometry", "pass", "Separate sections, equal x/y aspect; declared y direction; no axis swap, coordinate rescaling or rotation in the task runner.")
    check("feature_scale", "pass", "Common declared expression scale and shared feature limits across all sections and features; no clipping or independent normalization.")
    check("composition", "pass", "Spot counts and fractions within each section; absent domains retained with zero counts; fractions sum to one.")
    check("biological_scope", "note", "Spot fractions are not cell proportions or area coverage. Supplied annotations are not independently validated.")
    check("image_alignment", "note", "No histology image or registration is validated. Point sizes are display mm, not physical spot diameters.")
    check("regions", if (is.null(regions)) "note" else "pass", if (is.null(regions)) "No ROI requested." else "Each ROI refers to one observed section, increasing original-unit bounds and at least one supplied spot.")
    report$summary <- list(spots = nrow(coordinates), sections = length(plotted$data$sections),
      domains = length(plotted$data$domain_order), features = length(plotted$data$feature_order), regions = if (is.null(regions)) 0L else nrow(regions))
    if (report$summary$sections == 1L) check("replication", "note", "One section; no independent donor-level inference.")
    if (report$summary$sections > 2L || report$summary$domains > 12L) check("display_density", "note", "Many panels or labels; inspect at final size before delivery.")
    report$stage <- "figure"
    patchwork::patchworkGrob(plotted$plot)
    source_dir <- file.path(run_dir, "source-data"); dir.create(source_dir)
    attribution <- system.file("COLOR_ATTRIBUTION.md", package = "spfigR")
    if (!nzchar(attribution) || !file.copy(attribution, file.path(source_dir, "COLOR_ATTRIBUTION.md"))) stop("Cannot freeze color attribution.")
    for (name in c("coordinates", "features", "mapped_features", "composition", "regions", "zoom", "palette", "color_preview", "feature_colors")) {
      if (!is.null(plotted$data[[name]])) readr::write_tsv(plotted$data[[name]], file.path(source_dir, paste0(name, ".tsv")))
    }
    dir.create(file.path(source_dir, "original"))
    for (name in fields) if (!file.copy(paths[[name]], file.path(source_dir, "original", paste0(name, ".", tools::file_ext(paths[[name]]))))) stop("Cannot freeze original input.")
    manifest <- data.frame(input = fields, path = unname(paths), md5 = hashes, provenance = spec$inputs$provenance,
      expression_scale = spec$inputs$expression_scale, coordinate_unit = spec$inputs$coordinate_unit, y_axis = spec$inputs$y_axis)
    exported <- ncfigR::export_figure_bundle(plotted$plot, "spatial", file.path(run_dir, "figures"),
      width = spec$figure$width_mm / 25.4, height = spec$figure$height_mm / 25.4, source_manifest = manifest)
    if (any(!file.exists(unlist(exported))) || any(file.info(unlist(exported))$size <= 0)) stop("Empty export.")
    if (!identical(unname(tools::md5sum(paths)), hashes)) sp_job_abort("input_changed", "Inputs changed during execution; freeze and rerun.")
    check("figure_exports", "pass", "Non-empty PDF/SVG/PNG, panel source tables, source manifest and session information.")
    resolved <- spec
    for (name in fields) resolved$inputs[[name]] <- paste0("source-data/", name, ".tsv")
    resolved$inputs$palette <- "source-data/palette.tsv"
    resolved$figure$feature_palette <- plotted$data$color_scheme$feature_palette
    resolved$output_dir <- "reproductions"
    for (name in c("feature_order", "domain_order")) resolved$figure[[name]] <- as.list(plotted$data[[name]])
    sp_job_json(resolved, file.path(run_dir, "resolved_job.json"))
    writeLines(c("# Spatial methods record", paste("Source:", spec$inputs$provenance),
      paste("Spots:", nrow(coordinates), "Sections:", length(plotted$data$sections)),
      paste("Coordinates:", spec$inputs$coordinate_unit, "y increases", spec$inputs$y_axis),
      "Coordinates and annotations are preserved. Equal coordinate aspect within each map. Sections are not spatially registered or rescaled to each other.",
      paste("Feature scale:", spec$inputs$expression_scale, "Common color limits:", paste(plotted$data$feature_limits, collapse = ", ")),
      paste("Color style:", plotted$data$color_scheme$style, "scico feature palette:", plotted$data$color_scheme$feature_palette),
      "Scientific Colour Maps: Fabio Crameri, CC BY 4.0, https://doi.org/10.5281/zenodo.1243909; sampled through scico, sequential palettes reversed. See source-data/COLOR_ATTRIBUTION.md.",
      "Categorical colors and 256-point continuous colors are frozen in source-data; color_preview.tsv includes deutan/protan/tritan simulations for manual inspection, not guaranteed category distinguishability.",
      "Feature maps use a neutral gray underlay 0.12 mm wider than the colored points, retaining the footprint of zero and pale values. This outline is display geometry, not an extra expression signal.",
      "Feature maps use complete source rows including zero values; no normalization or feature-wise clipping is performed. Constant all-zero values use display limits [0,1]; constant signed zero uses [-1,1].",
      "Annotation composition counts supplied spots separately within each section; all observed domains are retained with explicit zero counts when absent. Not cell fractions, tissue area fractions or biological replicate tests.",
      "ROI membership uses inclusive original-coordinate bounds within the declared section. Overlapping ROIs intentionally repeat spots for display; full-section composition never counts ROI duplicates.",
      paste("Point size:", spec$figure$point_size, "display mm, not physical spot diameter."),
      "No spatial statistics, new annotation, cell deconvolution, image overlay or histology registration is performed or certified."), file.path(run_dir, "methods.md"))
    writeLines(c("args <- commandArgs(trailingOnly = FALSE)",
      "script <- gsub('~+~', ' ', sub('^--file=', '', args[grepl('^--file=', args)][1]), fixed = TRUE)",
      "result <- spfigR::run_sp_job(file.path(dirname(normalizePath(script)), 'resolved_job.json'))",
      "cat(jsonlite::toJSON(result, auto_unbox = TRUE), '\\n')", "quit(status = result$exit_code)"), file.path(run_dir, "reproduce.R"))
    report$artifacts <- lapply(exported, function(x) substring(normalizePath(x, winslash = "/"), nchar(run_dir) + 2L))
    report$figure <- list(width_mm = spec$figure$width_mm, height_mm = spec$figure$height_mm, point_size = spec$figure$point_size,
      coordinate_unit = spec$inputs$coordinate_unit, y_axis = spec$inputs$y_axis, feature_limits = as.list(plotted$data$feature_limits),
      color_style = plotted$data$color_scheme$style, feature_palette = plotted$data$color_scheme$feature_palette)
    report$software$plotting_base <- list(cowplot = as.character(getNamespaceVersion("cowplot")),
      colorspace = as.character(getNamespaceVersion("colorspace")), scico = as.character(getNamespaceVersion("scico")))
    report$status <- "needs_review"; report$stage <- "visual_review"
    report$next_action <- "Inspect PNG and vector artwork at declared size, including orientation, section labels, shared scales and ROI boxes; submit six evidence-backed checks via review_sp_job."
  }, warning = function(w) {
    report$warnings[[length(report$warnings) + 1L]] <<- conditionMessage(w); invokeRestart("muffleWarning")
  }), error = function(e) {
    report$errors[[1]] <<- list(code = if (inherits(e, "sp_job_error")) e$code else paste0(report$stage, "_failed"), message = conditionMessage(e),
      action = "Read failed stage and source contracts. Preserve scientific data; confirm units, orientation, regions or annotation changes before correction.")
  })
  report$finished_at <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  writeLines(c(report$started_at, unlist(report$warnings), vapply(report$errors, function(x) x$message, character(1)), report$status), file.path(run_dir, "run.log"))
  files <- list.files(run_dir, recursive = TRUE, full.names = TRUE)
  report$artifact_checksums <- lapply(files, function(x) list(path = substring(x, nchar(run_dir) + 2L), md5 = unname(tools::md5sum(x))))
  sp_job_json(report, file.path(run_dir, "report.json"))
  writeLines(c(paste("# Spatial task", id), paste("Status:", report$status), paste("Scope:", report$scope),
    vapply(report$checks, function(x) paste("-", x$id, x$status, x$detail), character(1)),
    vapply(report$errors, function(x) paste(x$code, x$message, x$action), character(1)), unlist(report$warnings), report$next_action), file.path(run_dir, "report.md"))
  list(status = report$status, exit_code = if (report$status == "failed") 1L else 2L, run_dir = run_dir,
    report_path = file.path(run_dir, "report.json"), errors = report$errors, next_action = report$next_action)
}

#' Review a spatial task
#' @param run_dir Completed spatial task directory.
#' @param review_path Evidence-backed six-check visual review JSON.
#' @return Decision and report location.
#' @export
review_sp_job <- function(run_dir, review_path) {
  ncfigR::review_figure_job(run_dir, review_path, task = "spatial_overview")
}
