# Advanced Composite Code Templates

Purpose: map NC-style advanced figure templates to `ncfigR` function calls.

## Atlas Overview

Use when the figure needs a global single-cell or public-atlas overview.

```r
p_umap <- plot_embedding_panel(embedding, color_col = "cell_type", palette = cell_type_palette)
p_comp <- plot_composition_panel(composition, palette = cell_type_palette)
p_marker <- plot_marker_heatmap(marker_matrix)
fig <- compose_nc_figure(list(p_umap, p_comp, p_marker), ncol = 3, title = "Atlas overview")
```

Expected source data:

- `embedding.tsv`
- `composition.tsv`
- `marker_matrix.tsv`
- `cell_type_palette.tsv`

## Spatial Tissue Niche

Use when a spatial map must be paired with niche quantification.

```r
p_map <- plot_embedding_panel(spatial_coordinates, color_col = "domain", palette = domain_palette)
p_comp <- plot_composition_panel(domain_composition, group_col = "domain", category_col = "cell_type", palette = cell_type_palette)
p_marker <- plot_marker_heatmap(niche_marker_matrix, row_col = "feature", col_col = "domain")
fig <- compose_nc_figure(list(p_map, p_comp, p_marker), ncol = 2, title = "Spatial tissue niche")
```

Expected source data:

- spatial coordinate table with `x`, `y`, `domain`
- domain composition table
- niche marker matrix
- domain and cell type palettes

## Cell-Cell Communication

Use when LR heatmap and a filtered network are both needed.

```r
p_heat <- plot_lr_heatmap(lr_pairs)
p_net <- plot_lr_network(lr_pairs, top_n = 20)
fig <- compose_nc_figure(list(p_heat, p_net), ncol = 2, title = "Communication")
```

Expected source data:

- `lr_pairs.tsv` with source, target, ligand, receptor, score, and adjusted P value.

## Trajectory

Use when state maps, branch evidence, gene trends, and transition direction should share the same pseudotime logic.

```r
library(trajfigR)

p_time <- plot_pseudotime_embedding_panel(trajectory_cells)
p_branch <- plot_branch_probability_panel(branch_probabilities)
p_trend <- plot_gene_trend_panel(gene_trends, branch_col = "branch")
p_state <- plot_state_transition_panel(state_transitions)
fig <- compose_trajectory_figure(
  trajectory_cells,
  branch_probabilities,
  gene_trends,
  state_transitions,
  velocity_vectors = velocity_vectors
)
```

Expected source data:

- `trajectory_cells.tsv` with `cell_id`, `x`, `y`, `pseudotime`, `state`, `branch`, `stage`
- `branch_probabilities.tsv` with `cell_id`, `pseudotime`, `branch`, `probability`, `stage`
- `gene_trends.tsv` with `cell_id`, `pseudotime`, `feature`, `value`, `branch`
- `state_transitions.tsv` with `from_state`, `to_state`, `weight`, `transition_type`
- optional `velocity_vectors.tsv` with `cell_id`, `x`, `y`, `dx`, `dy`, `state`, `pseudotime`

## Benchmark + Biological Case

Use when a metric matrix must connect to one interpretable example.

```r
library(benchfigR)

p_metric <- plot_metric_heatmap_panel(benchmark_metrics)
p_rank <- plot_rank_panel(benchmark_ranks)
p_runtime <- plot_runtime_panel(runtime_metrics, memory_col = "memory_gb")
p_robust <- plot_robustness_panel(robustness_metrics)
p_case <- plot_case_embedding_panel(case_embedding, score_col = "score")
fig <- compose_benchmark_case_figure(
  benchmark_metrics,
  benchmark_ranks,
  runtime_metrics,
  robustness_metrics,
  case_embedding
)
```

Expected source data:

- `benchmark_metrics.tsv`
- `benchmark_ranks.tsv`
- `runtime_metrics.tsv`
- `robustness_metrics.tsv`
- `case_embedding.tsv`

## Multi-Omics Integration

Use when an integrated map must be supported by validation and mechanistic interpretation.

```r
library(multiomfigR)

p_embed <- plot_integration_embedding_panel(integration_embedding, shape_col = "modality")
p_metric <- plot_modality_metric_panel(modality_metrics)
p_valid <- plot_cross_dataset_validation_panel(cross_dataset_validation)
p_link <- plot_feature_link_panel(feature_links)
p_program <- plot_pathway_program_panel(pathway_programs)
fig <- compose_multiomics_figure(
  integration_embedding,
  modality_metrics,
  cross_dataset_validation,
  feature_links,
  pathway_programs
)
```

Expected source data:

- `integration_embedding.tsv`
- `modality_metrics.tsv`
- `cross_dataset_validation.tsv`
- `feature_links.tsv`
- `pathway_programs.tsv`

## Project Transfer Checklist

Before transferring a repo pattern to `ncfigR`, confirm:

- the user has source-data tables or a Seurat object adapter path
- palette files exist and are not hard-coded in scripts
- the plot function returns a reusable object
- the final figure is exported with `export_figure_bundle()`
- source data manifest records each panel input
