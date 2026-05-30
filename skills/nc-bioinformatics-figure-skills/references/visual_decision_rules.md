# Visual Decision Rules For NC-Style Bioinformatics Figures

Purpose: answer the five recurring questions before drawing: what goes into the main figure, which visualization to use, how to assemble panels, how to build advanced composite figures, and how to choose colors.

Use these rules before recommending papers or writing code.

## Rule 1: Decide What Belongs In The Main Figure

Main figure is for the claim, not for the analysis diary.

Keep in the main figure only if the panel does one of these jobs:

| Job | Question It Answers | Typical Panel |
|---|---|---|
| Define the object | What data/cells/tissue are we studying? | cohort table, workflow, UMAP, tissue map |
| Show the primary structure | Where is the main biological pattern? | UMAP, spatial domain map, trajectory map |
| Quantify the key contrast | Is the difference real and in which group/cell type? | fraction bar, violin, box, dotplot |
| Explain mechanism | Which program, pathway, interaction, or transition explains it? | heatmap, pathway dotplot, LR network, gene trend |
| Validate or generalize | Does this hold in another sample/dataset/case? | validation heatmap, case zoom, external cohort panel |

Move to supplement when the panel is:

- QC, filtering, doublet/mitochondrial/read-depth details.
- Full marker lists or all DE genes.
- All parameter settings, ablations, thresholds, and sensitivity analysis.
- Repeated UMAPs with no new question.
- Dense network edges that cannot be interpreted in 5 seconds.

Default main-figure budget:

- Figure 1: 5-7 panels, object + global structure + first result.
- Mechanism figures: 4-6 panels, one map + one quantification + one mechanism + one validation.
- Benchmark figures: 4-6 panels, metric matrix + rank + one biological case.

## Rule 2: Choose Visualization By Data Structure

Do not choose a plot because it looks impressive. Choose it because the input table has the right structure.

| Data Structure | Best First Plot | When To Avoid |
|---|---|---|
| cells x embedding coordinates | UMAP/tSNE scatter | if comparing exact distances or spatial location |
| cells/spots x tissue coordinates | spatial scatter or histology overlay | if the image orientation/scale is inconsistent |
| cell type x marker expression | dotplot or marker heatmap | if there are too many genes without grouped ordering |
| sample/cell type x module score | annotation heatmap or grouped violin | if module names are not interpretable |
| source-target-LR score table | LR heatmap + filtered network | if the network would need more than 20-40 edges |
| pseudotime + expression | trajectory map + gene trend curves | if root/stage direction is unsupported |
| method x dataset x metric | benchmark heatmap + rank plot | if metrics are not comparable across datasets |
| variant/locus x signal tracks | shared x-axis genome track | if tracks use different genome builds or coordinates |
| group x proportion | stacked bar or composition dot/bar | if total cell counts are too small or unbalanced |

Plot escalation rule:

1. Start with the simplest accurate plot.
2. Add a second linked panel only when it answers a different question.
3. Use a network, chord, Sankey, or 3D plot only when the relationship structure is central and can be filtered.

## Rule 3: Assemble Panels Into A Story

Default NC-style order:

1. Research object or design.
2. Global map or tissue context.
3. Main contrast.
4. Mechanism or program.
5. Validation or case study.

Single-cell order:

`cohort/design -> UMAP/cell types -> abundance/state shift -> marker/module heatmap -> validation`

Spatial order:

`tissue image -> spatial domains -> cell type/domain overlay -> niche/program quantification -> zoom/validation`

Communication order:

`sender/receiver map -> LR heatmap -> top network -> condition difference -> spatial proximity/case`

Trajectory order:

`state map -> pseudotime/vector direction -> stage composition -> gene trend -> branch validation`

Benchmark order:

`benchmark setup -> metric heatmap -> rank/robustness -> representative biological case`

Panel hierarchy:

- One anchor panel should be visually dominant.
- Quantification panels should sit next to the map they explain.
- Heatmaps need annotation tracks and biologically meaningful row/column order.
- Networks should be smaller than the heatmap unless the network is the actual discovery.
- Validation should appear after the claim, not before the reader knows what is being validated.

## Rule 4: Build Advanced Composite Figures

An advanced composite figure is not many fancy plots. It is multiple evidence layers aligned around one claim.

Reliable composite templates:

