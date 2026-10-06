# Existing Spatial Results: Execution Protocol

Load only for existing spatial coordinate/annotation/feature requests. Use the
`spatial_overview` task, not the atlas or communication runner. Runtime:
ncfigR 0.3.0, scfigR 0.4.0, commfigR 0.3.0, spfigR 0.2.2.

## Prepare

Read [the source contracts and example](../../../examples/spatial/README.md).
Confirm section and spot keys, selected features, provenance, expression scale,
coordinate units, y direction and the intended descriptive claim. Do not infer
image orientation from appearance. Image pixels are not micrometers.

Required JSON: `schema_version: "1.0"`, `task: "spatial_overview"`, `job_id`,
`inputs`, optional `figure`, and optional `output_dir`. Paths resolve relative
to the submitted task file. Unknown keys are rejected.

`inputs` contains `coordinates`, `features`, `expression_scale`,
`coordinate_unit`, `y_axis`, `provenance`, optional `regions` and `palette`.
`figure` accepts `width_mm`, `height_mm` (100-300 each), `point_size` (0.1-4),
optional complete `feature_order`, `domain_order`, `title`, `color_style` and
`feature_palette`. For choices read [the plotting base](plotting_base.md).
Default style is balanced. Never change scientific values to improve contrast.

## Execute and inspect

1. Verify `scripts/check_runtime.R`. Do not silently upgrade the runtime.
2. Run `Rscript scripts/run_sp_job.R --job <task.json>`; capture its JSON and
   exit status. Read the exact returned report, methods and frozen tables.
3. Inspect PNG plus PDF or SVG at the declared size. Check separate sections,
   equal aspect, declared y direction, shared feature limits, annotation colors,
   ROI labels and readable legends. Spot fractions must not be called cell
   fractions. A demonstration ROI must not become a claimed biological niche.
4. Submit the review below through `scripts/review_sp_job.R --run <run> --review
   <review.json>`. Paths refer to this run. Evidence must describe actual observed
   artwork; never approve uninspected vectors or let technical checks approve it.
5. For `revise`, create a new run with supported presentation corrections.
   Preserve scientific inputs and previous attempts; at most two automatic
   corrections. Changing genes, labels, coordinates or scale needs confirmation.

## Review schema

Use `schema_version: "1.0"`, exact `run_id`, nonempty `reviewer`,
`inspected_artifacts` containing the run's PNG and PDF or SVG, and
`final_size_mm: {"width": <declared>, "height": <declared>}`. `checks` must
contain all six keys: `text_legibility`, `label_overlap`, `legend_consistency`,
`panel_layout`, `color_scale`, `biological_claims`. Each value has `status`
(`pass` or `revise`) and a concrete `evidence` string of at least 12 characters.
Do not use placeholder observations. All passes produce `passed`; any revision
produces terminal `revise`. Frozen-file changes and cross-task review are errors.

Exit 1: failed. Exit 2: needs_review or revise. Exit 0: reviewed pass.
For version-checked reproduction run the frozen `resolved_job.json`; the
convenience `reproduce.R` direct API does not enforce the CLI version lock.

## Deliver

Return preview, vector artwork, report, methods and reproduction paths. Explain
single-section limitations, missing image registration and any unresolved
layout issue. This task preserves existing results; it does not infer spatial
domains, deconvolve cells or establish spatial association statistics.
