comm_abort <- function(code, message, action = "Correct the input or task configuration; scientific changes need confirmation.") {
  stop(structure(list(message = message, call = NULL, code = code, action = action),
    class = c("comm_job_error", "error", "condition")))
}

comm_json <- function(value, path) {
  temporary <- tempfile(tmpdir = dirname(path))
  on.exit(unlink(temporary), add = TRUE)
  jsonlite::write_json(value, temporary, auto_unbox = TRUE, pretty = TRUE, null = "null", digits = NA)
  if (!file.copy(temporary, path, overwrite = TRUE)) stop("Cannot write JSON: ", path)
}

comm_object <- function(value, allowed, required, name) {
  if (!is.list(value) || is.null(names(value)) || anyDuplicated(names(value)) ||
      length(setdiff(names(value), allowed)) || length(setdiff(required, names(value)))) {
    comm_abort("invalid_spec", paste(name, "has unknown, duplicate or missing keys."))
  }
}

comm_string <- function(value, name) {
  if (!is.character(value) || length(value) != 1L || is.na(value) || !nzchar(trimws(value))) {
    comm_abort("invalid_spec", paste(name, "must be a non-empty string."))
  }
  value
}

comm_path <- function(path, base) {
  path <- comm_string(path, "path")
  if (grepl("^(/|[A-Za-z]:[/\\\\]|\\\\\\\\)", path)) path else file.path(base, path)
}

comm_spec <- function(spec) {
  comm_object(spec, c("schema_version", "task", "job_id", "inputs", "analysis", "figure", "output_dir"),
    c("schema_version", "task", "job_id", "inputs"), "job")
  if (!identical(spec$schema_version, "1.0") || !identical(spec$task, "communication_overview")) {
    comm_abort("unsupported_task", "Use schema_version 1.0 and task communication_overview.")
  }
  id <- comm_string(spec$job_id, "job_id")
  if (!grepl("^[A-Za-z0-9][A-Za-z0-9_-]{0,63}$", id)) comm_abort("invalid_spec", "Invalid job_id.")
  comm_object(spec$inputs, c("table", "format", "condition", "provenance", "score_definition", "p_value_definition"),
    c("table", "format", "provenance", "score_definition", "p_value_definition"), "inputs")
  for (name in names(spec$inputs)) comm_string(spec$inputs[[name]], paste0("inputs.", name))
  if (!spec$inputs$format %in% c("canonical", "cellchat")) comm_abort("invalid_spec", "format must be canonical or cellchat.")
  if (spec$inputs$format == "cellchat" && is.null(spec$inputs$condition)) {
    comm_abort("condition_unconfirmed", "A CellChat export requires an explicit condition label.")
  }
  analysis <- spec$analysis
  if (is.null(analysis)) analysis <- list(p_max = NULL)
  comm_object(analysis, "p_max", character(), "analysis")
  if (!is.null(analysis$p_max) && (!is.numeric(analysis$p_max) || length(analysis$p_max) != 1L ||
      !is.finite(analysis$p_max) || analysis$p_max < 0 || analysis$p_max > 1)) {
    comm_abort("invalid_spec", "p_max must be null or a number in [0,1].")
  }
  figure <- spec$figure
  if (is.null(figure)) figure <- list(top_n = 12)
  comm_object(figure, c("width_mm", "height_mm", "top_n", "max_pairs", "network_top_n", "cell_type_order", "title"), character(), "figure")
  defaults <- list(width_mm = 183, height_mm = 220, top_n = 12, max_pairs = 16, network_top_n = 20)
  for (name in names(defaults)) if (is.null(figure[[name]])) figure[[name]] <- defaults[[name]]
  for (name in c("width_mm", "height_mm")) {
    x <- figure[[name]]
    if (!is.numeric(x) || length(x) != 1L || !is.finite(x) || x < 100 || x > 300) {
      comm_abort("invalid_spec", paste(name, "must be between 100 and 300 mm."))
    }
  }
  if (!is.numeric(figure$top_n) || length(figure$top_n) != 1L || !is.finite(figure$top_n) ||
      figure$top_n < 1 || figure$top_n > 40 || figure$top_n != as.integer(figure$top_n)) {
    comm_abort("invalid_spec", "top_n must be an integer from 1 to 40.")
  }
  if (!is.numeric(figure$max_pairs) || length(figure$max_pairs) != 1L || !is.finite(figure$max_pairs) ||
      figure$max_pairs < 1 || figure$max_pairs > 40 || figure$max_pairs != as.integer(figure$max_pairs)) {
    comm_abort("invalid_spec", "max_pairs must be an integer from 1 to 40.")
  }
  if (!is.numeric(figure$network_top_n) || length(figure$network_top_n) != 1L || !is.finite(figure$network_top_n) ||
      figure$network_top_n < 1 || figure$network_top_n > 100 || figure$network_top_n != as.integer(figure$network_top_n)) {
    comm_abort("invalid_spec", "network_top_n must be an integer from 1 to 100.")
  }
  if (!is.null(figure$cell_type_order)) {
    x <- figure$cell_type_order
    if (!is.list(x) || !is.null(names(x)) || !length(x) ||
        !all(vapply(x, function(v) is.character(v) && length(v) == 1L && !is.na(v) && nzchar(trimws(v)), logical(1)))) {
      comm_abort("invalid_spec", "cell_type_order must be an array of unique labels.")
    }
    figure$cell_type_order <- unlist(x, use.names = FALSE)
    if (anyDuplicated(figure$cell_type_order)) comm_abort("invalid_spec", "Duplicate cell_type_order labels.")
  }
  if (!is.null(figure$title)) comm_string(figure$title, "figure.title")
  if (!is.null(spec$output_dir)) comm_string(spec$output_dir, "output_dir")
  spec$figure <- figure
  spec$analysis <- analysis
  spec
}

