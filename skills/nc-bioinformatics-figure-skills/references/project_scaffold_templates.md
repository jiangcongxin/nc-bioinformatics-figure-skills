# Project Scaffold Templates

Purpose: create a reusable project-local figure system for NC-style single-cell, spatial, and public-data omics projects. The scaffold keeps palettes, source data, scripts, exports, and QA separate so figures can be redrawn and audited.

## Default Directory Structure

Use this structure unless the user requests another project convention:

```text
figures/
  palettes/
    cell_type_palette.tsv
    group_palette.tsv
    domain_palette.tsv
    method_palette.tsv
    score_scales.yml
  source_data/
    source_data_manifest.tsv
    fig1_panel_table.tsv
  scripts/
    00_load_inputs.R
    00_load_inputs.py
    fig1_atlas_overview.R
    fig1_atlas_overview.py
    fig_advanced_composite_ncfigR.R
  exports/
    png/
    pdf/
    svg/
  qa/
    figure_qa_checklist.tsv
    figure_decision_log.md
  code_learning/
    repo_index.tsv
    learning_plan.tsv
    package_router.tsv
    code_pattern_inventory.tsv
    recipes/
    toy_data/
    scripts/
  packages/
    ncfigR/
    scfigR/
    spfigR/
    commfigR/
    trajfigR/
    benchfigR/
    multiomfigR/
```

For single-language projects, create only the requested R or Python scripts.

## Core Planning Files

### `figure_plan.tsv`

```text
figure_id	panel_id	role	template	plot_type	input_file	package_stack	code_asset	status
Fig1	A	context	Atlas Overview Figure	workflow	metadata.tsv	ggplot2	none	planned
Fig1	B	anchor	Atlas Overview Figure	UMAP	adata.h5ad	scanpy	scPRINT:nice_umap.ipynb	planned
Fig1	C	quantification	Atlas Overview Figure	composition_bar	cell_metadata.tsv	ggplot2	Panpipes:plot_metrics.R	planned
```

### `source_data_manifest.tsv`

```text
figure_id	panel_id	source_file	required_columns	object_type	created_by	redraw_status
Fig1	B	source_data/fig1b_umap_cells.tsv	cell_id,x,y,cell_type,group,score	table	fig1_atlas_overview.py	ready
Fig1	C	source_data/fig1c_cell_fraction.tsv	group,cell_type,n,proportion	table	fig1_atlas_overview.R	ready
```

### `figure_qa_checklist.tsv`

```text
figure_id	check_item	status	notes
Fig1	one_sentence_claim	pending	
Fig1	panel_hierarchy	pending	
Fig1	palette_consistency	pending	
Fig1	source_data_complete	pending	
Fig1	vector_export	pending	
```

### `figures/code_learning/repo_index.tsv`

```text
repo	evidence_level	figure_skill	code_path	language	confirmed_packages	why_selected
MoFlow	A1	trajectory	notebooks/fig2.ipynb; src/MoFlow/plot_cell.py	Python	matplotlib,numpy,pandas,scipy,seaborn,sklearn	trajectory map plus gene dynamics recipe
FastCCC	A1	communication	fastccc_demo.ipynb; examples/report_single_condition.py	Python	numpy,pandas,scipy,scanpy,gseapy,matplotlib,seaborn,networkx	LR heatmap and filtered network recipe
```

### `figures/code_learning/learning_plan.tsv`

```text
week	day	figure_panel	target_skill	repo	code_path	toy_data	script	status
1	1	Fig1B	UMAP / embedding	scPRINT	figures/nice_umap.ipynb	toy_data/embedding_cells.tsv	scripts/fig1b_umap_toy.py	planned
1	2	Fig4B	communication	FastCCC	examples/report_single_condition.py	toy_data/lr_pairs.tsv	scripts/fig4b_lr_heatmap_toy.py	planned
```

### `figures/code_learning/package_router.tsv`