| Composite | Panel Formula | Use Case |
|---|---|---|
| Map + quantification + mechanism | UMAP/spatial map + score/fraction + heatmap/pathway | disease cell-state shifts |
| Spatial map + composition + niche marker | tissue/domain map + cell composition + marker heatmap + zoom | spatial tissue niche |
| Heatmap + network + case | LR heatmap + filtered network + spatial/UMAP case | communication |
| Trajectory + trend + stage | pseudotime map + gene curves + stage composition | differentiation/state transition |
| Benchmark + rank + example | metric heatmap + rank/lollipop + case embedding | method or model papers |
| Multi-sample grid + similarity | sample/domain grid + similarity heatmap + selected zoom | spatial cross-sample comparison |

Alignment rules:

- Shared entities should share colors: same cell type, domain, condition, or gene program.
- Shared axes should be visually aligned when possible: pseudotime, genomic locus, sample order, condition order.
- Reuse row/column order across heatmaps, bars, and dotplots.
- Do not combine two plots that encode the same result unless one is global and one is zoomed.

Filtering rules for complex panels:

- Network: show top edges only; keep full table/heatmap elsewhere.
- Heatmap: cap at interpretable rows; cluster only when the order itself is not the message.
- Dotplot: group genes by known cell type/program; avoid alphabetic order.
- Spatial map: show representative slides in main figure; move all-slide grid to supplement.

## Rule 5: Decide The Color Scheme

Color should encode meaning, not decoration.

Color mapping defaults:

| Variable Type | Palette Type | Rule |
|---|---|---|
| cell type | categorical | fixed palette across all figures; no disease semantics |
| disease/control or treatment | 2-4 semantic colors | control neutral gray/blue; disease or treatment warm/accent |
| continuous score | sequential | one colormap per score family; same limits when comparing panels |
| signed effect or logFC | diverging | center at zero; show scale limits |
| spatial domain | categorical | visually distinct but not over-saturated; preserve same domain color across samples |
| pseudotime | sequential gradient | low-to-high direction should match trajectory direction |
| benchmark metric | sequential or diverging by metric | higher-better and lower-better must be labeled clearly |

Consistency rules:

- Define palettes at the start of the project and save them as reusable maps.
- Use the same legend order as the biological order: control -> disease, early -> late, normal -> tumor, proximal -> distal.
- Avoid changing the same cell type color between main and supplement.
- Avoid using red/green as the only contrast.
- Use gray for background/unselected cells and one accent color for highlighted cells.
- Do not use a rainbow palette for continuous biological scores.

Minimum palette objects to maintain in a project:

```text
cell_type_palette.tsv: cell_type, color
group_palette.tsv: group, color
domain_palette.tsv: domain, color
score_scales.yml: score_name, cmap, vmin, vmax, center optional
```

## Rule 6: Decide R/Python Stack

Use the stack that matches the input object and the repository pattern you want to learn.

| Need | Prefer R | Prefer Python |
|---|---|---|
| Seurat object, manuscript assembly, ggplot/cowplot/patchwork | `Seurat`, `ggplot2`, `patchwork`, `cowplot`, `pheatmap` | only if object is exported |
| AnnData/scverse UMAP and spatial maps | possible via conversion | `scanpy`, `anndata`, `matplotlib`, `seaborn` |
| spatial alignment/projection | `待复核` | `CAST`, `scanpy`, `geopandas`, `matplotlib` |
| communication reports | `CellChat/NicheNet 待复核` | `FastCCC`, `networkx`, `seaborn` |
| trajectory/velocity | `monocle3 待复核` | MoFlow pattern, `matplotlib`, `seaborn`; `scVelo/dynamo 待复核` |
| final figure assembly | `patchwork`, `cowplot` | `matplotlib.gridspec`, external vector editor if needed |

Repository-learning rule: copy the input schema, panel order, and export style. Do not copy project-specific biology or private data assumptions.

## Rule 7: Self-Audit Before Export

Ask these questions before saving a figure:

1. Can the figure's main claim be stated in one sentence?
2. Does each panel answer a distinct part of that claim?
3. Is there one dominant visual anchor?
4. Are legends and colors reused consistently?
5. Are all map panels using the same coordinate orientation/aspect?
6. Are heatmap rows/columns ordered by biology or a stated clustering rule?
7. Is the network filtered enough to read?
8. Are QC and exhaustive lists moved to supplement?
9. Are source-data tables sufficient to redraw the plot?
10. Are output formats vector-first: PDF/SVG plus PNG preview?
