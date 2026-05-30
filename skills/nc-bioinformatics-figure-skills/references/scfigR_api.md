# scfigR API

Purpose: `scfigR` is the first domain package built from the NC GitHub code-learning pipeline. It implements a source-data-first single-cell Atlas Overview Figure MVP and uses `ncfigR` for shared theme, composition, palette, and export behavior.

## Package Location

```text
packages/scfigR/
```

## Implemented Functions

| Function | Input Table | Required Columns | Output |
|---|---|---|---|
| `plot_sc_embedding_panel()` | `embedding.tsv` | `cell_id`, `x`, `y`, `cell_type` or chosen `color_col` | ggplot embedding panel |
| `plot_cell_fraction_panel()` | `composition.tsv` | `group`, `cell_type`, `n`, `proportion` | ggplot stacked/fill/dodge composition panel |
| `plot_marker_dotplot_panel()` | `marker_dotplot.tsv` | `feature`, `cell_type`, `avg_expression`, `pct_expression` | ggplot marker dotplot |
| `plot_module_score_panel()` | `module_scores.tsv` | embedding mode: `x`, `y`, `score`; violin mode: `group`, `score` | ggplot score map or violin panel |
| `compose_sc_atlas_figure()` | embedding, composition, marker, optional score tables | table-specific columns above | patchwork Atlas Overview Figure |

## Minimal R Example

```r
library(scfigR)
library(ncfigR)

embedding <- readr::read_tsv("figures/source_data/embedding.tsv")
composition <- readr::read_tsv("figures/source_data/composition.tsv")
markers <- readr::read_tsv("figures/source_data/marker_dotplot.tsv")
scores <- readr::read_tsv("figures/source_data/module_scores.tsv")
palette <- read_nc_palette("figures/palettes/cell_type_palette.tsv")

fig <- compose_sc_atlas_figure(
  embedding = embedding,
  composition = composition,
  markers = markers,
  module_scores = scores,
  palette = palette,
  title = "Figure 1. Single-cell atlas overview"
)

export_figure_bundle(fig, "fig1_sc_atlas", out_dir = "figures/exports", width = 7, height = 6)
```

## Source-Data Contract

### `embedding.tsv`

```text
cell_id	x	y	cell_type	group	score
cell_001	-2.2	1.1	T cell	Control	0.20
```

### `composition.tsv`

```text
group	cell_type	n	proportion
Control	T cell	38	0.38
```

### `marker_dotplot.tsv`

```text
feature	cell_type	avg_expression	pct_expression
CD3D	T cell	1.8	0.86
```

### `module_scores.tsv`

```text
cell_id	x	y	cell_type	group	score	module
cell_001	-2.2	1.1	T cell	Control	0.20	Inflammation
```

## Design Rules

- Use source-data TSV as the stable interface.
- Use Seurat/AnnData only upstream to export source-data tables.
- Keep palette files outside plotting functions.
- Keep panel functions returning ggplot objects.
- Use `ncfigR::export_figure_bundle()` for PDF/SVG/PNG export.
- Treat biological labels and claims as user-project data, not package defaults.

## Current Boundaries

- `scfigR` v0.1.0 is an Atlas Overview MVP.
- It does not yet implement full Seurat adapters; use `ncfigR::as_panel_data()` or project scripts to export TSVs.
- Annotation transfer, confusion matrix, and advanced benchmark panels remain package targets for later versions.
