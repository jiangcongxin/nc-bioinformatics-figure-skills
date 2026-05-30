# R Package Router

Purpose: decide which local R plotting package should implement a user figure request, and provide an executable fallback through `ncfigR` when domain packages are still planned.

## Package Roles

| Package | Responsibility | Status |
|---|---|---|
| `ncfigR` | shared theme, palette validation, source-data adapters, basic panels, composition, export bundle, QA manifest | implemented base / fallback |
| `scfigR` | single-cell atlas figures: embedding, marker dotplot, composition, module score, annotation validation | implemented MVP for Atlas Overview |
| `spfigR` | spatial figures: tissue maps, domain maps, spatial feature maps, zoom-in panels, and niche composition | implemented MVP for Spatial Tissue Niche |
| `commfigR` | communication figures: LR heatmap, sender/receiver score, filtered network, differential communication | implemented MVP for Cell-Cell Communication |
| `trajfigR` | trajectory figures: pseudotime map, velocity arrows, branch probability, gene trends, state transition | implemented MVP for Trajectory |
| `benchfigR` | benchmark figures: metric heatmap, rank plot, runtime/memory, robustness, biological case panel | implemented MVP for Benchmark + Biological Case |
| `multiomfigR` | multi-omics figures: modality integration, cross-dataset validation, regulatory/feature links, pathway programs | implemented MVP for Multi-omics Integration |

## Routing Table

| User Intent / Figure Template | Data Type | Primary Package | Target Function | Input Table | ncfigR Fallback |
|---|---|---|---|---|---|
| Atlas Overview Figure: UMAP / embedding | scRNA | `scfigR` | `plot_sc_embedding_panel()` | `embedding.tsv` with `cell_id,x,y,cell_type,group,score` | `plot_embedding_panel()` |
| Atlas Overview Figure: cell composition | scRNA | `scfigR` | `plot_cell_fraction_panel()` | `composition.tsv` with `group,cell_type,n,proportion` | `plot_composition_panel()` |
| Atlas Overview Figure: marker dotplot | scRNA | `scfigR` | `plot_marker_dotplot_panel()` | `marker_dotplot.tsv` with `feature,cell_type,avg_expression,pct_expression` | `plot_marker_heatmap()` if dotplot inputs are not available |
| Atlas Overview Figure: module score | scRNA | `scfigR` | `plot_module_score_panel()` | `module_scores.tsv` with `cell_id,x,y,group,score,module` | `plot_embedding_panel()` with continuous score |
| Spatial Tissue Niche Figure: spatial domain map | spatial | `spfigR` | `plot_spatial_domain_panel()` | `spatial_coordinates.tsv` with `spot_id,x,y,domain,cell_type,score` | `plot_embedding_panel()` with spatial coordinates |
| Spatial Tissue Niche Figure: spatial feature map | spatial | `spfigR` | `plot_spatial_feature_panel()` | `spatial_features.tsv` with `spot_id,x,y,feature,feature_value` | `plot_embedding_panel()` with continuous score |
| Spatial Tissue Niche Figure: domain composition | spatial | `spfigR` | `plot_spatial_composition_panel()` | `spatial_composition.tsv` with `sample,domain,n,proportion` | `plot_composition_panel()` |
| Spatial Tissue Niche Figure: zoom-in region | spatial | `spfigR` | `plot_spatial_zoom_panel()` | `spatial_coordinates.tsv` plus `spatial_zoom_regions.tsv` | coordinate filtering + `plot_embedding_panel()` |
| Spatial Tissue Niche Figure: histology/segmentation overlay | spatial image | `spfigR` | `plot_histology_overlay_panel()` | `spatial_coordinates.tsv` plus `image_manifest.tsv` | stub needed; use external image panel + `compose_nc_figure()` |
| Cell-Cell Communication Figure: LR heatmap | communication | `commfigR` | `plot_lr_heatmap_panel()` | `lr_pairs.tsv` with `source,target,ligand,receptor,score,p_value,condition` | `plot_lr_heatmap()` |
| Cell-Cell Communication Figure: filtered network | communication | `commfigR` | `plot_lr_network_panel()` | `network_edges.tsv` with `source,target,weight,edge_type` | `plot_lr_network()` |
| Cell-Cell Communication Figure: sender/receiver score | communication | `commfigR` | `plot_sender_receiver_score_panel()` | `communication_scores.tsv` with `source,target,score,condition,score_type` | dotplot with `nc_theme()` |
| Cell-Cell Communication Figure: differential LR | communication | `commfigR` | `plot_differential_communication_panel()` | `differential_lr.tsv` with `source,target,ligand,receptor,logFC,p_value,p_adj` | lollipop/ranked dot |
| Trajectory Figure: pseudotime map | trajectory | `trajfigR` | `plot_pseudotime_embedding_panel()` | `trajectory_cells.tsv` with `cell_id,x,y,pseudotime,state,branch,stage` | `plot_embedding_panel()` with continuous palette |
| Trajectory Figure: velocity / direction map | trajectory | `trajfigR` | `plot_velocity_embedding_panel()` | `velocity_vectors.tsv` with `cell_id,x,y,dx,dy,state,pseudotime` | arrow layer on embedding |
| Trajectory Figure: branch probability | trajectory | `trajfigR` | `plot_branch_probability_panel()` | `branch_probabilities.tsv` with `cell_id,pseudotime,branch,probability,stage` | ggplot trend panel |
| Trajectory Figure: gene trend | trajectory | `trajfigR` | `plot_gene_trend_panel()` | `gene_trends.tsv` with `cell_id,pseudotime,feature,value,branch` | `plot_trajectory_trend()` |
| Trajectory Figure: state transition | trajectory | `trajfigR` | `plot_state_transition_panel()` | `state_transitions.tsv` with `from_state,to_state,weight,transition_type` | `plot_lr_network()` as directed transition graph |
| Benchmark + Biological Case Figure: metric heatmap | benchmark | `benchfigR` | `plot_metric_heatmap_panel()` | `benchmark_metrics.tsv` with `method,dataset,metric,value` | `plot_benchmark_heatmap()` |
| Benchmark + Biological Case Figure: rank summary | benchmark | `benchfigR` | `plot_rank_panel()` | `benchmark_ranks.tsv` with `method,metric,rank,value` | dotplot with `nc_theme()` |
| Benchmark + Biological Case Figure: runtime / memory | benchmark | `benchfigR` | `plot_runtime_panel()` | `runtime_metrics.tsv` with `method,dataset,runtime_sec,memory_gb` | ggplot bar/scatter with `nc_theme()` |
| Benchmark + Biological Case Figure: robustness | benchmark | `benchfigR` | `plot_robustness_panel()` | `robustness_metrics.tsv` with `method,perturbation,metric,value` | ggplot trend panel |
| Benchmark + Biological Case Figure: representative case | benchmark / case | `benchfigR` | `plot_case_embedding_panel()` | `case_embedding.tsv` with `cell_id,x,y,label,score,method` | `plot_embedding_panel()` |
| Multi-omics Integration Figure: integrated embedding | multi-omics | `multiomfigR` | `plot_integration_embedding_panel()` | `integration_embedding.tsv` with `cell_id,x,y,cell_type,modality,dataset,integration_score` | `plot_embedding_panel()` |
| Multi-omics Integration Figure: modality metric | multi-omics | `multiomfigR` | `plot_modality_metric_panel()` | `modality_metrics.tsv` with `modality,dataset,metric,value` | `plot_benchmark_heatmap()` |
| Multi-omics Integration Figure: cross-dataset validation | multi-omics | `multiomfigR` | `plot_cross_dataset_validation_panel()` | `cross_dataset_validation.tsv` with `source_dataset,target_dataset,metric,value` | heatmap with `nc_theme()` |
| Multi-omics Integration Figure: feature / regulatory links | multi-omics | `multiomfigR` | `plot_feature_link_panel()` | `feature_links.tsv` with `source_feature,target_feature,weight,link_type` | `plot_lr_network()` as feature graph |
| Multi-omics Integration Figure: pathway / program panel | multi-omics | `multiomfigR` | `plot_pathway_program_panel()` | `pathway_programs.tsv` with `program,group,score` | `plot_marker_heatmap()` |

