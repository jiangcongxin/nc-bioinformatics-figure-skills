# commfigR API

`commfigR` 0.2.0 draws existing communication results. The supported Agent task
is `communication_overview`; read [communication_execution.md](communication_execution.md).
Other companion packages remain prototypes, not equivalent task engines.

## Checked Overview Interfaces

- `as_cellchat_table(data, condition)`: exported prob/pval to score/p_value,
  preserving complexes, labels and upstream metadata.
- `prepare_communication_data(data, p_max=NULL, top_n=12, cell_type_order=NULL,
  max_pairs=16)`: validate inputs; separate-condition score sums and display selection.
- `compose_communication_overview(data, ..., data.out=TRUE, network_top_n=20)`:
  plot plus exact panel values. Networks show top edges per condition.
- `run_comm_job(spec_path, output_dir=NULL)`: unique attempt, source snapshots,
  artwork, checks, methods and frozen reproduction configuration.
- `review_comm_job(run_dir, review_path)`: artifact-bound six-check visual review.

Overview input: source,target,ligand,receptor,score; optional condition,p_value.
Unique keys per condition/source/target/ligand/receptor; finite non-negative
scores; upstream p-values in [0,1]. No inferred significance or missing zeros.
LR/cell-pair display ranks pool sums across conditions; heatmaps and totals
remain separate and use all retained rows. Exact selections are exported.

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

- `commfigR` v0.2.0 supports the overview task. Differential panels are direct
  APIs requiring confirmed upstream statistics, not a supported task engine.
- LR heatmaps preserve LR identities and condition facets. Network panels
  require one condition and sum supplied rows per sender/receiver; the legacy
  composition requires explicit network edges for multi-condition LR inputs.
- Direct APIs do not enforce the CLI runtime lock or automatically review figures.
- It does not run CellPhoneDB, NicheNet, CellChat, or FastCCC analyses; it plots exported source-data results.
- Chord diagrams and spatial proximity overlays are future package targets.
