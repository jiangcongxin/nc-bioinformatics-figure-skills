job_abort <- function(code, message, action, retry = "confirm_or_fix_input") {
  stop(structure(list(message = message, call = NULL, code = code,
    action = action, retry = retry), class = c("sc_job_error", "error", "condition")))
}

job_json <- function(value, path) {
  temporary <- tempfile(".json-", tmpdir = dirname(path))
  on.exit(unlink(temporary), add = TRUE)
  jsonlite::write_json(value, temporary, auto_unbox = TRUE, pretty = TRUE,
    null = "null", na = "null", digits = NA)
  if (!file.copy(temporary, path, overwrite = TRUE)) stop("Cannot write JSON: ", path)
}

job_object <- function(value, allowed, required = character(), name) {
  if (!is.list(value) || is.null(names(value)) || anyDuplicated(names(value))) {
    job_abort("invalid_spec", paste(name, "must be a JSON object with unique keys."), "Correct the task configuration.")
  }
  unknown <- setdiff(names(value), allowed)
  missing <- setdiff(required, names(value))
  if (length(unknown) || length(missing)) job_abort("invalid_spec",
    paste0(name, ": unknown keys [", paste(unknown, collapse = ", "),
      "]; missing keys [", paste(missing, collapse = ", "), "]."), "Correct the task configuration; do not guess scientific parameters.")
}

job_string <- function(value, name) {
  if (!is.character(value) || length(value) != 1L || is.na(value) || !nzchar(trimws(value))) {
    job_abort("invalid_spec", paste(name, "must be a non-empty string."), "Correct the task configuration.")
  }
  value
}

job_path <- function(path, base) {
  path <- job_string(path, "path")
  if (grepl("^(/|[A-Za-z]:[/\\\\]|\\\\\\\\)", path)) path else file.path(base, path)
}

job_array <- function(value, name) {
  if (!is.list(value) || !is.null(names(value)) || !length(value) ||
      !all(vapply(value, function(x) is.character(x) && length(x) == 1L &&
        !is.na(x) && nzchar(trimws(x)), logical(1)))) {
    job_abort("invalid_spec", paste(name, "must be a non-empty array of strings."), "Correct the category or feature list.")
  }
  result <- unlist(value, use.names = FALSE)
  if (anyDuplicated(result)) job_abort("invalid_spec", paste(name, "contains duplicates."), "Remove repeated configuration entries, not data rows.")
  result
}

