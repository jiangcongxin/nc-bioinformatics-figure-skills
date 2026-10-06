# Optional Figure Planning

Load only when the user asks for figure selection, manuscript planning, reusable plotting scaffolds, or package development. This is not the default task execution path. Read only the references needed for that request. Do not add literature research or unsupported panels to an ordinary single-cell atlas task.

### 1. Figure Decision Mode

Use this when the user has a project result set, figure idea, or uncertain panel list and asks what should go into the main figure.

Read:

- `figure_decision_engine.md`
- `nc_sc_spatial_figure_templates.md`
- `visual_decision_rules.md`
- `code_asset_inventory.md` when code-learning sources are needed

Return:

- the inferred project type, one-sentence claim, and available evidence layers
- the best matching Figure-level template
- panel keep/drop/move-to-supplement decisions
- plot type for each retained panel and the reason
- missing evidence or weak claims that should not be overdrawn
- A1/A2/A3 code assets to learn from
- a compact implementation-ready panel table

### 2. Visual QA Mode

Use this when the user provides a draft figure, a panel table, exported image, or asks whether a figure looks NC-style and submission-ready.

Read:

- `visual_qa_scorecard.md`
- `nc_palette_and_layout_rules.md`
- `visual_decision_rules.md`

Return:

- an overall QA verdict: `pass`, `revise`, or `major redesign`
- severity-ranked issues: `critical`, `major`, `minor`
- checks for claim focus, panel hierarchy, plot-choice fit, palette stability, legend economy, layout density, source-data readiness, and export format
- precise fixes, not vague aesthetic comments
- a revised panel order if needed

### 3. Project Scaffold Mode

Use this when the user wants a reusable project-local plotting system, figure directory, palette files, source-data manifests, or starter R/Python scripts.

Read:

- `project_scaffold_templates.md`
- `plot_recipe_cards.md`
- `nc_palette_and_layout_rules.md`

Return or create, when explicitly asked to write files:

- a `figures/` scaffold with `palettes/`, `source_data/`, `scripts/`, `exports/`, and `qa/`
- palette templates for cell types, groups, domains, methods, and continuous scores
- a `figure_plan.tsv` and `source_data_manifest.tsv`
- starter R/Python scripts matched to the selected Figure template
- a QA checklist that can be rerun after every export

### 4. Figure Template Training Mode

Use this as the default when the user asks how to design a main figure, how to learn NC-style plotting, how to decide plot types, how to assemble panels, or how to choose colors.

Read:

- `nc_sc_spatial_figure_templates.md`
- `visual_decision_rules.md`
- `nc_palette_and_layout_rules.md`
- `code_asset_inventory.md` when GitHub code paths are needed

Return:

- the best matching figure-level template
- what information belongs in the main figure and what should move to supplement
- panel order and visual grammar
- layout grid and panel hierarchy
- recommended R/Python plotting stack, using only confirmed package evidence or marking `待复核`
- GitHub/notebook/script entrypoints to learn from
- one toy-data replication exercise and one project-transfer exercise
- palette and legend rules that should remain fixed across the manuscript

Template priority for single-cell/spatial projects:

1. Atlas Overview Figure
2. Disease vs Control Cell-State Figure
3. Spatial Tissue Niche Figure
4. Cell-State Program Figure
5. Trajectory Figure
6. Cell-Cell Communication Figure
7. Spatial Multi-Sample Comparison Figure
8. Treatment/Condition Response Figure
9. Annotation/Marker Validation Figure
10. Benchmark + Biological Case Figure
11. Supplement QC Figure
12. NC Panel Hierarchy Figure

### 5. Project Figure Planning Mode

Use this as the default when the user has a research project, result table, or manuscript claim.

First establish or infer:

- project type: public-data multi-omics, scRNA, spatial, bulk transcriptomics, proteomics, epigenomics, microbiome, or model benchmark
- core claim: one sentence the main figure should prove
- available outputs: metadata, UMAP/embedding, DE table, pathway scores, module scores, interaction results, trajectory, validation cohort, benchmark metrics

For single-cell or spatial projects, first map to `nc_sc_spatial_figure_templates.md`; for broad public-data or multi-omics projects, map to `multiomics_public_project_templates.md`.

Return:

- Figure 1-4 structure plus Supplement plan
- panel order and plot type per panel
- exact input tables/objects needed for each panel
- recommended R/Python plotting stack
- code-learning sources from `code_asset_inventory.md`
- NC-style polish checklist

### 7. Code Craft / ncfigR Package Mode

Use when the user wants to write code at the level of high-quality GitHub repositories, build reusable R plotting functions, or generate advanced composite figures with the local `ncfigR` package.

Read:

- `code_craft_rules.md`
- `ncfigR_api.md`
- `advanced_composite_code_templates.md`
- `code_recipe_cards.md` when a repo pattern is named

Return:

- the repo pattern being abstracted, without copying paper code
- the `ncfigR` function calls or new function design
- required source-data table schema
- optional Seurat adapter step if relevant
- palette/source-data/export requirements
- toy-data test plan
- code review checklist for matching high-quality repo standards
