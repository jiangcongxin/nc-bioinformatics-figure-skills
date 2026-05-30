# spfigR API

Purpose: `spfigR` is the second domain package built from the NC GitHub code-learning pipeline. It implements a source-data-first spatial tissue niche figure MVP and uses `ncfigR` for shared theme, palette, composition, and export behavior.

## Package Location

```text
packages/spfigR/
```

## Implemented Functions

| Function | Input Table | Required Columns | Output |
|---|---|---|---|
| `plot_spatial_domain_panel()` | `spatial_coordinates.tsv` | `spot_id`, `x`, `y`, `domain` or chosen `domain_col` | ggplot spatial domain map |
| `plot_spatial_feature_panel()` | `spatial_features.tsv` | `spot_id`, `x`, `y`, `feature_value`; optional `feature` | ggplot continuous spatial feature map |
| `plot_spatial_composition_panel()` | `spatial_composition.tsv` | `sample`, `domain`, `n`, `proportion` | ggplot stacked/fill/dodge composition panel |
| `plot_spatial_zoom_panel()` | `spatial_coordinates.tsv` + `spatial_zoom_regions.tsv` | coordinates plus `region_id`, `xmin`, `xmax`, `ymin`, `ymax` | ggplot zoom-in spatial map |
| `compose_spatial_niche_figure()` | coordinates, features, composition, optional zoom tables | table-specific columns above | patchwork Spatial Tissue Niche Figure |

## Minimal R Example

```r
library(spfigR)
library(ncfigR)

coords <- readr::read_tsv("figures/source_data/spatial_coordinates.tsv")
features <- readr::read_tsv("figures/source_data/spatial_features.tsv")
composition <- readr::read_tsv("figures/source_data/spatial_composition.tsv")
regions <- readr::read_tsv("figures/source_data/spatial_zoom_regions.tsv")
palette <- read_nc_palette("figures/palettes/domain_palette.tsv")

fig <- compose_spatial_niche_figure(
  spatial_coordinates = coords,
  spatial_features = features,
  spatial_composition = composition,
  zoom_regions = regions,
  palette = palette,
  title = "Figure 2. Spatial tissue niche"
)

export_figure_bundle(fig, "fig2_spatial_niche", out_dir = "figures/exports", width = 7, height = 6)
```

## Source-Data Contract

### `spatial_coordinates.tsv`

```text
spot_id	x	y	domain	cell_type	sample	score
spot_001	0	0	Tumor_core	Epithelial	S1	0.72
```

### `spatial_features.tsv`

```text
spot_id	x	y	domain	sample	feature	feature_value
spot_001	0	0	Tumor_core	S1	Hypoxia	0.72
```

### `spatial_composition.tsv`

```text
sample	domain	n	proportion
S1	Tumor_core	4	0.50
```

### `spatial_zoom_regions.tsv`

```text
region_id	xmin	xmax	ymin	ymax	label
tumor_edge	1.5	3.2	-0.2	1.3	Tumor-immune edge
```

### `domain_palette.tsv`

```text
domain	color
Tumor_core	#4C78A8
Immune_edge	#E45756
```

## Design Rules

- Use source-data TSV as the stable interface.
- Keep SpatialData, Seurat, Squidpy, or image-processing objects upstream; export coordinates/features for plotting.
- Keep domain palettes separate and stable across panels.
- Use spatial coordinate maps as anchor panels.
- Use zoom panels for one or two interpretable regions, not for all samples.
- Use `ncfigR::export_figure_bundle()` for PDF/SVG/PNG export.

## Current Boundaries

- `spfigR` v0.1.0 is a Spatial Tissue Niche MVP.
- Histology raster overlay and segmentation mask overlay are not implemented yet; keep `image_manifest.tsv` as a future contract.
- Cell-cell communication overlay remains a future bridge to `commfigR`.
