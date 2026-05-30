# spfigR Code Patterns

Purpose: record how A1/A2 GitHub code-learning patterns were rewritten into `spfigR` without copying upstream source code.

## Pattern Sources

| Source Repo | Evidence | Learned Pattern | spfigR Rewrite |
|---|---|---|---|
| scHolography | `R/Visualization.R`; `R/neighborPlots.R`; `analysis source code/*/Fig*.Rmd` | spatial coordinates as anchor panel plus neighborhood/niche quantification | `plot_spatial_domain_panel()` and `plot_spatial_composition_panel()` |
| Sopa | `docs/tutorials/spatial.ipynb`; `he.ipynb`; `compare_segmentations.ipynb` | spatial/image objects are useful upstream, but figure panels need stable coordinates and image manifests | `spatial_coordinates.tsv` plus future `image_manifest.tsv` contract |
| FineST | `FineST/plottings.py`; `docs/source/*LRI_CCC_count.ipynb` | histology or high-resolution feature map should be paired with quantitative validation | `plot_spatial_feature_panel()` and future image overlay |
| Tumor-cell-villages | `1.Celltype_annotation.r`; `4.Identify_tumor_cell_villages.r`; `5.spatial_gene_codependency_of_tumor_and_TME.r` | niche/village labels are most readable as map + composition + zoom | `compose_spatial_niche_figure()` and `plot_spatial_zoom_panel()` |

## Implementation Choices

| Choice | Reason |
|---|---|
| TSV-first coordinates | Stable across Visium, Xenium, CosMx, Stereo-seq, SpatialData, and Seurat outputs. |
| `ncfigR` dependency | Reuse shared theme, palette, composition, and export behavior. |
| domain map as anchor | Spatial figures need tissue location first, quantification second. |
| continuous feature map | Handles marker expression, module score, pathway score, imputation score, or niche score. |
| zoom region table | Makes zoom-in panels reproducible and auditable. |

## Spatial Tissue Niche Panel Grammar

| Panel | Function | Role | Main-Figure Rule |
|---|---|---|---|
| A | `plot_spatial_domain_panel()` | anchor tissue/domain map | show domain identity with stable discrete palette |
| B | `plot_spatial_feature_panel()` | biological program or marker evidence | use one claim-relevant feature in main figure |
| C | `plot_spatial_composition_panel()` | quantitative sample/domain structure | aggregate to sample or condition level |
| D | `plot_spatial_zoom_panel()` | case zoom-in | show one or two interpretable regions, not all cases |

## QA Checklist

- Spatial coordinates are in the same coordinate system across panels.
- Domain colors match `domain_palette.tsv`.
- Continuous feature legends use one sequential scale.
- Zoom regions are explicitly stored in `spatial_zoom_regions.tsv`.
- Composition proportions sum close to 1 per sample when `position = "fill"`.
- Export is done through `ncfigR::export_figure_bundle()`.
