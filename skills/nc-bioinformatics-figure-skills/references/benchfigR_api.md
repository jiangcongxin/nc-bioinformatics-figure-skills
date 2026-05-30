# benchfigR API

Purpose: `benchfigR` is the fifth domain package built from the NC GitHub code-learning pipeline. It implements a source-data-first Benchmark + Biological Case Figure MVP and uses `ncfigR` for shared theme, benchmark heatmap, embedding, composition, and export behavior.

## Package Scope

```text
packages/benchfigR/
  R/panels.R
  R/utils.R
  inst/extdata/benchmark_metrics.tsv
  inst/extdata/benchmark_ranks.tsv
  inst/extdata/runtime_metrics.tsv
  inst/extdata/robustness_metrics.tsv
  inst/extdata/case_embedding.tsv
  tests/testthat/test-core.R
  vignettes/benchmark-case-figure.Rmd
```

## Source-Data Interfaces

| Table | Required columns | Purpose |
|---|---|---|
| `benchmark_metrics.tsv` | `method,dataset,metric,value` | metric heatmap across methods, datasets, and metrics |
| `benchmark_ranks.tsv` | `method,metric,rank,value` | compact rank summary |
| `runtime_metrics.tsv` | `method,dataset,runtime_sec,memory_gb` | runtime and memory comparison |
| `robustness_metrics.tsv` | `method,perturbation,metric,value` | sensitivity / robustness curves |
| `case_embedding.tsv` | `cell_id,x,y,label,score,method` | representative biological case panel |

## Core Functions

| Function | Input | Output |
|---|---|---|
| `plot_metric_heatmap_panel()` | `benchmark_metrics.tsv` | method-by-dataset metric heatmap, faceted by metric |
| `plot_rank_panel()` | `benchmark_ranks.tsv` | rank dotplot |
| `plot_runtime_panel()` | `runtime_metrics.tsv` | runtime barplot or runtime-memory scatter |
| `plot_robustness_panel()` | `robustness_metrics.tsv` | robustness trend curves |
| `plot_case_embedding_panel()` | `case_embedding.tsv` | labelled or score-coloured representative case map |
| `compose_benchmark_case_figure()` | all benchmark/case panel tables | NC-style composite benchmark-case figure |

## Minimal Use

```r
library(readr)
library(benchfigR)
library(ncfigR)

metrics <- read_tsv("figures/source_data/benchmark_metrics.tsv")
ranks <- read_tsv("figures/source_data/benchmark_ranks.tsv")
runtime <- read_tsv("figures/source_data/runtime_metrics.tsv")
robustness <- read_tsv("figures/source_data/robustness_metrics.tsv")
case <- read_tsv("figures/source_data/case_embedding.tsv")

fig <- compose_benchmark_case_figure(metrics, ranks, runtime, robustness, case)
export_figure_bundle(fig, "fig_benchmark_case", out_dir = "figures/exports", width = 7, height = 5)
```

## Figure-Level Layout

Recommended NC-style panel order:

1. Metric heatmap as the benchmark anchor.
2. Rank summary to make the method ordering scannable.
3. Runtime/memory or robustness panel for practicality.
4. Representative biological case panel to prove interpretability.
5. Keep exhaustive dataset-by-metric tables, parameter sweeps, and ablations in Supplement.

## Status

- `benchfigR` v0.1.0 is a Benchmark + Biological Case MVP.
- It is source-data-first and does not depend on a specific benchmark framework.
- Genome-track, calibration-curve, and before/after embedding triptych panels remain future extensions and should be marked `stub needed` unless implemented.