```text
figure_template	panel_role	data_type	r_package	function	input_table	status	reference_repo
Atlas Overview Figure	embedding	scRNA	scfigR	plot_sc_embedding_panel	embedding.tsv	implemented in scfigR	scPRINT; Panpipes
Atlas Overview Figure	marker_dotplot	scRNA	scfigR	plot_marker_dotplot_panel	marker_dotplot.tsv	implemented in scfigR	CellMentor; Panpipes
Atlas Overview Figure	module_score	scRNA	scfigR	plot_module_score_panel	module_scores.tsv	implemented in scfigR	scFoundation; CellMentor
Spatial Tissue Niche Figure	spatial_map	spatial	spfigR	plot_spatial_domain_panel	spatial_coordinates.tsv	implemented in spfigR	Sopa; scHolography
Spatial Tissue Niche Figure	spatial_feature	spatial	spfigR	plot_spatial_feature_panel	spatial_features.tsv	implemented in spfigR	FineST; scHolography
Spatial Tissue Niche Figure	domain_composition	spatial	spfigR	plot_spatial_composition_panel	spatial_composition.tsv	implemented in spfigR	Tumor-cell-villages; Sopa
Spatial Tissue Niche Figure	zoom	spatial	spfigR	plot_spatial_zoom_panel	spatial_zoom_regions.tsv	implemented in spfigR	FineST; Tumor-cell-villages
Cell-Cell Communication Figure	lr_heatmap	communication	commfigR	plot_lr_heatmap_panel	lr_pairs.tsv	implemented in commfigR	FastCCC
Cell-Cell Communication Figure	filtered_network	communication	commfigR	plot_lr_network_panel	network_edges.tsv	implemented in commfigR	FastCCC; Tumor-cell-villages
Cell-Cell Communication Figure	sender_receiver_score	communication	commfigR	plot_sender_receiver_score_panel	communication_scores.tsv	implemented in commfigR	Human_endometrium; FineST
Cell-Cell Communication Figure	differential_lr	communication	commfigR	plot_differential_communication_panel	differential_lr.tsv	implemented in commfigR	FastCCC
Trajectory Figure	pseudotime_map	trajectory	trajfigR	plot_pseudotime_embedding_panel	trajectory_cells.tsv	implemented in trajfigR	MoFlow; ILC-NK-HIPEC
Trajectory Figure	velocity_map	trajectory	trajfigR	plot_velocity_embedding_panel	velocity_vectors.tsv	implemented in trajfigR	MoFlow; ddHodge_figures
Trajectory Figure	branch_probability	trajectory	trajfigR	plot_branch_probability_panel	branch_probabilities.tsv	implemented in trajfigR	ILC-NK-HIPEC
Trajectory Figure	gene_trend	trajectory	trajfigR	plot_gene_trend_panel	gene_trends.tsv	implemented in trajfigR	MoFlow; ILC-NK-HIPEC
Trajectory Figure	state_transition	trajectory	trajfigR	plot_state_transition_panel	state_transitions.tsv	implemented in trajfigR	ddHodge_figures; VeloCD
Benchmark + Biological Case Figure	metric_heatmap	benchmark	benchfigR	plot_metric_heatmap_panel	benchmark_metrics.tsv	implemented in benchfigR	NEP_comparison; scFoundation
Benchmark + Biological Case Figure	rank_summary	benchmark	benchfigR	plot_rank_panel	benchmark_ranks.tsv	implemented in benchfigR	NEP_comparison; scFoundation
Benchmark + Biological Case Figure	runtime_memory	benchmark	benchfigR	plot_runtime_panel	runtime_metrics.tsv	implemented in benchfigR	CellANOVA; scFoundation
Benchmark + Biological Case Figure	robustness	benchmark	benchfigR	plot_robustness_panel	robustness_metrics.tsv	implemented in benchfigR	CellANOVA; NEP_comparison
Benchmark + Biological Case Figure	representative_case	benchmark	benchfigR	plot_case_embedding_panel	case_embedding.tsv	implemented in benchfigR	CellANOVA; scFoundation
Multi-omics Integration Figure	integrated_embedding	multi-omics	multiomfigR	plot_integration_embedding_panel	integration_embedding.tsv	implemented in multiomfigR	SMART; CAMEX
Multi-omics Integration Figure	modality_metric	multi-omics	multiomfigR	plot_modality_metric_panel	modality_metrics.tsv	implemented in multiomfigR	SMART; SpatialGlue
Multi-omics Integration Figure	cross_dataset_validation	multi-omics	multiomfigR	plot_cross_dataset_validation_panel	cross_dataset_validation.tsv	implemented in multiomfigR	CAMEX; SMART
Multi-omics Integration Figure	feature_links	multi-omics	multiomfigR	plot_feature_link_panel	feature_links.tsv	implemented in multiomfigR	cPeaks; GET; AlphaGenome
Multi-omics Integration Figure	pathway_program	multi-omics	multiomfigR	plot_pathway_program_panel	pathway_programs.tsv	implemented in multiomfigR	Human_endometrium; GET
```

### `figures/code_learning/code_pattern_inventory.tsv`

```text
repo	paper	figure_family	figure_panel	code_path	language	package_stack	input_schema	output_plot	reusable_pattern	target_r_package	target_function	evidence_level	followup_status
FastCCC	FastCCC	cell-cell communication	LR heatmap	examples/report_single_condition.py	Python	pandas,seaborn,networkx	lr_pairs.tsv	LR heatmap + network	full LR table first, filtered network second	commfigR	plot_lr_heatmap_panel	A1	ready for source-data rewrite
```

### `figures/scripts/fig_advanced_composite_ncfigR.R`

```r
library(ncfigR)

embedding <- readr::read_tsv("figures/source_data/embedding.tsv")
composition <- readr::read_tsv("figures/source_data/composition.tsv")
markers <- readr::read_tsv("figures/source_data/marker_matrix.tsv")
palette <- read_nc_palette("figures/palettes/cell_type_palette.tsv")

p1 <- plot_embedding_panel(embedding, color_col = "cell_type", palette = palette, label = TRUE)
p2 <- plot_composition_panel(composition, palette = palette)
p3 <- plot_marker_heatmap(markers)

fig <- compose_nc_figure(list(p1, p2, p3), ncol = 3, title = "NC-style composite figure")
export_figure_bundle(fig, "fig_advanced_composite", out_dir = "figures/exports")
```

