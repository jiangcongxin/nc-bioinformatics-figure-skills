# benchfigR Code Patterns

Purpose: record how A1/A2 GitHub code-learning patterns were rewritten into `benchfigR` without copying upstream source code.

## Pattern Mapping

| Source Repo | Evidence | Learned Pattern | benchfigR Rewrite |
|---|---|---|---|
| NEP_comparison | `scripts/overall_NEP_scores_plot.R`; `scripts/NEP_selfpref_scores_plot.R`; `notebooks/MI_data_comparison/NEP_MI_heart_comparison.Rmd` | benchmark heatmap should be paired with an interpretable spatial/biological example | `plot_metric_heatmap_panel()`, `plot_rank_panel()`, `plot_case_embedding_panel()` |
| CellANOVA | `tutorials/cellanova_integration.ipynb`; `tutorials/eval_signal_preservation.ipynb`; `figures/model.jpg` | integration benchmark needs metric evidence plus representative before/after biological case | `plot_metric_heatmap_panel()`, `plot_runtime_panel()`, `plot_case_embedding_panel()` |
| scFoundation | `DeepCDR/plot.ipynb`; `GEARS/Plot.ipynb`; `SCAD/plot-publish.ipynb`; `annotation/celltype-plot.ipynb`; `genemodule/plot_geneemb.ipynb` | task benchmark notebooks can be normalized into metric/rank/case panels | `plot_metric_heatmap_panel()`, `plot_rank_panel()`, `plot_case_embedding_panel()` |
| TranScale | `code/`; `Source_Data/README.md`; `Source_Data/Source Data_Figure5*.xlsx` | calibration/absolute expression evidence should sit next to a quantitative heatmap | generic `plot_metric_heatmap_panel()` plus future calibration panel |
| Novae benchmark | `pyproject.toml`; `setup.py`; `config/benchmark_union_local.yml` | config-driven benchmarks should export one normalized metric table | `plot_metric_heatmap_panel()`; exact figure scripts still `待复核` |
| Evo2 | `notebooks/brca1/brca1_zero_shot_vep.ipynb`; `notebooks/exon_classifier/exon_classifier.ipynb`; `phage_gen/analysis/*.py` | model benchmark should include metric summary plus one interpretable case | `plot_metric_heatmap_panel()` and `plot_case_embedding_panel()`; genome/variant panel future |

## Reusable Design Rules

- Do not make a main figure out of only metrics. Pair benchmark evidence with one biological case.
- Put full metric tables, all parameter sweeps, and per-dataset ablations in Supplement.
- Use one metric heatmap as the anchor, then one compact rank panel for method ordering.
- Runtime/memory and robustness are practical evidence; keep them smaller than the metric anchor.
- Keep rank direction explicit in captions and source data; lower rank is treated as better by default.
- Do not copy upstream plotting functions; rewrite from source-data tables with explicit required columns.

## Toy Replication Exercise

1. Load `benchmark_metrics.tsv`, `benchmark_ranks.tsv`, `runtime_metrics.tsv`, `robustness_metrics.tsv`, and `case_embedding.tsv` from `benchfigR`.
2. Draw each panel separately.
3. Combine them with `compose_benchmark_case_figure()`.
4. Export through `ncfigR::export_figure_bundle()`.
5. Replace the toy tables with benchmark exports from the user's project.

## Project Transfer

| Upstream output | Project export table | benchfigR function |
|---|---|---|
| method x dataset x metric matrix | `benchmark_metrics.tsv` | `plot_metric_heatmap_panel()` |
| aggregated method ordering | `benchmark_ranks.tsv` | `plot_rank_panel()` |
| wall time / memory | `runtime_metrics.tsv` | `plot_runtime_panel()` |
| perturbation / sensitivity runs | `robustness_metrics.tsv` | `plot_robustness_panel()` |
| representative embedding / spatial case | `case_embedding.tsv` | `plot_case_embedding_panel()` |