job_validate_spec <- function(spec) {
  job_object(spec, c("schema_version", "job_id", "task", "inputs", "analysis", "figure", "output_dir"),
    c("schema_version", "job_id", "task", "inputs"), "job")
  if (!identical(spec$schema_version, "1.0") || !identical(spec$task, "single_cell_atlas")) {
    job_abort("unsupported_task", "Use schema_version 1.0 and task single_cell_atlas.", "Select a supported task; other analysis engines are not implemented.")
  }
  id <- job_string(spec$job_id, "job_id")
  if (!grepl("^[A-Za-z0-9][A-Za-z0-9_-]{0,63}$", id)) {
    job_abort("invalid_spec", "job_id must be 1-64 letters, digits, underscores or hyphens.", "Use a file-safe job ID.")
  }
  job_object(spec$inputs, c("embedding", "expression", "expression_scale", "provenance"),
    c("embedding", "expression", "expression_scale", "provenance"), "inputs")
  for (field in names(spec$inputs)) job_string(spec$inputs[[field]], paste0("inputs.", field))
  if (!spec$inputs$expression_scale %in% c("counts", "log_normalized")) {
    job_abort("expression_scale_unconfirmed", "Expression scale must be counts or log_normalized; scaled/unknown values are unsupported.",
      "Ask the user or inspect upstream analysis records to confirm the expression scale.", "requires_confirmation")
  }
  analysis <- spec$analysis
  if (is.null(analysis)) analysis <- list(detection_threshold = 0)
  job_object(analysis, "detection_threshold", name = "analysis")
  threshold <- analysis$detection_threshold
  if (is.null(threshold)) threshold <- 0
  if (!is.numeric(threshold) || length(threshold) != 1L || !is.finite(threshold) || threshold < 0) {
    job_abort("invalid_spec", "detection_threshold must be one non-negative finite number.", "Confirm the detection definition before changing the threshold.", "requires_confirmation")
  }
  figure <- spec$figure
  if (is.null(figure)) figure <- list(layout = "publication")
  job_object(figure, c("layout", "width_mm", "height_mm", "cell_type_order", "feature_order", "feature_genes",
    "marker_scale", "marker_groups", "palette", "title"), name = "figure")
  defaults <- list(layout = "publication", width_mm = 183, height_mm = 126, marker_scale = "gene_zscore")
  for (field in names(defaults)) if (is.null(figure[[field]])) figure[[field]] <- defaults[[field]]
  if (!figure$layout %in% c("publication", "standard") || length(figure$layout) != 1L ||
      !figure$marker_scale %in% c("gene_zscore", "raw") || length(figure$marker_scale) != 1L) {
    job_abort("invalid_spec", "Unsupported figure layout or marker_scale.", "Use publication/standard layout and gene_zscore/raw marker colors.")
  }
  for (field in c("width_mm", "height_mm")) {
    value <- figure[[field]]
    if (!is.numeric(value) || length(value) != 1L || !is.finite(value) || value < 80 || value > 300) {
      job_abort("invalid_spec", paste(field, "must be between 80 and 300 mm."), "Choose a supported figure size.", "presentation_only")
    }
  }
  for (field in c("cell_type_order", "feature_order", "feature_genes")) {
    if (!is.null(figure[[field]])) figure[[field]] <- job_array(figure[[field]], paste0("figure.", field))
  }
  if (!is.null(figure$marker_groups)) {
    job_object(figure$marker_groups, names(figure$marker_groups), name = "figure.marker_groups")
    if (!length(figure$marker_groups) || any(!nzchar(trimws(names(figure$marker_groups))))) {
      job_abort("invalid_spec", "marker_groups must have non-empty group names.", "Provide named gene groups.")
    }
    figure$marker_groups <- lapply(figure$marker_groups, job_array, name = "figure.marker_groups")
  }
  if (!is.null(figure$title)) job_string(figure$title, "figure.title")
  if (!is.null(figure$palette)) job_string(figure$palette, "figure.palette")
  if (!is.null(figure$feature_genes) && (figure$layout != "publication" ||
      length(figure$feature_genes) != 3L || spec$inputs$expression_scale != "log_normalized")) {
    job_abort("invalid_feature_maps", "Three feature genes require publication layout and confirmed log_normalized expression.",
      "Confirm the input expression scale and select exactly three genes.", "requires_confirmation")
  }
  spec$analysis <- list(detection_threshold = threshold)
  if (!is.null(spec$output_dir)) job_string(spec$output_dir, "output_dir")
  job_string(figure$layout, "figure.layout")
  job_string(figure$marker_scale, "figure.marker_scale")
  spec$figure <- figure
  spec
}

job_read_table <- function(path, expression = FALSE) {
  if (!file.exists(path) || dir.exists(path)) job_abort("input_missing", paste("Input file not found:", path), "Correct the input path.")
  if (file.info(path)$size > 100 * 1024^2) job_abort("input_too_large", "v1 supports source tables up to 100 MiB per file.",
    "Export a selected marker set or use a separately planned large-data workflow; do not subsample silently.")
  extension <- tolower(tools::file_ext(path))
  if (!extension %in% c("csv", "tsv")) job_abort("unsupported_input", "Inputs must be CSV or TSV files.", "Export the documented source tables first.")
  types <- if (expression) readr::cols(cell_id = readr::col_character(), feature = readr::col_character(),
    value = readr::col_double()) else readr::cols(cell_id = readr::col_character(),
      cell_type = readr::col_character(), sample = readr::col_character(), x = readr::col_double(), y = readr::col_double())
  data <- suppressWarnings(readr::read_delim(path, delim = if (extension == "csv") "," else "\t",
    col_types = types, name_repair = "minimal", progress = FALSE, show_col_types = FALSE))
  if (nrow(readr::problems(data))) job_abort("parse_error", paste("Parsing failed for:", path), "Fix invalid fields or export a correctly delimited table; no rows have been discarded.")
  as.data.frame(data)
}

