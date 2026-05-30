# multiomfigR Code Patterns

Purpose: record how A1/A2 GitHub code-learning patterns were rewritten into `multiomfigR` without copying upstream source code.

## Pattern Mapping

| Source Repo | Evidence | Learned Pattern | multiomfigR Rewrite |
|---|---|---|---|
| SMART | `tutorials/Tutorial_*.ipynb`; `benchmarks/SpatialGlue.ipynb`; `benchmarks/MultiVI.ipynb`; `benchmarks/MOFA.ipynb`; `benchmarks/WNN.ipynb` | integration figure should pair a map with modality and benchmark metrics | `plot_integration_embedding_panel()` plus `plot_modality_metric_panel()` |
| SpatialGlue | `requirements.txt`; `setup.py`; `Workflow.jpg` | spatial multi-omics needs domain/integration concept but exact figure paths are weak | generic integration embedding and modality metric panels; keep evidence A3 |
| CAMEX | `analysis/1liver/Integrate_liver_across_4_species.ipynb`; `analysis/2testis/Integrate_testis_across_11_species.ipynb`; `analysis/4cortex_annotation/integration_annotation_in_relatives_distant_species.ipynb` | cross-dataset/cross-species maps require validation heatmap | `plot_integration_embedding_panel()` plus `plot_cross_dataset_validation_panel()` |
| cPeaks | `Applications/plots.r`; `Applications/data4_CellDifferentiation_HSPC/analysis_WITHcPeaks.ipynb`; `Applications/data7_disease_tumor/reproduction/.../Figure_*` | accessibility features should be represented as explicit feature links or program heatmaps | `plot_feature_link_panel()` and `plot_pathway_program_panel()` |
| GET | `pyproject.toml`; `get_model/config/finetune_tutorial.yaml`; `get_model/config/pretrain_tutorial.yaml` | regulatory model figures need model-to-assay or feature-to-program link evidence | `plot_feature_link_panel()` and `plot_pathway_program_panel()`; exact figure scripts still `待复核` |
| AlphaGenome | `colabs/variant_eval_examples.ipynb`; `src/alphagenome_research/io/testdata/example.fa` | variant/regulatory predictions can be summarized as feature links before genome-track implementation | `plot_feature_link_panel()`; variant-track panel future |
| Human_endometrium | `umap_proportion.R`; `scRNA_map_Stereo.R`; `nichenet.R`; `scenic_step*.R/py` | stage-aware atlas should keep embedding, regulatory score, and program heatmap aligned | `plot_integration_embedding_panel()`, `plot_feature_link_panel()`, `plot_pathway_program_panel()` |

## Reusable Design Rules

- Do not treat a multi-omics figure as only an embedding. Pair the map with validation and mechanistic evidence.
- Keep modality, dataset, group, and cell-type naming stable across all panels.
- Use cross-dataset validation as the main guard against over-interpreting integration.
- Use feature/regulatory links to connect modalities, then pathway/program heatmaps to explain biology.
- Put full QC, alternative integration methods, and exhaustive feature links in Supplement.
- Do not copy upstream plotting functions; rewrite from source-data tables with explicit required columns.

## Toy Replication Exercise

1. Load `integration_embedding.tsv`, `modality_metrics.tsv`, `cross_dataset_validation.tsv`, `feature_links.tsv`, and `pathway_programs.tsv` from `multiomfigR`.
2. Draw each panel separately.
3. Combine them with `compose_multiomics_figure()`.
4. Export through `ncfigR::export_figure_bundle()`.
5. Replace the toy tables with Seurat WNN, MuData, MOFA, totalVI/MultiVI, or custom integration exports from the user's project.

## Project Transfer

| Upstream output | Project export table | multiomfigR function |
|---|---|---|
| integrated UMAP / latent space | `integration_embedding.tsv` | `plot_integration_embedding_panel()` |
| modality contribution / integration metric | `modality_metrics.tsv` | `plot_modality_metric_panel()` |
| label transfer / dataset transfer | `cross_dataset_validation.tsv` | `plot_cross_dataset_validation_panel()` |
| peak-gene / protein-gene / regulatory link | `feature_links.tsv` | `plot_feature_link_panel()` |
| pathway / module / regulatory program score | `pathway_programs.tsv` | `plot_pathway_program_panel()` |
