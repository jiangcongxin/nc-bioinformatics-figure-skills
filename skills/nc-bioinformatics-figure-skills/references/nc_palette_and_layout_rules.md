# NC Palette And Layout Rules

Purpose: provide reusable publication-style checks for single-cell and spatial omics figures. These are practical rules for clean NC-style visual hierarchy, not a claim that every Nature Communications paper uses the same design system.

## Palette Strategy

### 1. Keep Separate Palettes For Different Meanings

Never reuse the same color meaning for different variables in the same manuscript.

| Meaning | Palette File | Example Use |
|---|---|---|
| cell type | `cell_type_palette.tsv` | UMAP, spatial cell overlay, marker dotplot annotation |
| sample/group/condition | `group_palette.tsv` | split UMAP, abundance bar, violin |
| spatial domain/niche | `domain_palette.tsv` | domain map, niche composition, marker heatmap annotation |
| continuous score | `score_scales.yml` | module score, pseudotime, pathway score |
| benchmark method | `method_palette.tsv` | method bars, rank plots, case comparisons |

### 2. Recommended Defaults

| Variable | Default |
|---|---|
| Control/background | neutral gray, muted blue, or black outlines |
| Disease/activated/treatment | one warm accent such as red/orange/magenta, used sparingly |
| Highlighted cell population | one accent color over gray background |
| Pseudotime | monotonic sequential gradient, low to high |
| Signed effect/logFC | diverging palette centered at 0 |
| Module score | sequential palette with shared limits across comparable panels |
| Missing/other/unknown | light gray |

### 3. Palette Failure Modes

- Same cell type has different colors in different panels.
- Disease color is also used as a cell type color.
- Continuous variables use categorical palettes.
- Heatmap limits differ across panels without explanation.
- Too many saturated colors compete with the main message.
- Red/green is the only contrast.
- Legends are repeated in every panel instead of shared.

## Layout Strategy

### 1. Figure-Level Hierarchy

Use three panel sizes:

| Size | Role | Typical Panels |
|---|---|---|
| Large | visual anchor | global UMAP, spatial map, benchmark heatmap, trajectory map |
| Medium | evidence support | marker heatmap, LR heatmap, composition bar, gene trend |
| Small | context/QC/stat | workflow, cohort table, sample count, compact statistic |

Rule: if all panels are the same size, the reader cannot know what matters.

### 2. Standard Layout Patterns

| Pattern | Grid | Use |
|---|---|---|
| atlas overview | 2 rows x 3 columns | dataset/QC + UMAP + marker + composition |
| spatial niche | large map top/left + small quant panels right/bottom | tissue/domain-focused figure |
| condition response | conditions as columns, evidence types as rows | pre/post, dose, treatment |
| trajectory | map left/top + curves aligned below/right | pseudotime and gene dynamics |
| communication | heatmap large + network small + spatial/UMAP case | ligand-receptor result |
| benchmark | metric heatmap large + rank/stat + case panel | method evaluation |

### 3. Panel Ordering

Default reading order:

`A object/design -> B global map -> C main contrast -> D quantification -> E mechanism -> F validation`

For spatial figures:

`A tissue overview -> B domain map -> C cell-type overlay -> D composition/score -> E mechanism -> F zoom`

For trajectory:

`A state map -> B direction/pseudotime -> C stage composition -> D gene trends -> E branch validation`

For communication:

`A sender/receiver context -> B LR heatmap -> C top network -> D differential panel -> E spatial validation`

## Panel Design Rules

### UMAP / Embedding

- Use identical coordinates for all compared UMAP panels.
- Keep point size and alpha stable across panels.
- Use frame-free style unless axes are scientifically interpreted.
- Direct labels are useful for large clusters; avoid labels that overlap.
- Put one shared legend, not one legend per UMAP.

### Spatial Map

- Preserve aspect ratio and coordinate orientation.
- Use the same spot/cell size for comparable maps.
- Show scale/region context when available.
- If using zoom-in, mark the zoom region on the overview.
- Do not crop out tissue boundaries if tissue architecture is the message.

### Heatmap / Dotplot

- Use annotation tracks for disease/group/sample/platform/domain.
- Order rows and columns by biology first; cluster only when pattern discovery is the goal.
- Keep gene/module names readable. If not possible, split panels or move full heatmap to supplement.
- For dotplots, size and color must be explained in legend/caption.

### Network

- Filter to interpretable top edges.
- Use node color for cell type/domain and edge width/color for interaction strength/direction.
- Keep complete interaction evidence in a heatmap/table.
- Avoid crossing-heavy layouts when an adjacency heatmap would be clearer.

### Trajectory

- Direction must be supported by stage/time/marker evidence.
- Put pseudotime gradient and gene trends in the same low-to-high direction.
- Avoid overplotting too many arrows.
- Include state labels and one quantitative stage/branch panel.

### Benchmark

- Label whether higher is better or lower is better.
- Use consistent metric scales.
- Add rank or summary only after showing raw metric matrix.
- Include a biological case example if the benchmark is in a main figure.

## Typography And Export

Recommended defaults:

| Element | Rule |
|---|---|
| panel labels | bold A, B, C; same position and size |
| titles | short noun phrase, not a sentence |
| axis labels | include units or metric names |
| legend text | readable after reduction |
| figure width | design for final journal column/page size early |
| export | PDF/SVG for vector, PNG/TIFF preview for inspection |
| source data | save the exact table used by each panel |

Avoid:

- Long explanatory titles inside panels.
- Unaligned panel labels.
- Legends that cover data.
- Mixed font families.
- Rasterized text in final vector exports.
- Exporting only a low-resolution PNG.

## NC-Style Preflight Checklist

Use this checklist before showing a figure to the user:

| Check | Pass Condition |
|---|---|
| one-claim rule | the figure can be summarized in one sentence |
| panel role | every panel has a role: context, map, contrast, mechanism, validation, or QC |
| main vs supplement | QC/full lists/parameters are not crowding the main figure |
| plot choice | each plot matches the input data structure |
| color stability | cell types, groups, domains, and continuous scales are consistent |
| layout hierarchy | one panel is visually dominant and support panels are grouped around it |
| legend economy | duplicated legends are removed or consolidated |
| spatial geometry | spatial maps preserve orientation and aspect |
| heatmap readability | annotations, row/column order, and scale are explicit |
| source data | each panel can be redrawn from a saved table/object |

## Personal Template Files To Generate In Projects

When converting this skill into a project plotting system, create:

```text
figures/
  palettes/
    cell_type_palette.tsv
    group_palette.tsv
    domain_palette.tsv
    score_scales.yml
  source_data/
    fig1_panel_c_umap_metadata.tsv
    fig1_panel_e_marker_dotplot.tsv
  scripts/
    fig1_atlas_overview.R or fig1_atlas_overview.py
    fig2_cell_state_program.R or fig2_cell_state_program.py
  exports/
    fig1_atlas_overview.pdf
    fig1_atlas_overview.svg
    fig1_atlas_overview.png
```

Project rule: never hard-code palette values inside one plotting script only. Keep palettes as reusable input files.
