# trajfigR Code Patterns

Purpose: record how A1/A2 GitHub code-learning patterns were rewritten into `trajfigR` without copying upstream source code.

## Pattern Mapping

| Source Repo | Evidence | Learned Pattern | trajfigR Rewrite |
|---|---|---|---|
| MoFlow | `notebooks/fig2.ipynb`; `notebooks/fig3.ipynb`; `notebooks/fig4.ipynb`; `src/MoFlow/plot_cell.py`; `src/MoFlow/plot_gene.py` | pair a cell-level velocity/state map with gene-level dynamics | `plot_velocity_embedding_panel()` plus `plot_gene_trend_panel()` |
| ddHodge_figures | `notebook/sim2D_fig.ipynb`; `notebook/sim3D_fig.ipynb`; `notebook/dynamo_fig1_ess.ipynb`; `notebook/scvelo_fucci.ipynb` | vector field should be an interpretable direction panel, not only a dense arrow plot | `plot_velocity_embedding_panel()` and `plot_state_transition_panel()` |
| ILC-NK-HIPEC | `Figure 1.R`; `Figure 2.R`; `Figure 3A-D.R`; `Figure 4.R`; `Figure 5A-B.R`; `Figure 3D.ipynb`; `Figure 6H-J.ipynb` | immune differentiation figures need UMAP/state context plus signature trends | `plot_pseudotime_embedding_panel()`, `plot_branch_probability_panel()`, `plot_gene_trend_panel()` |
| VeloCD | `Preprocessing/3. Calculate spliced and unspliced transcript abundance/CalculateSplicedUnspliced.R`; `SensSpecScript.py` | clinical transition claims need transition summary and validation; exact figure path weak | `plot_state_transition_panel()` as concept-level rewrite; mark repo evidence A3 |

## Reusable Design Rules

- Treat trajectory as a multi-panel claim: global map, direction/branch evidence, interpretable gene or signature trend, and transition summary.
- Keep pseudotime scale stable across panels.
- Put alternative roots, parameter settings, full marker lists, and sensitivity checks in supplement.
- Use branch colours consistently, but use continuous palettes for pseudotime and trend values.
- Do not copy upstream plotting functions; rewrite from source-data tables with explicit required columns.

## Toy Replication Exercise

1. Load `trajectory_cells.tsv`, `branch_probabilities.tsv`, `gene_trends.tsv`, `state_transitions.tsv`, and `velocity_vectors.tsv` from `trajfigR`.
2. Draw each panel separately.
3. Combine them with `compose_trajectory_figure()`.
4. Export through `ncfigR::export_figure_bundle()`.
5. Replace the toy tables with Monocle3/slingshot/scVelo/dynamo exports from the user's project.

## Project Transfer

| Upstream output | Project export table | trajfigR function |
|---|---|---|
| UMAP + pseudotime | `trajectory_cells.tsv` | `plot_pseudotime_embedding_panel()` |
| RNA velocity / vector field | `velocity_vectors.tsv` | `plot_velocity_embedding_panel()` |
| branch assignment/probability | `branch_probabilities.tsv` | `plot_branch_probability_panel()` |
| smoothed gene/module trend | `gene_trends.tsv` | `plot_gene_trend_panel()` |
| transition probability matrix | `state_transitions.tsv` | `plot_state_transition_panel()` |