## Router Response Format

When the user asks which package to use, answer with:

```text
Recommended package:
Function(s):
Input TSV schema:
Current status:
ncfigR fallback:
Reference GitHub patterns:
QA checks:
Next replication step:
```

## Implementation Status Rules

- `implemented in ncfigR`: usable now with the local base package.
- `implemented in scfigR`: usable now for single-cell Atlas Overview source-data tables.
- `implemented in spfigR`: usable now for spatial tissue niche source-data tables.
- `implemented in commfigR`: usable now for cell-cell communication source-data tables.
- `implemented in trajfigR`: usable now for trajectory source-data tables.
- `implemented in benchfigR`: usable now for benchmark plus representative case source-data tables.
- `implemented in multiomfigR`: usable now for multi-omics integration source-data tables.
- `stub needed`: domain package function is not implemented yet, but the source-data contract and pattern are clear.
- `package planned`: broader package exists as a roadmap item; route the design but do not claim executable code.

## Project Transfer Rules

- Ask the user's project to export source-data TSVs first.
- Use Seurat, AnnData, h5ad, or SpatialData only as adapters, not as the long-term figure interface.
- Keep palette files separate from plotting functions.
- Record each panel in `figures/code_learning/package_router.tsv`.
- Export through the shared `ncfigR` bundle until the domain package has its own wrapper.

## High-Value Reference Patterns

| Package Target | A1/A2 Reference Patterns |
|---|---|
| `scfigR` | scPRINT UMAP, Panpipes marker/QC scripts, CellMentor RMarkdown panels, scFoundation annotation plots |
| `spfigR` | scHolography spatial/niche plotting, Sopa spatial tutorials, FineST overlay/imputation plots, Tumor-cell-villages niche scripts |
| `commfigR` | FastCCC report scripts, Human_endometrium CellPhoneDB/NicheNet scripts, FineST LR count notebooks |
| `trajfigR` | MoFlow plotting modules, ddHodge figure notebooks, ILC-NK-HIPEC figure scripts |
| `benchfigR` | NEP_comparison R scripts, cPeaks benchmark plots, CellANOVA tutorials, SMART benchmark notebooks |
| `multiomfigR` | SMART multi-omics tutorials, CAST alignment/projection demos, CAMEX cross-species notebooks |
