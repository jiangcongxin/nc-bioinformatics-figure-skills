# scfigR Code Patterns

Purpose: record how A1/A2 GitHub code-learning patterns were rewritten into `scfigR` without copying upstream source code.

## Pattern Sources

| Source Repo | Evidence | Learned Pattern | scfigR Rewrite |
|---|---|---|---|
| scPRINT | `figures/nice_umap.ipynb`; `figures/niceumap.py` | embedding helper separated from model-specific result panels | `plot_sc_embedding_panel()` using explicit `embedding.tsv` and palette |
| Panpipes | `panpipes/python_scripts/plot_cluster_umaps.py`; `plot_scanpy_markers.py`; `panpipes/R_scripts/plot_metrics.R` | pipeline-style plotting with explicit input files and QC/marker separation | `plot_cell_fraction_panel()` and source-data-first marker dotplot schema |
| CellMentor_paper | `Figures.Rmd` | RMarkdown manuscript assembly with embedding, marker, and metric panels | `compose_sc_atlas_figure()` returns patchwork and leaves export to `ncfigR` |
| scFoundation | `annotation/celltype-plot.ipynb`; task plot notebooks | task/annotation outputs shown as compact panels beside atlas evidence | `plot_module_score_panel()` for score maps or grouped score distributions |

## Implementation Choices

| Choice | Reason |
|---|---|
| TSV-first inputs | Stable across Seurat, AnnData, Scanpy, and public-data workflows. |
| `ncfigR` dependency | Reuse shared theme, palette, composition, and export behavior. |
| ggplot return values | Panels remain composable through patchwork/cowplot. |
| Dotplot over dense heatmap for markers | Better first-main-figure readability when marker count is small. |
| Module score embedding + violin modes | Supports both spatial/UMAP localization and group-level quantification. |

## Atlas Overview Panel Grammar

| Panel | Function | Role | Main-Figure Rule |
|---|---|---|---|
| A | `plot_sc_embedding_panel()` | anchor visual map | color by stable cell type or condition; avoid too many facets |
| B | `plot_cell_fraction_panel()` | quantitative sample/group structure | show only major groups in main figure; put per-sample detail in supplement |
| C | `plot_marker_dotplot_panel()` | annotation evidence | keep marker set short and interpretable |
| D | `plot_module_score_panel()` | key biological program | use one score tied to the figure claim |

## QA Checklist

- Every panel can be redrawn from source-data TSV.
- Cell-type colors match `cell_type_palette.tsv`.
- Marker dotplot uses consistent feature order and cell-type order.
- Composition proportions sum close to 1 per group when `position = "fill"`.
- Module score legend is continuous and not reused for categorical groups.
- Export is done through `ncfigR::export_figure_bundle()`.
