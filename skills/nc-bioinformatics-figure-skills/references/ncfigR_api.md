# ncfigR API

Purpose: document the local R package used to turn high-quality NC/Nature GitHub figure-code patterns into reusable plotting functions.

Package path inside the plugin:

```text
packages/ncfigR/
```

## Data Interfaces

Source-data tables are the stable interface.

| Table | Required Columns | Main Use |
|---|---|---|
| `embedding.tsv` | `cell_id`, `x`, `y`, `cell_type` or another color column | UMAP/spatial/state maps |
| `cell_metadata.tsv` | `cell_id`, group/cell type/sample columns | counts, composition, grouping |
| `marker_matrix.tsv` | `feature`, `cell_type`, `value` | marker/module heatmap |
| `composition.tsv` | `group`, `cell_type`, `n`, `proportion` | abundance/composition panels |
| `lr_pairs.tsv` | `source`, `target`, `ligand`, `receptor`, `score`, `p_adj` | LR heatmap/network |
| `trajectory.tsv` | `cell_id`, `pseudotime`, `feature`, `value`, optional `state` | gene trends |
| `benchmark_metrics.tsv` | `method`, `dataset`, `metric`, `value` | benchmark heatmap |

Optional Seurat interface:

```r
embedding <- as_panel_data(seurat_object, type = "embedding", reduction = "umap")
metadata <- as_panel_data(seurat_object, type = "metadata")
expr <- as_panel_data(seurat_object, type = "expression", features = c("CD3D", "LYZ"))
```

## Core Functions

| Function | Role |
|---|---|
| `nc_theme()` | common publication-style ggplot theme |
| `read_nc_palette()` | read palette TSV into named vector |
| `validate_palette()` | check all plotted categories have colors |
| `as_panel_data()` | adapt data.frame or Seurat object to panel data |
| `plot_embedding_panel()` | UMAP/spatial/embedding scatter |
| `plot_composition_panel()` | stacked/fill/dodged abundance bar |
| `plot_marker_heatmap()` | marker/module heatmap using ggplot tiles |
| `plot_lr_heatmap()` | sender-receiver LR heatmap |
| `plot_lr_network()` | filtered communication network |
| `plot_trajectory_trend()` | gene trends over pseudotime |
| `plot_benchmark_heatmap()` | method x dataset metric heatmap |
| `compose_nc_figure()` | patchwork assembly with panel labels |
| `export_figure_bundle()` | PDF/SVG/PNG export plus optional source manifest |

## Minimal Example

```r
library(ncfigR)

embedding <- readr::read_tsv(system.file("extdata/embedding.tsv", package = "ncfigR"))
composition <- readr::read_tsv(system.file("extdata/composition.tsv", package = "ncfigR"))
markers <- readr::read_tsv(system.file("extdata/marker_matrix.tsv", package = "ncfigR"))
palette <- read_nc_palette(system.file("extdata/cell_type_palette.tsv", package = "ncfigR"))

p1 <- plot_embedding_panel(embedding, palette = palette, label = TRUE)
p2 <- plot_composition_panel(composition, palette = palette)
p3 <- plot_marker_heatmap(markers)

fig <- compose_nc_figure(list(p1, p2, p3), ncol = 3, title = "Atlas overview")
export_figure_bundle(fig, "fig1_atlas_overview", out_dir = "figures/exports")
```

## Design Boundary

- `ncfigR` is for local training and project reuse, not CRAN release.
- The package learns code structure from A1/A2 repositories, but does not copy paper code.
- Source-data tables must work without Seurat.
- Seurat support is an adapter layer only.
