# Optional Other Plotting Domains

Load only when the user requests additional spatial panels, trajectory, benchmark, multi-omics, genome-track, or additional non-atlas visualization. These domains are outside the stable single_cell_atlas runner. For supported communication_overview and spatial_overview tasks use communication_execution.md and spatial_execution.md instead. Do not send their tables to run_sc_job.R.

Read only the matching domain API and source-data contract. Verify package availability, exported functions, implementation and tests before calling anything. Historical MVP routing below describes candidate capabilities, not equivalent validation or a supported execution/review loop. Report unsupported panels clearly; do not imply that an image overlay, velocity analysis, or statistical test is implemented from a template alone.

### 9. R Package Router Mode

Use when the user asks which local R package should draw a figure, how to call self-built R packages from the plugin, or how to turn a project figure into package functions.

Read:

- `r_package_router.md`
- `code_pattern_inventory.md`
- `ncfigR_api.md`
- `scfigR_api.md` when the request is single-cell atlas, marker, composition, or module-score work
- `spfigR_api.md` when the request is spatial domain, tissue niche, spatial feature, zoom, or composition work
- `commfigR_api.md` when the request is ligand-receptor, cell-cell communication, sender/receiver score, or differential communication work
- `trajfigR_api.md` when the request is pseudotime, branch, velocity, gene trend, or state-transition work
- `benchfigR_api.md` when the request is benchmark, method comparison, runtime, robustness, rank, or biological case panel work
- `multiomfigR_api.md` when the request is multi-omics integration, cross-dataset validation, regulatory links, feature links, pathway programs, or modality metrics
- `project_scaffold_templates.md`

Return:

- recommended package: `ncfigR`, `scfigR`, `spfigR`, `commfigR`, `trajfigR`, `benchfigR`, or `multiomfigR`
- current implementation status: `implemented in ncfigR`, `implemented in scfigR`, `implemented in spfigR`, `implemented in commfigR`, `implemented in trajfigR`, `implemented in benchfigR`, `implemented in multiomfigR`, `stub needed`, or `package planned`
- target function names and source-data table schemas
- fallback `ncfigR` calls when a domain package is not implemented yet
- reference GitHub repo/code paths that motivated the pattern
- QA checks and project-transfer steps

Routing defaults:

- single-cell atlas, UMAP, marker dotplot, composition, module score -> `scfigR` prototype; verify actual functions and tests, `ncfigR` shared base/fallback
- Existing section-aware spatial overview -> `spfigR` 0.2.2 task; read `spatial_execution.md`. Other direct spatial APIs have separate contracts.
- histology image overlay / segmentation mask overlay -> `spfigR` package target, image-specific overlay still `stub needed`
- Existing communication overview -> `commfigR` 0.3.0 task; read `communication_execution.md`. Differential communication is a separate direct API and needs confirmed upstream statistics.
- pseudotime, velocity, branch, gene trend, state transition -> `trajfigR` prototype; verify actual functions and tests, `ncfigR` shared base/fallback
- method benchmark, rank plot, runtime/memory, robustness, biological case panel -> `benchfigR` prototype; verify actual functions and tests, `ncfigR` shared base/fallback
- multi-omics integration, cross-dataset validation, regulatory/feature links, pathway/program panel -> `multiomfigR` prototype; verify actual functions and tests, `ncfigR` shared base/fallback

### 10. Template Generation Mode

Use when the user asks for R/Python plotting code.

Read `plot_recipe_cards.md`, then generate minimal editable code using the user's file paths or toy data.

Supported recipe families:

- UMAP / embedding narrative
- spatial domain / histology overlay
- annotation heatmap
- pathway or module heatmap
- ligand-receptor / communication network
- trajectory / velocity
- genome track / variant effect
- benchmark heatmap / rank plot
- multi-omics Figure 1 assembly
