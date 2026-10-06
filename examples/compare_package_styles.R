source("scripts/runtime.R")
root <- normalizePath(".")
activate_runtime(root)
styles <- c("balanced", "muted", "vivid", "okabe_ito")
panels <- list()
for (kind in c("single-cell", "communication")) {
  filename <- if (kind == "single-cell") "task-pbmc3k.json" else "task-human-skin.json"
  base <- file.path(root, "examples", kind)
  original <- jsonlite::read_json(file.path(base, filename), simplifyVector = FALSE)
  selected_styles <- if (kind == "communication") styles[1:3] else styles
  for (style in selected_styles) {
    spec <- original
    for (key in intersect(c("embedding", "expression", "table"), names(spec$inputs))) {
      spec$inputs[[key]] <- normalizePath(file.path(base, spec$inputs[[key]]), mustWork = TRUE)
    }
    # Preset comparisons intentionally replace display colors, never data tables.
    spec$figure$palette <- NULL
    spec$figure$color_style <- style
    spec$job_id <- paste(kind, style, sep = "-")
    spec$output_dir <- file.path(base, "job-runs", "shared-color-comparison")
    dir.create(spec$output_dir, recursive = TRUE, showWarnings = FALSE)
    config <- file.path(spec$output_dir, paste0(style, ".json"))
    jsonlite::write_json(spec, config, auto_unbox = TRUE, pretty = TRUE, null = "null")
    run <- if (kind == "single-cell") scfigR::run_sc_job(config) else commfigR::run_comm_job(config)
    if (run$status != "needs_review") stop(jsonlite::toJSON(run, auto_unbox = TRUE))
    report <- jsonlite::read_json(run$report_path)
    source_dir <- file.path(run$run_dir, "source-data")
    if (style == "balanced") baseline <- source_dir else {
      tables <- if (kind == "single-cell") c("embedding.tsv", "expression.tsv", "composition.tsv", "markers.tsv") else c("input.tsv", "edges.tsv", "totals.tsv", "display.tsv", "network_edges.tsv")
      for (table in tables) stopifnot(identical(unname(tools::md5sum(file.path(baseline, table))), unname(tools::md5sum(file.path(source_dir, table)))))
    }
    png <- file.path(run$run_dir, report$artifacts$png)
    panels[[style]] <- cowplot::ggdraw() + cowplot::draw_image(png, y = 0, height = .94) +
      cowplot::draw_label(style, x = 0.02, y = 0.98, hjust = 0, vjust = 1, size = 11)
    cat(kind, style, run$run_dir, "\n")
  }
  plot <- cowplot::plot_grid(plotlist = panels[selected_styles], ncol = 2)
  ggplot2::ggsave(file.path(root, "assets", paste0(kind, "-color-comparison.png")), plot,
    width = 14, height = if (kind == "single-cell") 10 else 15, dpi = 140, bg = "white")
  panels <- list()
}