comm_read <- function(path) {
  if (!file.exists(path) || dir.exists(path)) comm_abort("input_missing", paste("Missing input:", path))
  if (file.info(path)$size > 100 * 1024^2) comm_abort("input_too_large", "Table exceeds the 100 MiB limit.")
  extension <- tolower(tools::file_ext(path))
  if (!extension %in% c("csv", "tsv")) comm_abort("unsupported_input", "Export a CSV or TSV table, not an RDS/raw matrix.")
  data <- readr::read_delim(path, delim = if (extension == "csv") "," else "\t",
    col_types = readr::cols(.default = readr::col_character()), name_repair = "minimal",
    progress = FALSE, show_col_types = FALSE)
  if (nrow(readr::problems(data))) comm_abort("parse_error", "Delimited table parsing failed; no rows discarded.")
  for (name in intersect(names(data), c("score", "p_value", "prob", "pval"))) {
    value <- suppressWarnings(readr::parse_double(data[[name]]))
    if (nrow(readr::problems(value))) comm_abort("parse_error", paste("Invalid numeric field:", name))
    data[[name]] <- value
  }
  as.data.frame(data)
}

#' Execute an existing-results communication task
#' @param spec_path JSON task configuration (schema 1.0).
#' @param output_dir Optional output root override.
#' @return Status, exit code (1 failed, 2 needs_review), paths and errors.
#' @export
run_comm_job <- function(spec_path, output_dir = NULL) {
  spec_path <- normalizePath(spec_path, winslash = "/", mustWork = FALSE)
  base <- dirname(spec_path)
  parse_error <- NULL
  spec <- tryCatch(jsonlite::read_json(spec_path, simplifyVector = FALSE),
    error = function(e) { parse_error <<- conditionMessage(e); NULL })
  id <- if (is.list(spec) && is.character(spec$job_id) && length(spec$job_id) == 1L &&
    !is.na(spec$job_id) && grepl("^[A-Za-z0-9][A-Za-z0-9_-]{0,63}$", spec$job_id)) spec$job_id else "invalid-job"
  root <- output_dir
  if (is.null(root) && is.list(spec) && is.character(spec$output_dir) && length(spec$output_dir) == 1L && !is.na(spec$output_dir)) root <- spec$output_dir
  if (is.null(root)) root <- "runs"
  parent <- file.path(comm_path(root, base), id)
  dir.create(parent, recursive = TRUE, showWarnings = FALSE)
  run_dir <- tempfile(paste0(format(Sys.time(), "%Y%m%dT%H%M%SZ", tz = "UTC"), "-"), tmpdir = parent)
  if (!dir.create(run_dir)) stop("Cannot create run directory.")
  run_dir <- normalizePath(run_dir, winslash = "/")
  report <- list(schema_version = "1.0", task = "communication_overview", job_id = id,
    run_id = basename(run_dir), status = "failed", stage = "configuration",
    scope = "Descriptive visualization of upstream inferred communication; no new inference or between-condition tests.",
    checks = list(), warnings = list(), errors = list(), artifacts = list(), artifact_checksums = list(),
    review = NULL, started_at = format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC"),
    software = list(R = R.version.string, ncfigR = as.character(getNamespaceVersion("ncfigR")),
      commfigR = as.character(getNamespaceVersion("commfigR"))), next_action = "Read errors; fix or confirm inputs.")
  if (file.exists(spec_path)) file.copy(spec_path, file.path(run_dir, "submitted_job.json"))
  check <- function(id, status, detail) report$checks[[length(report$checks) + 1L]] <<- list(id = id, status = status, detail = detail)
  tryCatch(withCallingHandlers({
    if (!is.null(parse_error)) comm_abort("invalid_json", parse_error)
    spec <- comm_spec(spec)
    check("configuration", "pass", "Supported task; explicit score and p-value definitions.")
    report$stage <- "input"
    path <- comm_path(spec$inputs$table, base)
    original_hash <- unname(tools::md5sum(path))
    data <- comm_read(path)
    if (spec$inputs$format == "cellchat") data <- as_cellchat_table(data, spec$inputs$condition)
    if (spec$inputs$format == "canonical" && !is.null(spec$inputs$condition)) {
      if ("condition" %in% names(data) && !all(data$condition == spec$inputs$condition)) {
        comm_abort("condition_mismatch", "Configured condition conflicts with table labels.")
      }
      data$condition <- spec$inputs$condition
    }
    plotted <- compose_communication_overview(data, p_max = spec$analysis$p_max, top_n = spec$figure$top_n,
      cell_type_order = spec$figure$cell_type_order, title = spec$figure$title,
      data.out = TRUE, max_pairs = spec$figure$max_pairs, network_top_n = spec$figure$network_top_n)
    check("input_contracts", "pass", "Unique condition/sender/receiver/ligand/receptor keys; finite non-negative scores; p-values in [0,1].")
    check("condition_separation", "pass", "No pooling or averaging of conditions in edges, strength summaries or panels.")
    check("filtering", "pass", if (is.null(spec$analysis$p_max)) "No additional p-value filtering." else paste("Upstream p_value <=", spec$analysis$p_max))
    check("statistical_scope", "note", "Upstream p-values are not donor-level tests; cross-condition score comparisons are descriptive and require compatible upstream settings.")
    check("missing_interactions", "note", "Unexported interactions remain absent, not assumed zero; panels summarize the supplied result universe only.")
    report$summary <- list(input_rows = nrow(plotted$data$input), retained_rows = nrow(plotted$data$selected),
      display_rows = nrow(plotted$data$display), display_lr_pairs = length(unique(plotted$data$display$lr_pair)),
      candidate_lr_pairs = nrow(plotted$data$rank),
      cell_types = length(plotted$data$cell_types), conditions = length(plotted$data$conditions))
    if (report$summary$cell_types > 12 || length(unique(plotted$data$display$cell_pair)) > 30) {
      check("display_density", "note", "Dense labels: inspect at final size; use a confirmed focused interaction subset if unreadable.")
    }
    report$stage <- "figure"
    patchwork::patchworkGrob(plotted$plot)
    source_dir <- file.path(run_dir, "source-data")
    dir.create(source_dir)
    for (name in c("input", "selected", "edges", "totals", "display", "rank", "pair_rank", "network_edges")) {
      readr::write_tsv(plotted$data[[name]], file.path(source_dir, paste0(name, ".tsv")))
    }
    if (!file.copy(path, file.path(source_dir, paste0("original.", tools::file_ext(path))))) stop("Cannot freeze original input.")
    manifest <- data.frame(path = path, md5 = original_hash, provenance = spec$inputs$provenance,
      score_definition = spec$inputs$score_definition, p_value_definition = spec$inputs$p_value_definition)
    paths <- ncfigR::export_figure_bundle(plotted$plot, "communication", file.path(run_dir, "figures"),
      width = spec$figure$width_mm / 25.4, height = spec$figure$height_mm / 25.4, source_manifest = manifest)
    if (any(!file.exists(unlist(paths))) || any(file.info(unlist(paths))$size <= 0)) stop("Empty export.")
    if (!identical(original_hash, unname(tools::md5sum(path)))) comm_abort("input_changed", "Input changed during execution; freeze and rerun.")
    check("figure_exports", "pass", "Non-empty PNG/PDF/SVG and exact panel tables exported; visual quality still unchecked.")
    resolved <- spec
    resolved$inputs$table <- "source-data/input.tsv"
    resolved$inputs$format <- "canonical"
    resolved$inputs$condition <- NULL
    resolved$output_dir <- "reproductions"
    if (!is.null(resolved$figure$cell_type_order)) resolved$figure$cell_type_order <- as.list(resolved$figure$cell_type_order)
    comm_json(resolved, file.path(run_dir, "resolved_job.json"))
    writeLines(c("# Methods record", paste("Source:", spec$inputs$provenance),
      paste("Score:", spec$inputs$score_definition), paste("P-value:", spec$inputs$p_value_definition),
      paste("Input rows:", nrow(data), "Retained:", nrow(plotted$data$selected)),
      if (is.null(spec$analysis$p_max)) "No additional filtering." else paste("Filter: upstream p_value <=", spec$analysis$p_max),
      "Sender-receiver edges and incoming/outgoing strengths are sums of retained upstream scores, separately per condition.",
      paste("LR display: top", spec$figure$top_n, "pairs by pooled score sum across supplied conditions; lexical tie-breaking; summaries still use all retained rows."),
      paste("Dot plot cell pairs: top", spec$figure$max_pairs, "by pooled retained score sum; display-only intersection with selected LR pairs; pair_rank.tsv records selection."),
      paste("Networks: top", spec$figure$network_top_n, "edges by score sum per condition; lexical tie-breaking; all observed cell types retained as vertices. Exact edges in network_edges.tsv."),
      "Missing pairs are absent, not inferred zeros. Fixed common score limits across conditions; no per-panel normalization.",
      "No differential statistics, donor-level inference or causal claims are generated. CellChat p-values are upstream model/permutation p-values, not adjusted donor-level evidence.",
      "Differences in cell composition, upstream settings and exported interaction coverage can change descriptive sums.",
      "See source-data/display.tsv, edges.tsv and totals.tsv for exact panel values."), file.path(run_dir, "methods.md"))
    writeLines(c("args <- commandArgs(trailingOnly = FALSE)",
      "script <- gsub('~+~', ' ', sub('^--file=', '', args[grepl('^--file=', args)][1]), fixed = TRUE)",
      "result <- commfigR::run_comm_job(file.path(dirname(normalizePath(script)), 'resolved_job.json'))",
      "cat(jsonlite::toJSON(result, auto_unbox = TRUE), '\\n')", "quit(status = result$exit_code)"), file.path(run_dir, "reproduce.R"))
    report$artifacts <- lapply(paths, function(x) substring(normalizePath(x, winslash = "/"), nchar(run_dir) + 2L))
    report$figure <- list(width_mm = spec$figure$width_mm, height_mm = spec$figure$height_mm,
      top_n = spec$figure$top_n, max_pairs = spec$figure$max_pairs, network_top_n = spec$figure$network_top_n)
    report$status <- "needs_review"
    report$stage <- "visual_review"
    report$next_action <- "Inspect PNG and PDF/SVG at final size. Submit six evidence-backed checks through review_comm_job; never infer publication quality from rendering success."
  }, warning = function(w) {
    report$warnings[[length(report$warnings) + 1L]] <<- conditionMessage(w)
    invokeRestart("muffleWarning")
  }), error = function(e) {
    report$errors[[1]] <<- list(code = if (inherits(e, "comm_job_error")) e$code else paste0(report$stage, "_failed"),
      message = conditionMessage(e), action = if (inherits(e, "comm_job_error")) e$action else
        "Read input contracts and failed stage; do not silently change scores, filters, conditions or scientific claims.")
  })
  report$finished_at <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  writeLines(c(report$started_at, unlist(report$warnings), vapply(report$errors, function(x) x$message, character(1)),
    report$status), file.path(run_dir, "run.log"))
  files <- list.files(run_dir, recursive = TRUE, full.names = TRUE)
  report$artifact_checksums <- lapply(files, function(x) list(path = substring(x, nchar(run_dir) + 2L), md5 = unname(tools::md5sum(x))))
  comm_json(report, file.path(run_dir, "report.json"))
  writeLines(c(paste("# Communication task", id), paste("Status:", report$status), paste("Scope:", report$scope),
    vapply(report$checks, function(x) paste("-", x$id, x$status, x$detail), character(1)),
    vapply(report$errors, function(x) paste(x$code, x$message, x$action), character(1)),
    unlist(report$warnings), "", report$next_action), file.path(run_dir, "report.md"))
  list(status = report$status, exit_code = if (report$status == "failed") 1L else 2L,
    run_dir = run_dir, report_path = file.path(run_dir, "report.json"), errors = report$errors, next_action = report$next_action)
}

#' Review a communication task
#' @param run_dir Executed task directory.
#' @param review_path Evidence-backed visual review JSON.
#' @return Review decision and report location.
#' @export
review_comm_job <- function(run_dir, review_path) {
  ncfigR::review_figure_job(run_dir, review_path, task = "communication_overview")
}
