# trajfigR API

Purpose: `trajfigR` is the fourth domain package built from the NC GitHub code-learning pipeline. It implements a source-data-first Trajectory Figure MVP and uses `ncfigR` for shared theme, network, trajectory trend, composition, and export behavior.

## Package Scope

```text
packages/trajfigR/
  R/panels.R
  R/utils.R
  inst/extdata/trajectory_cells.tsv
  inst/extdata/branch_probabilities.tsv
  inst/extdata/gene_trends.tsv
  inst/extdata/state_transitions.tsv
  inst/extdata/velocity_vectors.tsv
  tests/testthat/test-core.R
  vignettes/trajectory-figure.Rmd
```

## Source-Data Interfaces

| Table | Required columns | Purpose |
|---|---|---|
| `trajectory_cells.tsv` | `cell_id,x,y,pseudotime,state,branch,stage` | pseudotime embedding / state map |
| `velocity_vectors.tsv` | `cell_id,x,y,dx,dy,state,pseudotime` | velocity or direction arrows on embedding |
| `branch_probabilities.tsv` | `cell_id,pseudotime,branch,probability,stage` | branch commitment trends |
| `gene_trends.tsv` | `cell_id,pseudotime,feature,value,branch` | gene/module/signature trend curves |
| `state_transitions.tsv` | `from_state,to_state,weight,transition_type` | directed state-transition graph |

## Core Functions

| Function | Input | Output |
|---|---|---|
| `plot_pseudotime_embedding_panel()` | `trajectory_cells.tsv` | UMAP/embedding map coloured by pseudotime |
| `plot_velocity_embedding_panel()` | `velocity_vectors.tsv` | state-coloured embedding with velocity/direction arrows |
| `plot_branch_probability_panel()` | `branch_probabilities.tsv` | branch probability trend curves |
| `plot_gene_trend_panel()` | `gene_trends.tsv` | faceted gene/module trends across pseudotime |
| `plot_state_transition_panel()` | `state_transitions.tsv` | directed state transition network |
| `compose_trajectory_figure()` | all trajectory panel tables | NC-style composite Trajectory Figure |

## Minimal Use

```r
library(readr)
library(trajfigR)
library(ncfigR)

cells <- read_tsv("figures/source_data/trajectory_cells.tsv")
branches <- read_tsv("figures/source_data/branch_probabilities.tsv")
trends <- read_tsv("figures/source_data/gene_trends.tsv")
transitions <- read_tsv("figures/source_data/state_transitions.tsv")
velocity <- read_tsv("figures/source_data/velocity_vectors.tsv")

fig <- compose_trajectory_figure(cells, branches, trends, transitions, velocity)
export_figure_bundle(fig, "fig_trajectory", out_dir = "figures/exports", width = 7, height = 5)
```

## Figure-Level Layout

Recommended NC-style panel order:

1. `velocity / direction map` when vectors exist, otherwise `pseudotime map`.
2. `pseudotime map` as global anchor.
3. `branch probability` or branch/state composition as quantitative commitment evidence.
4. `gene trend` for biological interpretation.
5. `state transition` as a compact mechanism/direction summary.

Use the same state and branch names across all panels. Keep full QC, parameter sweeps, and alternative trajectory roots in supplement.

## Status

- `trajfigR` v0.1.0 is a Trajectory Figure MVP.
- It is source-data-first and does not depend on Monocle3, slingshot, scVelo, or dynamo objects.
- Those tools should export standardized TSVs before plotting.
- 3D landscape / potential surface panels remain future extensions and should be marked `stub needed`.