job_write_report <- function(report, run_dir) {
  job_json(report, file.path(run_dir, "report.json"))
  lines <- c(paste0("# Single-cell task: ", report$job_id), "",
    paste("Status:", report$status), paste("Stage:", report$stage),
    paste("Scope:", report$scope), "", "## Checks")
  for (check in report$checks) lines <- c(lines, paste0("- ", check$id, ": ", check$status, " - ", check$detail))
  for (error in report$errors) lines <- c(lines, "", paste("Error:", error$code), error$message, paste("Next action:", error$action))
  lines <- c(lines, "", "## Next action", report$next_action,
    "", "Technical checks and self-reported visual review do not certify journal acceptance or biological validity.")
  writeLines(lines, file.path(run_dir, "report.md"))
}

run_sc_job <- function(spec_path, output_dir = NULL) {
  spec_path <- normalizePath(spec_path, winslash = "/", mustWork = FALSE)
  base <- dirname(spec_path)
  spec <- NULL
  parse_error <- NULL
  tryCatch({ spec <- suppressWarnings(jsonlite::read_json(spec_path, simplifyVector = FALSE)) },
    error = function(e) { parse_error <<- conditionMessage(e) })
  root <- output_dir
  if (is.null(root) && is.list(spec) && is.character(spec$output_dir) && length(spec$output_dir) == 1L && !is.na(spec$output_dir)) root <- spec$output_dir
  if (is.null(root)) root <- "runs"
  root <- job_path(root, base)
  id <- if (is.list(spec) && is.character(spec$job_id) && length(spec$job_id) == 1L &&
    !is.na(spec$job_id) && grepl("^[A-Za-z0-9][A-Za-z0-9_-]{0,63}$", spec$job_id)) spec$job_id else "invalid-job"
  parent <- file.path(root, id)
  dir.create(parent, recursive = TRUE, showWarnings = FALSE)
  run_dir <- tempfile(paste0(format(Sys.time(), "%Y%m%dT%H%M%SZ", tz = "UTC"), "-"), tmpdir = parent)
  if (!dir.create(run_dir)) stop("Cannot create run directory: ", run_dir)
  run_dir <- normalizePath(run_dir, winslash = "/")
  report <- list(schema_version = "1.0", job_id = id, run_id = basename(run_dir),
    status = "failed", stage = "configuration", scope = "Descriptive atlas summaries and figures; no differential expression or annotation inference",
    started_at = format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
    checks = list(), errors = list(), warnings = list(), artifacts = list(),
    artifact_checksums = list(), review = NULL, next_action = "Read errors and fix or confirm inputs.")
  report$software <- list(R = R.version.string, ncfigR = as.character(utils::packageVersion("ncfigR")),
    scfigR = as.character(utils::packageVersion("scfigR")))
  if (file.exists(spec_path) && !dir.exists(spec_path)) file.copy(spec_path, file.path(run_dir, "submitted_job.json"))
  log <- character()
  add_check <- function(id, status, detail) {
    report$checks[[length(report$checks) + 1L]] <<- list(id = id, status = status, detail = detail)
  }
  tryCatch(withCallingHandlers({
    if (!is.null(parse_error)) job_abort("invalid_json", parse_error, "Provide a valid task JSON file.")
    spec <- job_validate_spec(spec)
    add_check("configuration", "pass", "Supported task and explicitly declared expression scale.")
    report$stage <- "input"
    input_paths <- c(embedding = job_path(spec$inputs$embedding, base), expression = job_path(spec$inputs$expression, base))
    if (!is.null(spec$figure$palette)) input_paths <- c(input_paths, palette = job_path(spec$figure$palette, base))
    if (any(!file.exists(input_paths)) || any(dir.exists(input_paths))) job_abort("input_missing", "One or more source files are missing.", "Correct the configured input paths.")
    input_hashes <- unname(tools::md5sum(input_paths))
    embedding <- job_read_table(input_paths[["embedding"]])
    expression <- job_read_table(input_paths[["expression"]], expression = TRUE)
    if (nrow(embedding) > 200000L || nrow(expression) > 2000000L ||
        length(unique(embedding$cell_type)) > 40L || length(unique(embedding$sample)) > 200L ||
        length(unique(expression$feature)) > 100L) job_abort("task_too_large",
      "v1 limits: 200,000 cells, 2,000,000 expression rows, 40 cell types, 200 samples and 100 selected genes.",
      "Plan a smaller source-table task or a large-data workflow with user approval; no rows were filtered automatically.")
    if (any(expression$value < 0, na.rm = TRUE)) job_abort("negative_expression", "Counts/log-normalized expression contains negative values.", "Confirm the expression scale or export unscaled expression; never clamp negative values automatically.", "requires_confirmation")
    data <- prepare_sc_atlas_data(embedding, expression, detection_threshold = spec$analysis$detection_threshold)
    add_check("input_contracts", "pass", "Finite values, unique keys, matching cell IDs, complete cell-feature pairs including zeros.")
    add_check("composition_denominators", "pass", "Fractions sum to one per sample; zero-count categories retained.")
    samples <- unique(embedding$sample)
    types <- levels(sc_order(embedding$cell_type, spec$figure$cell_type_order, "cell_type_order"))
    report$summary <- list(cells = nrow(embedding), cell_types = length(types), samples = length(samples), genes = length(unique(expression$feature)))
    add_check("statistical_scope", "pass", "Descriptive cell-level marker means only; cells are not treated as independent biological replicates for tests.")
    if (length(samples) == 1L) add_check("sample_replication", "note", "One sample: no donor-level comparison or population inference.")
    rare <- names(which(table(embedding$cell_type) < 20))
    if (length(rare)) add_check("small_categories", "note", paste("Fewer than 20 cells; review descriptive marker stability:", paste(rare, collapse = ", ")))
    palette <- if ("palette" %in% names(input_paths)) ncfigR::read_nc_palette(input_paths[["palette"]]) else stats::setNames(
      if (length(types) <= 12L) c("#5479A5", "#8BA9C7", "#477D72", "#A4B89B", "#B86F87", "#CCAA66",
        "#A87850", "#8E7CA8", "#6E9FA8", "#A0A0A0", "#A9594E", "#668B9E")[seq_along(types)] else grDevices::hcl.colors(length(types), "Dark 3"), types)
    ncfigR::validate_palette(types, palette)
    report$stage <- "figure"
    arguments <- list(embedding = data$embedding, composition = data$composition, markers = data$markers,
      palette = palette, cell_type_order = spec$figure$cell_type_order, feature_order = spec$figure$feature_order,
      marker_groups = spec$figure$marker_groups, data.out = TRUE, title = spec$figure$title)
    if (spec$figure$layout == "publication") {
      arguments$marker_scale <- spec$figure$marker_scale
      if (!is.null(spec$figure$feature_genes)) {
        arguments$expression <- expression
        arguments$feature_genes <- spec$figure$feature_genes
      }
      plotted <- do.call(compose_sc_publication_figure, arguments)
    } else plotted <- do.call(compose_sc_atlas_figure, arguments)
    figure <- plotted$plot
    patchwork::patchworkGrob(figure)
    add_check("plot_build", "pass", "All panels and guides built; semantic visual review still required.")
    source_dir <- file.path(run_dir, "source-data")
    dir.create(source_dir)
    for (name in names(data)) readr::write_tsv(data[[name]], file.path(source_dir, paste0(name, ".tsv")))
    readr::write_tsv(plotted$data$markers, file.path(source_dir, "marker-plot-data.tsv"))
    readr::write_tsv(expression, file.path(source_dir, "expression.tsv"))
    readr::write_tsv(data.frame(cell_type = names(palette), color = unname(palette)), file.path(source_dir, "palette.tsv"))
    manifest <- data.frame(input = names(input_paths), path = unname(input_paths), md5 = input_hashes,
      provenance = spec$inputs$provenance, expression_scale = spec$inputs$expression_scale,
      detection_threshold = spec$analysis$detection_threshold)
    paths <- ncfigR::export_figure_bundle(figure, "atlas", file.path(run_dir, "figures"),
      width = spec$figure$width_mm / 25.4, height = spec$figure$height_mm / 25.4, source_manifest = manifest)
    if (any(!file.exists(unlist(paths))) || any(file.info(unlist(paths))$size <= 0)) {
      job_abort("empty_export", "An expected output file is missing or empty.", "Inspect rendering errors before retrying.", "presentation_only")
    }
    add_check("figure_exports", "pass", "Non-empty PDF/SVG/PNG, provenance manifest and session record exported.")
    if (!identical(unname(tools::md5sum(input_paths)), input_hashes)) job_abort("input_changed", "Source files changed during execution.", "Freeze the inputs and rerun; this output cannot be accepted.")
    report$stage <- "visual_review"
    resolved <- spec
    resolved$inputs$embedding <- "source-data/embedding.tsv"
    resolved$inputs$expression <- "source-data/expression.tsv"
    resolved$output_dir <- "reproductions"
    resolved$figure$palette <- "source-data/palette.tsv"
    for (field in c("cell_type_order", "feature_order", "feature_genes")) {
      if (!is.null(resolved$figure[[field]])) resolved$figure[[field]] <- as.list(resolved$figure[[field]])
    }
    if (!is.null(resolved$figure$marker_groups)) resolved$figure$marker_groups <-
      lapply(resolved$figure$marker_groups, as.list)
    job_json(resolved, file.path(run_dir, "resolved_job.json"))
    methods <- c("# Methods record", "", paste("Source:", spec$inputs$provenance),
      paste("Cells:", nrow(embedding), "Samples:", length(samples)),
      paste("Expression scale:", spec$inputs$expression_scale),
      paste("Detection: supplied expression >", spec$analysis$detection_threshold),
      "Cell fractions use all supplied cells separately within each sample, retaining zero-count cell-type categories.",
      "Marker means and detection fractions pool cells within each cell type; no statistical tests are performed.",
      "Mean expression includes zero-expression cells; marker-plot-data.tsv records the exact dot-plot input and any presentation grouping.",
      if (spec$figure$layout == "publication" && spec$figure$marker_scale == "gene_zscore")
        "Marker colors: per-gene z-scores across cell-type means using sample SD; constant genes mapped to zero; display clipped to [-2,2]." else "Marker colors: supplied mean expression scale.",
      if (!is.null(spec$figure$feature_genes)) "Feature maps: same supplied UMAP coordinates and common log-expression color limits; no independent scaling or clipping." else "No feature-expression maps requested.",
      "Supplied annotations and embeddings are not independently validated by this workflow.")
    writeLines(methods, file.path(run_dir, "methods.md"))
    writeLines(c("args <- commandArgs(trailingOnly = FALSE)",
      "script <- sub('^--file=', '', args[grepl('^--file=', args)][1])",
      "script <- gsub('~+~', ' ', script, fixed = TRUE)",
      "result <- scfigR::run_sc_job(file.path(dirname(normalizePath(script)), 'resolved_job.json'))",
      "cat(jsonlite::toJSON(result, auto_unbox = TRUE, null = 'null'), '\\n')",
      "quit(status = result$exit_code)"), file.path(run_dir, "reproduce.R"))
    report$artifacts <- lapply(paths, function(path) substring(normalizePath(path, winslash = "/"), nchar(run_dir) + 2L))
    report$figure <- list(layout = spec$figure$layout, width_mm = spec$figure$width_mm,
      height_mm = spec$figure$height_mm, marker_scale = if (spec$figure$layout == "publication") spec$figure$marker_scale else "raw")
    report$status <- "needs_review"
    report$next_action <- "Inspect the exported PNG and vector artwork at final size; submit six evidence-backed visual checks through review_sc_job. Do not claim NC-level quality from technical checks alone."
  }, warning = function(w) {
    report$warnings[[length(report$warnings) + 1L]] <<- conditionMessage(w)
    invokeRestart("muffleWarning")
  }), error = function(e) {
    report$errors[[1]] <<- list(code = if (inherits(e, "sc_job_error")) e$code else paste0(report$stage, "_failed"),
      message = conditionMessage(e), action = if (inherits(e, "sc_job_error")) e$action else
        "Read the failed stage and source-table contracts. Preserve data and confirm scientific parameters before correction.",
      retry_policy = if (inherits(e, "sc_job_error")) e$retry else "inspect_before_retry")
  })
  report$finished_at <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  log <- c(log, paste(report$started_at, "started"), unlist(report$warnings),
    vapply(report$errors, function(error) paste(error$code, error$message), character(1)),
    paste(report$finished_at, report$status))
  writeLines(log, file.path(run_dir, "run.log"))
  files <- list.files(run_dir, recursive = TRUE, full.names = TRUE)
  report$artifact_checksums <- lapply(seq_along(files), function(i) list(
    path = substring(files[i], nchar(run_dir) + 2L), md5 = unname(tools::md5sum(files[i]))))
  job_write_report(report, run_dir)
  list(status = report$status, exit_code = if (report$status == "failed") 1L else 2L,
    run_dir = run_dir, report_path = file.path(run_dir, "report.json"), errors = report$errors,
    next_action = report$next_action)
}
