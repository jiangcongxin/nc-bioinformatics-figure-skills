# Multi-Omics / Public-Data NC-Style Figure Templates

Purpose: turn the user's own public-data or multi-omics research project into an NC-style figure system. These templates are behavior-level recipes, not scientific claims.

## Required Project Intake

Before designing figures, collect or infer:

| Item | Examples | Why It Matters |
|---|---|---|
| Core claim | "Disease X shows a conserved inflammatory fibroblast program across public datasets." | Determines Figure 1 logic and panel order. |
| Data modalities | bulk RNA, scRNA, snRNA, spatial, ATAC, proteomics, microbiome, clinical metadata | Determines plot families and package stack. |
| Cohorts/datasets | GEO accession, published atlas, validation cohort, species | Determines cross-dataset validation figure. |
| Existing outputs | metadata, UMAP, DE table, marker table, module scores, GSEA, interactions, trajectory, benchmark metrics | Determines which panels are executable now. |
| Claim boundary | discovery only, validation, mechanism hypothesis, biomarker model | Prevents over-claiming in figure titles and legends. |

## Figure 1: Dataset, QC, Cell/Sample Structure, Main Signal

Goal: show that the project is data-grounded and that the main biological pattern is visible.

| Panel | Plot Type | Input Object/Table | Recommended Stack | Code Assets To Learn | NC Layout Rule |
|---|---|---|---|---|---|
| A | Study design / dataset flow | dataset manifest: accession, tissue, group, platform, n | Illustrator/draw.io + `ggplot2`/`matplotlib` for counts | Panpipes workflow logic; SMART tutorial structure | Put cohorts left-to-right from discovery to validation. |
| B | QC summary | per-sample QC metrics, cell counts, mapped reads, mitochondrial %, detected genes | `ggplot2`, `seaborn`, Panpipes QC scripts | `panpipes/python_scripts/plot_cluster_umaps.py`, `plot_qc_spatial.py`, `R_scripts/plot_metrics.R` | QC belongs early; do not hide sample exclusion logic. |
| C | Global embedding or sample map | AnnData/Seurat object or sample PCA table | `scanpy`, `Seurat`, `CellMentor`, `datamapplot` | CellMentor `Figures.Rmd`; scPRINT `figures/nice_umap.ipynb` | One embedding, multiple colorings, fixed layout. |
| D | Main phenotype/module signal | module_score table or DE summary | `ggplot2`, `seaborn`, `ComplexHeatmap`/`pheatmap` | CellANOVA and Panpipes marker plot logic | Show the first take-home signal, not every marker. |
| E | Representative markers/features | marker x cell-type dotplot or heatmap | `Seurat::DotPlot`, `scanpy.pl.dotplot`, `pheatmap` | Panpipes marker scripts; CellMentor RMarkdown | Keep gene order biologically interpretable. |

## Figure 2: Differential Programs, Modules, Pathways

Goal: turn DE genes into interpretable programs.

| Panel | Plot Type | Input Object/Table | Recommended Stack | Code Assets To Learn | NC Layout Rule |
|---|---|---|---|---|---|
| A | DE overview | DE table with logFC, p/FDR, cell type/group | `EnhancedVolcano`, `ggplot2`, `seaborn` | Panpipes marker scripts; CellMentor R plotting | Use volcano sparingly; highlight named programs. |
| B | Module/program heatmap | module score matrix: sample/cell x module | `ComplexHeatmap`, `pheatmap`, `seaborn.clustermap` | CellMentor `Figures.Rmd`; TranScale source-data table style | Annotate columns by cohort/group/platform. |
| C | Pathway enrichment | pathway table: term, NES/OR, FDR, group | `clusterProfiler`, `fgsea`, `gseapy`, `ggplot2`, `seaborn` | FastCCC uses `gseapy`; project-specific enrichment code `待复核` | Use dotplot or lollipop, not dense tables. |
| D | Cross-dataset conservation | dataset x module heatmap | `ComplexHeatmap`, `seaborn`, `CellANOVA` | CAMEX, CellANOVA validation logic | Figure 2 should answer whether the signal generalizes. |

## Figure 3: Multi-Omics Integration / Cross-Dataset Validation

Goal: prove the result is robust across modalities, datasets, species, or platforms.

| Panel | Plot Type | Input Object/Table | Recommended Stack | Code Assets To Learn | NC Layout Rule |
|---|---|---|---|---|---|
| A | Integration workflow | modality manifest + integration method summary | draw.io/Illustrator + minimal result thumbnails | SMART, SpatialGlue, CAST | Put modalities as lanes, not as a tangled network. |
| B | Integrated embedding/domain map | integrated AnnData/MuData/spatial object | `muon`, `scanpy`, `Seurat`, `SpatialGlue`, `SMART` | SMART tutorials; SpatialGlue repo | Same color key across modalities. |
| C | Method or validation benchmark | method x dataset metric table | `seaborn`, `ComplexHeatmap`, `ggplot2` | SMART benchmark notebooks; Novae benchmark configs | Matrix first, representative case second. |
| D | Batch/species/cohort validation | prediction/annotation transfer table | `CAMEX`, `CellANOVA`, `harmonypy`, `scanpy` | CAMEX analysis notebooks; CellANOVA tutorials | Validation panel should use independent data when possible. |

## Figure 4: Mechanism Layer

Goal: turn association into a plausible mechanism, while keeping claim boundaries cautious.

| Mechanism Type | Plot Type | Input Object/Table | Recommended Stack | Code Assets To Learn | NC Layout Rule |
|---|---|---|---|---|---|
| Cell-cell communication | LR heatmap + top network | ligand-receptor table, cell type pairs, FDR/score | `FastCCC`, `CellChat`, `networkx`, `ggraph`, `seaborn` | FastCCC demo and report scripts | Network only top interactions; full matrix in heatmap. |
| Trajectory/state transition | UMAP with arrows + gene trend | pseudotime/velocity, embedding, gene dynamics | `scVelo`, `dynamo`, `MoFlow`, `monocle3`, `matplotlib` | MoFlow fig notebooks and plot scripts | Direction, stage labels, and gene trends must agree. |
| Regulatory/epigenomic | peak/gene tracks + TF heatmap | peaks, motif scores, ATAC/RNA signal | `Gviz`, `pyGenomeTracks`, `GenomicRanges`, `cicero` | cPeaks `Applications/plots.r` | Use shared locus x-axis for all tracks. |
| Model/biomarker | predicted vs observed + calibration | prediction scores, labels, validation metrics | `scikit-learn`, `ggplot2`, `seaborn` | SMART/CellANOVA benchmark structure | Keep model performance secondary to biological claim. |

## Supplement Template

| Supplement Type | Include | Code Sources |
|---|---|---|
| QC supplement | per-sample QC, filtering thresholds, excluded samples, batch structure | Panpipes QC scripts |
| Benchmark supplement | method settings, metrics, runtime/memory, ablation | SMART, Novae, CellANOVA |
| Marker supplement | full marker tables, dotplots, heatmaps by cell type | Panpipes, CellMentor |
| Robustness supplement | alternate parameters, alternate cohorts, leave-one-dataset-out | CAMEX, CellANOVA |
| Source-data supplement | exact source-data tables per figure | TranScale, scPRINT |

## Minimum Deliverable For A User Project

When the user supplies a project, return this structure:

1. `Figure map`: Figure 1-4 + Supplement with one sentence goal per figure.
2. `Panel table`: panel ID, plot type, input file/object, package, reference repo, output filename.
3. `Code plan`: which recipe cards to instantiate and in what order.
4. `Polish checklist`: colors, legend, ordering, panel labels, export format, source data.
