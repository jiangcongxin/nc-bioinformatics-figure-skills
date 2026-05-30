# multiomfigR API

Purpose: `multiomfigR` is the sixth domain package built from the NC GitHub code-learning pipeline. It implements a source-data-first Multi-omics Integration Figure MVP and uses `ncfigR` for shared theme, embedding, heatmap, network, composition, and export behavior.

## Package Scope

```text
packages/multiomfigR/
  R/panels.R
  R/utils.R
  inst/extdata/integration_embedding.tsv
  inst/extdata/modality_metrics.tsv
  inst/extdata/cross_dataset_validation.tsv
  inst/extdata/feature_links.tsv
  inst/extdata/pathway_programs.tsv
  tests/testthat/test-core.R
  vignettes/multiomics-figure.Rmd
```

## Source-Data Interfaces

| Table | Required columns | Purpose |
|---|---|---|
| `integration_embedding.tsv` | `cell_id,x,y,cell_type,modality,dataset,integration_score` | integrated embedding / modality structure |
| `modality_metrics.tsv` | `modality,dataset,metric,value` | modality contribution or integration metrics |
| `cross_dataset_validation.tsv` | `source_dataset,target_dataset,metric,value` | cross-dataset label transfer or program concordance |
| `feature_links.tsv` | `source_feature,target_feature,weight,link_type` | regulatory, peak-gene, protein-gene, or gene-program links |
| `pathway_programs.tsv` | `program,group,score` | pathway or program activity heatmap |

## Core Functions

| Function | Input | Output |
|---|---|---|
| `plot_integration_embedding_panel()` | `integration_embedding.tsv` | integrated embedding coloured by cell type/domain with optional modality shape |
| `plot_modality_metric_panel()` | `modality_metrics.tsv` | modality/dataset metric heatmap |
| `plot_cross_dataset_validation_panel()` | `cross_dataset_validation.tsv` | source-by-target validation heatmap |
| `plot_feature_link_panel()` | `feature_links.tsv` | directed feature/regulatory link graph |
| `plot_pathway_program_panel()` | `pathway_programs.tsv` | pathway/program heatmap |
| `compose_multiomics_figure()` | all multi-omics panel tables | NC-style composite multi-omics figure |

## Minimal Use

```r
library(readr)
library(multiomfigR)
library(ncfigR)

embedding <- read_tsv("figures/source_data/integration_embedding.tsv")
metrics <- read_tsv("figures/source_data/modality_metrics.tsv")
validation <- read_tsv("figures/source_data/cross_dataset_validation.tsv")
links <- read_tsv("figures/source_data/feature_links.tsv")
programs <- read_tsv("figures/source_data/pathway_programs.tsv")

fig <- compose_multiomics_figure(embedding, metrics, validation, links, programs)
export_figure_bundle(fig, "fig_multiomics", out_dir = "figures/exports", width = 7, height = 5)
```

## Figure-Level Layout

Recommended NC-style panel order:

1. Integrated embedding as the anchor.
2. Modality metrics to prove integration quality.
3. Cross-dataset validation to prove transfer/generalization.
4. Feature/regulatory links to connect modalities mechanistically.
5. Pathway/program panel to explain biological signal.

Put full modality-specific QC, all alternative integration settings, and exhaustive feature links in Supplement.

## Status

- `multiomfigR` v0.1.0 is a Multi-omics Integration MVP.
- It is source-data-first and does not depend on MuData, Seurat, AnnData, MOFA, or WNN objects.
- Those tools should export standardized TSVs before plotting.
- Genome-track, variant-track, calibration, and 3D spatial multi-omics panels remain future extensions and should be marked `stub needed` unless implemented.
