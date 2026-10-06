compose_nc_figure <- function(panels, ncol = NULL, labels = "AUTO", title = NULL, design = NULL,
                              widths = NULL, heights = NULL, guides = c("auto", "collect", "keep")) {
  guides <- match.arg(guides)
  if (!is.list(panels) || length(panels) == 0) {
    stop("panels must be a non-empty list of ggplot objects.", call. = FALSE)
  }
  if (!all(vapply(panels, inherits, logical(1), what = "ggplot"))) {
    stop("every panel must be a ggplot or patchwork object.", call. = FALSE)
  }
  if (!is.null(ncol) && (length(ncol) != 1L || !is.numeric(ncol) ||
      !is.finite(ncol) || ncol < 1 || ncol != as.integer(ncol))) {
    stop("ncol must be a positive integer.", call. = FALSE)
  }
  for (value in list(widths, heights)) {
    if (!is.null(value) && (!is.numeric(value) || !length(value) ||
        any(!is.finite(value)) || any(value <= 0))) {
      stop("widths and heights must be positive finite numeric vectors.", call. = FALSE)
    }
  }
  if (identical(labels, "AUTO")) {
    tag_levels <- "A"
  } else if (is.null(labels)) {
    tag_levels <- NULL
  } else {
    if (!is.character(labels) || length(labels) != length(panels) ||
        anyNA(labels) || any(!nzchar(labels)) || anyDuplicated(labels)) {
      stop("labels must be AUTO, NULL, or one unique label per panel.", call. = FALSE)
    }
    tag_levels <- list(labels)
  }
  patchwork::wrap_plots(panels, ncol = ncol, design = design,
    widths = widths, heights = heights, guides = guides) +
    patchwork::plot_annotation(title = title, tag_levels = tag_levels)
}

export_figure_bundle <- function(plot, basename, out_dir = "figures/exports",
                                 width = 7, height = 5,
                                 source_manifest = NULL, overwrite = TRUE) {
  if (!inherits(plot, "ggplot")) stop("plot must be a ggplot or patchwork object.", call. = FALSE)
  if (!is.character(basename) || length(basename) != 1L || is.na(basename) ||
      !grepl("^[A-Za-z0-9][A-Za-z0-9_.-]*$", basename)) {
    stop("basename must be a file name without path separators.", call. = FALSE)
  }
  if (!is.character(out_dir) || length(out_dir) != 1L || is.na(out_dir) || !nzchar(out_dir)) {
    stop("out_dir must be a non-empty directory path.", call. = FALSE)
  }
  for (value in list(width, height)) {
    if (!is.numeric(value) || length(value) != 1L || !is.finite(value) || value <= 0) {
      stop("width and height must be positive finite numbers in inches.", call. = FALSE)
    }
  }
  if (!is.logical(overwrite) || length(overwrite) != 1L || is.na(overwrite)) {
    stop("overwrite must be TRUE or FALSE.", call. = FALSE)
  }
  if (!is.null(source_manifest) && !is.data.frame(source_manifest)) {
    stop("source_manifest must be a data frame.", call. = FALSE)
  }
  dirs <- file.path(out_dir, c("pdf", "svg", "png"))
  for (d in dirs) {
    dir.create(d, recursive = TRUE, showWarnings = FALSE)
    if (!dir.exists(d)) stop("cannot create output directory: ", d, call. = FALSE)
  }

  pdf_path <- file.path(out_dir, "pdf", paste0(basename, ".pdf"))
  svg_path <- file.path(out_dir, "svg", paste0(basename, ".svg"))
  png_path <- file.path(out_dir, "png", paste0(basename, ".png"))

  manifest_path <- NULL
  if (!is.null(source_manifest)) {
    manifest_path <- file.path(out_dir, paste0(basename, "_source_manifest.tsv"))
  }
  session_path <- file.path(out_dir, paste0(basename, "_sessionInfo.txt"))
  paths <- c(pdf_path, svg_path, png_path, manifest_path, session_path)
  if (any(dir.exists(paths))) stop("an output path is an existing directory.", call. = FALSE)
  if (!overwrite && any(file.exists(paths))) stop("output files already exist; use overwrite = TRUE.", call. = FALSE)

  stage <- tempfile(".ncfigR-", tmpdir = out_dir)
  dir.create(stage)
  on.exit(unlink(stage, recursive = TRUE), add = TRUE)
  staged <- file.path(stage, base::basename(paths))
  # Render all formats before replacing any existing bundle.
  render <- function(path, open_device) {
    open_device(path)
    device <- grDevices::dev.cur()
    on.exit(grDevices::dev.off(which = device), add = TRUE)
    print(plot)
  }
  render(staged[1], function(p) grDevices::pdf(p, width = width, height = height))
  render(staged[2], function(p) svglite::svglite(p, width = width, height = height))
  render(staged[3], function(p) grDevices::png(p, width = width, height = height, units = "in", res = 300))
  if (!is.null(source_manifest)) readr::write_tsv(source_manifest, staged[4])
  writeLines(utils::capture.output(utils::sessionInfo()), staged[length(staged)])

  existed <- file.exists(paths)
  stale_manifest <- file.path(out_dir, paste0(basename, "_source_manifest.tsv"))
  remove_stale <- is.null(source_manifest) && file.exists(stale_manifest)
  stale_backup <- file.path(stage, "stale-manifest")
  if (remove_stale && !file.copy(stale_manifest, stale_backup)) {
    stop("cannot back up existing manifest.", call. = FALSE)
  }
  backups <- file.path(stage, paste0("backup-", seq_along(paths)))
  for (i in which(existed)) {
    if (!file.copy(paths[i], backups[i])) stop("cannot back up existing output.", call. = FALSE)
  }
  written <- integer()
  complete <- FALSE
  on.exit({
    if (!complete) for (i in written) {
      if (existed[i]) file.copy(backups[i], paths[i], overwrite = TRUE) else unlink(paths[i])
    }
    if (!complete && remove_stale) file.copy(stale_backup, stale_manifest, overwrite = TRUE)
  }, add = TRUE, after = FALSE)
  for (i in seq_along(paths)) {
    written <- c(written, i)
    if (!file.copy(staged[i], paths[i], overwrite = TRUE)) stop("cannot write output: ", paths[i], call. = FALSE)
  }
  if (remove_stale && unlink(stale_manifest) != 0L) stop("cannot remove stale source manifest.", call. = FALSE)
  complete <- TRUE
  invisible(list(pdf = pdf_path, svg = svg_path, png = png_path,
                 manifest = manifest_path, session = session_path))
}
