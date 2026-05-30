# Visual QA Scorecard

Purpose: audit a draft figure, panel table, exported image, or figure plan before polishing or code generation. This scorecard keeps the critique concrete: what is wrong, why it matters, and exactly how to fix it.

## QA Verdict

| Verdict | Meaning | Next Step |
|---|---|---|
| `pass` | Figure has a clear claim, stable visual grammar, and no major readability issues. | Export/source-data check only. |
| `revise` | Figure is usable but needs panel ordering, palette, legend, or density fixes. | Apply targeted edits. |
| `major redesign` | Figure lacks a coherent claim, uses wrong plot types, or overloads main figure. | Return to Figure Decision Mode. |

## Severity Levels

| Severity | Definition | Examples |
|---|---|---|
| critical | Could make the figure scientifically misleading or unreadable. | wrong plot type, unsupported claim, inconsistent labels, missing source data |
| major | Weakens main message or journal-level readability. | no anchor panel, too many legends, unstable colors, crowded heatmap |
| minor | Cosmetic or polish issue that does not change interpretation. | title length, panel label alignment, export preview issue |

## Scorecard

Score each area from 0-2.

| Area | 0 | 1 | 2 |
|---|---|---|---|
| claim focus | no clear claim | claim exists but panels drift | every panel supports one claim |
| panel hierarchy | equal-sized clutter | partial hierarchy | one anchor + support panels |
| plot choice | plot mismatches data | acceptable but not optimal | plot matches data structure |
| main/supplement boundary | QC/full lists crowd main | some excess | main contains only core evidence |
| palette consistency | colors conflict | mostly stable | fixed semantic palettes |
| legend economy | repeated/overlapping legends | some duplication | shared/clean legends |
| layout density | unreadable | tight but fixable | readable at final size |
| source-data readiness | cannot redraw | partial tables | each panel has source data |
| export readiness | only low-res raster | vector partial | PDF/SVG plus PNG preview |

Interpretation:

- 16-18: `pass`
- 11-15: `revise`
- 0-10: `major redesign`

## QA Output Format

Return:

```text
Verdict: revise
Score: 13/18

Critical:
- none

Major:
- Panel C repeats panel B without a new question. Move C to supplement or replace with quantification.
- Cell-type colors differ between UMAP and spatial map. Use one cell_type_palette.tsv.

Minor:
- Panel labels are not aligned.

Revised order:
A design -> B anchor UMAP -> C fraction -> D module heatmap -> E validation

Immediate fixes:
1. ...
2. ...
```

## Checks By Figure Type

### Atlas Overview

- Must have a clear global map.
- Marker panel should validate major cell types, not show every marker.
- Composition panel should use stable group order.
- QC violin belongs in supplement unless QC is the figure's main purpose.

### Disease / Control Cell-State

- Disease colors must not replace cell-type colors in cell-type panels.
- UMAP split must use identical coordinates.
- Quantification should be close to the map it explains.
- Program heatmap should use disease/control annotation tracks.

### Spatial Tissue Niche

- Spatial maps must preserve aspect ratio and tissue orientation.
- Zoom-in needs a marked region on the overview.
- Domain colors must stay fixed across slides.
- Niche composition should not be hidden inside a dense network.

### Communication

- LR heatmap should carry complete signal.
- Network should be filtered to top interpretable edges.
- Sender/receiver context must be clear before the network.
- Full LR table goes to supplement/source data.

### Trajectory

- Direction must be supported by stage/time/marker evidence.
- Pseudotime map and gene curves must use the same low-to-high direction.
- Avoid too many arrow layers.
- Root/branch assumptions should be stated or moved to methods/supplement.

### Benchmark

- Metric direction must be explicit.
- Raw metric matrix should precede rank/average.
- A biological case panel should explain why the benchmark matters.
- Runtime/ablation panels usually belong in supplement unless central.

## Palette QA

Critical palette errors:

- Same cell type has different colors across panels.
- Same color means disease in one panel and cell type in another.
- Continuous score uses categorical colors.
- Diverging effect scale is not centered at zero.

Required palette files for project work:

- `cell_type_palette.tsv`
- `group_palette.tsv`
- `domain_palette.tsv`
- `method_palette.tsv` when benchmarking
- `score_scales.yml`

## Layout QA

Required layout checks:

- One dominant anchor panel.
- Panel labels aligned and not inside data-dense regions.
- Legends do not cover data.
- Heatmap labels readable at final size.
- All maps in a comparison share aspect ratio.
- Similar panels use shared scales.

## Source-Data QA

For every panel, verify:

| Panel Type | Source Data Needed |
|---|---|
| UMAP | cell ID, x, y, cell type, group, score fields |
| spatial map | spot/cell ID, x, y, sample, domain/cell type, image link if used |
| heatmap | row ID, column ID, value, annotation table |
| dotplot | group, gene/feature, average expression, percent expressed |
| network | source, target, edge type, score, p/FDR |
| trajectory | cell ID, x, y, pseudotime, state, gene expression/trend |
| benchmark | method, dataset, metric, value, direction |

If source data is missing, do not mark the figure as `pass`.
