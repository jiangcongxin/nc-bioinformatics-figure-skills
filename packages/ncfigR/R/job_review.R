#' Review a traceable figure task
#'
#' Verifies frozen artifact checksums and six evidence-backed visual checks.
#' This is a self-reported inspection record, not reviewer authentication.
#' @param run_dir Directory containing report.json and frozen artifacts.
#' @param review_path JSON review with run ID, inspected artifacts, final size
#'   and text_legibility, label_overlap, legend_consistency, panel_layout,
#'   color_scale and biological_claims checks (status pass/revise and evidence).
#' @param task Required task identifier; prevents reviewing another task type.
#' @return A list with status, exit_code, run_dir and report_path.
#' @export
review_figure_job <- function(run_dir, review_path, task) {
  abort <- function(code, message) stop(structure(list(message = message,
    call = NULL, code = code), class = c("figure_review_error", "error", "condition")))
  object <- function(x, keys, name) {
    if (!is.list(x) || is.null(names(x)) || anyDuplicated(names(x)) ||
        !setequal(names(x), keys)) abort("invalid_review", paste(name, "has invalid or missing keys."))
  }
  string <- function(x) is.character(x) && length(x) == 1L && !is.na(x) && nzchar(trimws(x))
  write_json <- function(x, path) {
    temporary <- tempfile(tmpdir = dirname(path))
    on.exit(unlink(temporary), add = TRUE)
    jsonlite::write_json(x, temporary, auto_unbox = TRUE, pretty = TRUE, null = "null", digits = NA)
    if (!file.copy(temporary, path, overwrite = TRUE)) stop("Cannot write review record.")
  }
  run_dir <- normalizePath(run_dir, winslash = "/", mustWork = TRUE)
  path <- file.path(run_dir, "report.json")
  report <- jsonlite::read_json(path, simplifyVector = FALSE)
  if (!string(task) || !identical(report$task, task)) abort("review_mismatch", "Task does not match this review entry point.")
  if (!identical(report$status, "needs_review")) abort("review_not_allowed", "Only a run awaiting review can be reviewed; terminal runs need a new attempt.")
  if (!length(report$artifact_checksums)) abort("missing_checksums", "Frozen artifact checksums are required.")
  for (artifact in report$artifact_checksums) {
    if (!string(artifact$path) || !string(artifact$md5)) abort("invalid_checksum", "Malformed artifact record.")
    file <- normalizePath(file.path(run_dir, artifact$path), winslash = "/", mustWork = FALSE)
    if (!startsWith(file, paste0(run_dir, "/")) || !file.exists(file) || dir.exists(file) ||
        !identical(unname(tools::md5sum(file)), artifact$md5)) {
      abort("artifact_changed", paste("Output missing or changed since execution:", artifact$path))
    }
  }
  review <- jsonlite::read_json(review_path, simplifyVector = FALSE)
  object(review, c("schema_version", "run_id", "reviewer", "inspected_artifacts", "final_size_mm", "checks"), "review")
  if (!identical(review$schema_version, "1.0") || !identical(review$run_id, report$run_id) ||
      !string(review$reviewer)) abort("review_mismatch", "Review schema, reviewer or run ID does not match.")
  inspected <- review$inspected_artifacts
  if (!is.list(inspected) || !is.null(names(inspected)) || !length(inspected) ||
      !all(vapply(inspected, string, logical(1)))) abort("invalid_review", "inspected_artifacts must be an array of paths.")
  inspected <- unlist(inspected, use.names = FALSE)
  recorded <- vapply(report$artifact_checksums, function(x) x$path, character(1))
  if (anyDuplicated(inspected) || !all(inspected %in% recorded) ||
      !report$artifacts$png %in% inspected ||
      !any(unlist(report$artifacts[c("pdf", "svg")]) %in% inspected)) {
    abort("review_incomplete", "Inspect and list this run's PNG and at least one vector artifact.")
  }
  object(review$final_size_mm, c("width", "height"), "final_size_mm")
  for (axis in c("width", "height")) {
    size <- review$final_size_mm[[axis]]
    if (!is.numeric(size) || length(size) != 1L || !is.finite(size) ||
        size != report$figure[[paste0(axis, "_mm")]]) abort("review_size_mismatch", "Review must use the configured final figure size.")
  }
  checks <- c("text_legibility", "label_overlap", "legend_consistency", "panel_layout", "color_scale", "biological_claims")
  object(review$checks, checks, "checks")
  for (name in checks) {
    check <- review$checks[[name]]
    object(check, c("status", "evidence"), name)
    if (!string(check$status) || !check$status %in% c("pass", "revise") ||
        !string(check$evidence) || nchar(trimws(check$evidence)) < 12L ||
        grepl("^(todo|placeholder|not inspected|not checked)$", trimws(check$evidence), ignore.case = TRUE)) {
      abort("review_evidence_missing", "Every check needs pass/revise and a concrete observation.")
    }
  }
  review$recorded_at <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  review$assurance <- "Self-reported inspection; no reviewer authentication or biological/journal certification."
  report$status <- if (all(vapply(review$checks, function(x) x$status == "pass", logical(1)))) "passed" else "revise"
  report$stage <- "reviewed"
  report$review <- review
  report$review_record <- basename(tempfile("review-", tmpdir = run_dir, fileext = ".json"))
  report$next_action <- if (report$status == "passed") "Deliver artwork, source tables, methods and review limitations." else
    "Correct presentation in a new run. Scientific changes require user confirmation."
  write_json(review, file.path(run_dir, report$review_record))
  write_json(report, path)
  writeLines(c(paste("# Figure task", report$job_id), paste("Status:", report$status),
    paste("Scope:", report$scope), "", vapply(report$checks, function(x) paste("-", x$id, x$status, x$detail), character(1)),
    "", "## Visual review", vapply(names(review$checks), function(x) paste("-", x,
      review$checks[[x]]$status, review$checks[[x]]$evidence), character(1)), "",
    "## Execution warnings", if (length(report$warnings)) unlist(report$warnings) else "None recorded.",
    report$next_action, review$assurance), file.path(run_dir, "report.md"))
  list(status = report$status, exit_code = if (report$status == "passed") 0L else 2L,
    run_dir = run_dir, report_path = path, next_action = report$next_action)
}