## Palette Templates

### `cell_type_palette.tsv`

```text
cell_type	color
T cell	#1F77B4
B cell	#FF7F0E
Myeloid	#2CA02C
Fibroblast	#D62728
Endothelial	#9467BD
Epithelial	#8C564B
Other	#BDBDBD
```

### `group_palette.tsv`

```text
group	color
Control	#4C78A8
Disease	#E45756
Treatment	#F58518
Responder	#54A24B
Non-responder	#B279A2
Unknown	#BDBDBD
```

### `domain_palette.tsv`

```text
domain	color
Domain_1	#4E79A7
Domain_2	#F28E2B
Domain_3	#59A14F
Domain_4	#E15759
Domain_5	#B07AA1
Unknown	#BDBDBD
```

### `score_scales.yml`

```yaml
module_score:
  cmap: viridis
  vmin: null
  vmax: null
  center: null
logFC:
  cmap: RdBu_r
  vmin: -2
  vmax: 2
  center: 0
pseudotime:
  cmap: magma
  vmin: 0
  vmax: 1
  center: null
```

## Starter R Script Skeleton

Use when the user asks for R scaffold:

```r
suppressPackageStartupMessages({
  library(tidyverse)
  library(ggplot2)
  library(patchwork)
})

dir.create("figures/exports/pdf", recursive = TRUE, showWarnings = FALSE)
dir.create("figures/exports/png", recursive = TRUE, showWarnings = FALSE)

cell_type_palette <- readr::read_tsv("figures/palettes/cell_type_palette.tsv")
group_palette <- readr::read_tsv("figures/palettes/group_palette.tsv")

save_panel <- function(plot, name, width = 6, height = 4) {
  ggsave(file.path("figures/exports/pdf", paste0(name, ".pdf")), plot, width = width, height = height)
  ggsave(file.path("figures/exports/png", paste0(name, ".png")), plot, width = width, height = height, dpi = 300)
}

# Replace with project source data.
metadata <- readr::read_tsv("figures/source_data/fig1_panel_table.tsv")
```

## Starter Python Script Skeleton

Use when the user asks for Python scaffold:

```python
from pathlib import Path
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

BASE = Path("figures")
(BASE / "exports" / "svg").mkdir(parents=True, exist_ok=True)
(BASE / "exports" / "png").mkdir(parents=True, exist_ok=True)

cell_type_palette = pd.read_csv(BASE / "palettes" / "cell_type_palette.tsv", sep="\t")
group_palette = pd.read_csv(BASE / "palettes" / "group_palette.tsv", sep="\t")

def save_panel(fig, name):
    fig.savefig(BASE / "exports" / "svg" / f"{name}.svg", bbox_inches="tight")
    fig.savefig(BASE / "exports" / "png" / f"{name}.png", dpi=300, bbox_inches="tight")

# Replace with project source data.
panel_table = pd.read_csv(BASE / "source_data" / "fig1_panel_table.tsv", sep="\t")
```

## Template-Specific Script Names

| Figure Template | R Script | Python Script |
|---|---|---|
| Atlas Overview Figure | `fig1_atlas_overview.R` | `fig1_atlas_overview.py` |
| Disease vs Control Cell-State Figure | `fig2_disease_cell_state.R` | `fig2_disease_cell_state.py` |
| Spatial Tissue Niche Figure | `fig_spatial_tissue_niche.R` | `fig_spatial_tissue_niche.py` |
| Cell-State Program Figure | `fig_cell_state_program.R` | `fig_cell_state_program.py` |
| Trajectory Figure | `fig_trajectory.R` | `fig_trajectory.py` |
| Cell-Cell Communication Figure | `fig_communication.R` | `fig_communication.py` |
| Benchmark + Biological Case Figure | `fig_benchmark_case.R` | `fig_benchmark_case.py` |

## Scaffold Creation Rules

- Do not fabricate user data. Create placeholder source-data files only when the user explicitly asks for a scaffold.
- Keep palette files separate from plotting scripts.
- Keep each panel redrawable from `source_data_manifest.tsv`.
- Use A1/A2 code assets as comments or learning references, not as unverified imports.
- Export vector first: PDF/SVG plus PNG preview.
- Add a QA checklist entry for every figure created.
- For code-learning scaffolds, create toy schemas and local learning notes only; do not clone large repositories or copy paper analysis code unless the user explicitly asks.
- Keep `figures/code_learning/recipes/*.md` as learning notes that cite repo paths, input schemas, output plots, and project-transfer steps.
- When using `ncfigR`, keep source-data TSVs as the stable interface and use Seurat only through adapter steps.

## Minimal Scaffold Response

When not writing files, return:

```text
Recommended scaffold:
- figures/palettes/...
- figures/source_data/...
- figures/scripts/...

Starter scripts:
- fig1_atlas_overview.R
- fig1_atlas_overview.py

Required source data:
- fig1b_umap_cells.tsv: cell_id, x, y, cell_type, group
- fig1c_cell_fraction.tsv: group, cell_type, n, proportion

QA checklist:
- one-sentence claim
- palette consistency
- source data complete
- vector export
```
