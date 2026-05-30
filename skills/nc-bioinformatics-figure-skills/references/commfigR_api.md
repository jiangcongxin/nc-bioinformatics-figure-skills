# commfigR API

Purpose: `commfigR` is the third domain package built from the NC GitHub code-learning pipeline. It implements a source-data-first cell-cell communication figure MVP and uses `ncfigR` for shared theme, LR heatmap, network, composition, and export behavior.

## Package Location

```text
packages/commfigR/
```

## Implemented Functions

| Function | Input Table | Required Columns | Output |
|---|---|---|---|
| `plot_lr_heatmap_panel()` | `lr_pairs.tsv` | `source`, `target`, `ligand`, `receptor`, `score`, `p_value`; optional `condition` | ggplot sender-receiver LR heatmap |
| `plot_lr_network_panel()` | `network_edges.tsv` or filtered `lr_pairs.tsv` | `source`, `target`, `weight` or chosen value column | ggraph filtered network |
| `plot_sender_receiver_score_panel()` | `communication_scores.tsv` | `source`, `target`, `score`, `score_type`; optional `condition` | ggplot sender/receiver dot score panel |
| `plot_differential_communication_panel()` | `differential_lr.tsv` | `source`, `target`, `ligand`, `receptor`, `logFC`, `p_adj` | ggplot differential LR lollipop |
| `compose_communication_figure()` | LR, score, optional differential/network tables | table-specific columns above | patchwork Cell-Cell Communication Figure |

## Minimal R Example

```r
library(commfigR)
library(ncfigR)

lr <- readr::read_tsv("figures/source_data/lr_pairs.tsv")
scores <- readr::read_tsv("figures/source_data/communication_scores.tsv")
diff <- readr::read_tsv("figures/source_data/differential_lr.tsv")
edges <- readr::read_tsv("figures/source_data/network_edges.tsv")

fig <- compose_communication_figure(
  lr_pairs = lr,
  communication_scores = scores,
  differential_lr = diff,
  network_edges = edges,
  title = "Figure 4. Cell-cell communication"
)

export_figure_bundle(fig, "fig4_communication", out_dir = "figures/exports", width = 7, height = 6)
```

## Source-Data Contract

### `lr_pairs.tsv`

```text
source	target	ligand	receptor	score	p_value	condition
T cell	Myeloid	IFNG	IFNGR1	0.82	0.001	Disease
```

### `communication_scores.tsv`

```text
source	target	score	condition	score_type
T cell	Myeloid	0.82	Disease	sender
```

### `differential_lr.tsv`

```text
source	target	ligand	receptor	logFC	p_value	p_adj	condition_a	condition_b
T cell	Myeloid	IFNG	IFNGR1	1.10	0.0008	0.006	Disease	Control
```

### `network_edges.tsv`

```text
source	target	weight	edge_type
T cell	Myeloid	0.82	activation
```

## Design Rules

- LR heatmap carries global communication evidence.
- Network panels must be filtered; do not draw every LR pair as an edge.
- Differential communication should be a ranked/lollipop panel, not another full heatmap.
- Store filtering thresholds and selected top edges in source-data or manifest, not hidden inside the plot function.
- For spatial projects, pair communication evidence with a spatial proximity or niche validation panel from `spfigR`.
- Use `ncfigR::export_figure_bundle()` for PDF/SVG/PNG export.

## Current Boundaries

- `commfigR` v0.1.0 is a Cell-Cell Communication MVP.
- It does not run CellPhoneDB, NicheNet, CellChat, or FastCCC analyses; it plots exported source-data results.
- Chord diagrams and spatial proximity overlays are future package targets.
