review_sc_job <- function(run_dir, review_path) {
  run_dir <- normalizePath(run_dir, winslash = "/", mustWork = TRUE)
  report_path <- file.path(run_dir, "report.json")
  report <- jsonlite::read_json(report_path, simplifyVector = FALSE)
  if (!identical(report$status, "needs_review")) {
    job_abort("review_not_allowed", "Only a technically completed run awaiting review can be reviewed.", "Failed, revised or approved runs are terminal. Create a new task attempt for corrections.")
  }
  for (artifact in report$artifact_checksums) {
    path <- normalizePath(file.path(run_dir, artifact$path), winslash = "/", mustWork = FALSE)
    if (!startsWith(path, paste0(run_dir, "/")) || !file.exists(path) ||
        !identical(unname(tools::md5sum(path)), artifact$md5)) {
      job_abort("artifact_changed", paste("Output missing or changed since execution:", artifact$path),
        "Rerun the job from preserved inputs; do not approve changed outputs.")
    }
  }
  review <- jsonlite::read_json(review_path, simplifyVector = FALSE)
  job_object(review, c("schema_version", "run_id", "reviewer", "inspected_artifacts", "final_size_mm", "checks"),
    c("schema_version", "run_id", "reviewer", "inspected_artifacts", "final_size_mm", "checks"), "review")
  if (!identical(review$schema_version, "1.0") || !identical(review$run_id, report$run_id)) {
    job_abort("review_mismatch", "Review schema/run ID does not match the task report.", "Inspect and review the correct run.")
  }
  job_string(review$reviewer, "reviewer")
  inspected <- job_array(review$inspected_artifacts, "inspected_artifacts")
  if (!all(inspected %in% unlist(report$artifacts, use.names = FALSE)) ||
      !report$artifacts$png %in% inspected ||
      !any(unlist(report$artifacts[c("pdf", "svg")], use.names = FALSE) %in% inspected)) {
    job_abort("review_incomplete", "Review must list this run's PNG and at least one vector artifact.",
      "Actually inspect the PNG plus PDF or SVG at final size, and record only files that were inspected.")
  }
  job_object(review$final_size_mm, c("width", "height"), c("width", "height"), "final_size_mm")
  if (!is.numeric(review$final_size_mm$width) || !is.numeric(review$final_size_mm$height) ||
      !identical(as.numeric(review$final_size_mm$width), as.numeric(report$figure$width_mm)) ||
      !identical(as.numeric(review$final_size_mm$height), as.numeric(report$figure$height_mm))) {
    job_abort("review_size_mismatch", "Visual review must use the configured final figure size.", "Inspect at the reported physical dimensions, not only a zoomed preview.")
  }
  required_checks <- c("text_legibility", "label_overlap", "legend_consistency", "panel_layout", "color_scale", "biological_claims")
  job_object(review$checks, required_checks, required_checks, "review.checks")
  decisions <- character()
  for (name in required_checks) {
    check <- review$checks[[name]]
    job_object(check, c("status", "evidence"), c("status", "evidence"), paste0("checks.", name))
    if (!identical(check$status, "pass") && !identical(check$status, "revise")) {
      job_abort("invalid_review", "Each visual check must be pass or revise.", "Use revise when a check is unresolved; do not default unchecked items to pass.")
    }
    evidence <- job_string(check$evidence, paste0(name, ".evidence"))
    if (nchar(trimws(evidence)) < 12L || grepl("^(todo|placeholder|not inspected|not checked)$", trimws(evidence), ignore.case = TRUE)) {
      job_abort("review_evidence_missing", "Each visual check requires a concrete observation, not a placeholder.", "Record what was observed in this run; unreadable or uninspected figures cannot pass.")
    }
    decisions <- c(decisions, check$status)
  }
  review$recorded_at <- format(Sys.time(), "%Y-%m-%dT%H:%M:%SZ", tz = "UTC")
  review$assurance <- "Self-reported inspection by the named reviewer; no independent authentication or journal-quality certification"
  path <- tempfile("review-", tmpdir = run_dir, fileext = ".json")
  job_json(review, path)
  report$review <- review
  report$review_record <- basename(path)
  report$status <- if (all(decisions == "pass")) "passed" else "revise"
  report$stage <- "reviewed"
  report$next_action <- if (report$status == "passed") "Deliver the artifacts, source data, methods and review record; state the descriptive scope and review limitations." else
    "Fix presentation issues in a new task configuration and rerun. Changes to data, annotation, expression scale, detection definitions or statistical design require user confirmation."
  job_write_report(report, run_dir)
  list(status = report$status, exit_code = if (report$status == "passed") 0L else 2L,
    run_dir = run_dir, report_path = report_path, next_action = report$next_action)
}
