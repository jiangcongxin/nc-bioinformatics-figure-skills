# NC Single-Cell / Spatial Figure-Level Templates

Purpose: train reusable NC-style figure thinking for single-cell and spatial omics projects. Each template starts from the figure question, then decides what belongs in the main figure, what moves to supplement, which plot types to use, how to assemble panels, and which GitHub-backed code assets to study.

Evidence rule: code paths and packages come from `code_asset_inventory.md` or the 50-paper library. If a package or script path was not statically confirmed, mark it `待复核` instead of treating it as fact.

## How To Use These Templates

1. Write the figure's one-sentence claim before choosing panels.
2. Choose one template, not many. A main figure should answer one question.
3. Keep 3-5 evidence layers in the main figure; move QC, full markers, all parameters, and all alternative metrics to supplement.
4. Build the figure from left to right: object/design -> global map -> key contrast -> mechanism/quantification -> validation.
5. Train with toy data first, then replace inputs with project tables.

## Template 1: Atlas Overview Figure

Use for: scRNA/snRNA atlas, public dataset integration, first main figure of a discovery paper.

Main-figure information:

| Keep In Main | Move To Supplement |
|---|---|
| cohort/sample overview, cell count summary, global UMAP, major cell-type marker dotplot, cell fraction by group | full QC violin, doublet/mitochondrial filters, all markers, every clustering resolution, batch diagnostics |

Panel order:

| Panel | Plot Type | Input | Package Stack | Reference Code |
|---|---|---|---|---|
| A | study/data schematic or compact dataset table | metadata | `ggplot2`/Illustrator style, or Python table plot | Panpipes workflow/QC scripts |
| B | QC or cell/sample count bar | metadata, QC table | R `ggplot2`, Python `seaborn` | Panpipes `plot_metrics.R`, `plot_cluster_umaps.py` |
| C | global UMAP by cell type | AnnData/Seurat object | Python `scanpy`; R `Seurat`, `ggplot2` | scPRINT `figures/nice_umap.ipynb`; CellMentor `Figures.Rmd` |
| D | UMAP by group/sample | same embedding | `scanpy`/`Seurat` | Panpipes UMAP script |
| E | marker dotplot or compact heatmap | marker table | `scanpy.pl.dotplot`, `Seurat::DotPlot`, `pheatmap` | Panpipes `plot_scanpy_markers.py`; CellMentor `Figures.Rmd` |
| F | cell fraction by group | cell metadata | `ggplot2`, `seaborn` | CellMentor/ Panpipes style |

Layout grid: 2 rows x 3 columns. Put the global UMAP largest. Keep dataset/QC panels small.

Toy replication: create an AnnData object with `cell_type`, `sample`, `group`, `n_genes`, and 6 marker genes; draw UMAP x 2, marker dotplot, and grouped composition bar.

Project-transfer rule: if the figure has no clear biological contrast, stop at atlas overview and do not add pathway/communication panels into Figure 1.

## Template 2: Disease vs Control Cell-State Figure

Use for: disease-control scRNA, treatment-control, responder-nonresponder, injury-repair comparisons.

Main-figure information:

| Keep In Main | Move To Supplement |
|---|---|
| disease/control UMAP split, affected cell type/state, state score, differential program heatmap, representative marker/stat plot | all DE genes, all cell types with no signal, all enrichment terms, alternative thresholds |

Panel order:

| Panel | Plot Type | Input | Package Stack | Reference Code |
|---|---|---|---|---|
| A | analysis contrast schematic | metadata | `ggplot2`, diagrams | Panpipes workflow concept |
| B | UMAP colored by group/state | AnnData/Seurat | `scanpy`, `Seurat` | scPRINT; CellMentor |
| C | cell fraction or state abundance | cell metadata | `ggplot2`, `seaborn` | CellMentor/ Panpipes style |
| D | module/signature score violin or ridge | score table | `ggplot2`, `seaborn` | CellMentor `Figures.Rmd` pattern |
| E | disease program heatmap | cell type x gene/module matrix | `pheatmap`, `ComplexHeatmap`, `seaborn` | CellMentor confirmed `pheatmap`; `ComplexHeatmap` not confirmed in first-pass repos |
| F | representative markers | expression table | dotplot/violin | Panpipes marker script |

Layout grid: left column global map, middle column quantitative shift, right column heatmap/signature. Use one red/blue disease-control contrast and do not recolor cell types by disease.

Toy replication: simulate 4 cell types, 2 groups, one activated state, 20 marker genes; generate UMAP split, abundance bar, module violin, and heatmap.

## Template 3: Spatial Tissue Niche Figure

Use for: spatial transcriptomics, histology-informed spatial domains, tumor microenvironment niches.

Main-figure information:

| Keep In Main | Move To Supplement |
|---|---|
| tissue image/domain map, cell type or spot overlay, niche/domain composition, niche marker heatmap, one zoom-in | full segmentation QC, all slides, all domains, all markers for every niche |

Panel order:

| Panel | Plot Type | Input | Package Stack | Reference Code |
|---|---|---|---|---|
| A | tissue overview or H&E thumbnail | image + coordinates | `spatialdata`/`squidpy 待复核`, `scanpy`, plotting backend | Sopa/FineST concept, package imports need repo-specific复核 |
| B | spatial domain map | spatial coordinates + domain | `scanpy`, `matplotlib`, `geopandas` | CAST confirms `geopandas`, `scanpy`; SMART/SpatialGlue concept |
| C | cell type overlay | coordinates + cell type | `scanpy`, `matplotlib` | Panpipes `plot_qc_spatial.py` |
| D | niche composition bar/heatmap | domain x cell type table | `seaborn`, `ggplot2` | Panpipes/CellMentor style |
| E | niche marker heatmap | domain x marker matrix | `pheatmap`, `seaborn` | CellMentor `pheatmap` |
| F | zoom-in with boundary/annotation | image + selected region | `matplotlib`, `ggplot2` | CAST demos for alignment/projection maps |

Layout grid: tissue image and domain map dominate the top row; quantitative panels sit below. Keep all spatial maps at the same aspect ratio and coordinate orientation.

Toy replication: generate 2D coordinates with 4 domains, a synthetic tissue image, cell-type labels, and marker scores; draw overview, domain, overlay, composition heatmap, and zoom.

## Template 4: Cell-State Program Figure

Use for: gene programs, module scores, pathways, cell-state interpretation after atlas or disease comparison.

Main-figure information:

| Keep In Main | Move To Supplement |
|---|---|
| 2-4 named programs, score distribution, program heatmap, pathway dotplot, representative genes | all modules, all pathway terms, full DE table, redundant gene lists |

Panel order:

| Panel | Plot Type | Input | Package Stack | Reference Code |
|---|---|---|---|---|
| A | UMAP score overlay | AnnData/Seurat + score | `scanpy`, `Seurat` | scPRINT/CellMentor |
| B | score violin/box by group | module score table | `ggplot2`, `seaborn` | CellMentor RMarkdown pattern |
| C | module heatmap | module x sample/cell type | `pheatmap`, `ComplexHeatmap`, `seaborn` | CellMentor `pheatmap`; TranScale source-data style |
| D | pathway dotplot | enrichment table | `ggplot2`, `seaborn` | generic; repo-specific code `待复核` |
| E | representative gene dot/violin | expression table | `Seurat`, `scanpy` | Panpipes marker plot |

Layout grid: one map, one distribution, one heatmap, one pathway summary. Avoid putting more than 4 programs in the main figure.

Toy replication: create `module_scores.tsv`, `pathway_enrichment.tsv`, and expression for 8 genes; reproduce score overlay, violin, heatmap, and dotplot.

## Template 5: Trajectory Figure

Use for: differentiation, activation, wound-repair, developmental time, RNA velocity or multi-omic relay velocity.

Main-figure information:

| Keep In Main | Move To Supplement |
|---|---|
| trajectory map with direction, pseudotime/stage composition, 3-5 gene trends, branch/state comparison | every gene trend, alternative root choices, parameter sweeps, all branch tests |

Panel order:

| Panel | Plot Type | Input | Package Stack | Reference Code |
|---|---|---|---|---|
| A | UMAP with state labels | embedding + state | `scanpy`, `matplotlib` | MoFlow notebooks |
| B | vector field/arrows or pseudotime gradient | velocity/pseudotime | `matplotlib`, `seaborn`; `scVelo/dynamo 待复核` | MoFlow `notebooks/fig*.ipynb`, `src/MoFlow/plot_cell.py` |
| C | stage/group composition along pseudotime | cell metadata | `ggplot2`, `seaborn` | MoFlow/CellMentor style |
| D | gene dynamics curves | expression + pseudotime | `matplotlib`, `seaborn` | MoFlow `src/MoFlow/plot_gene.py` |
| E | branch marker heatmap | branch x gene matrix | `pheatmap`, `seaborn` | CellMentor/MoFlow style |

Layout grid: trajectory map is the anchor; curves align beneath or to the right in the same pseudotime direction. Arrows, stage labels, and gene curves must agree.

Toy replication: simulate 3 states, pseudotime 0-1, branch labels, and 5 dynamic genes; draw arrows, pseudotime gradient, stage composition, and gene trends.

## Template 6: Cell-Cell Communication Figure

Use for: ligand-receptor, niche signaling, tumor microenvironment interaction, spatial proximity plus communication.

Main-figure information:

| Keep In Main | Move To Supplement |
|---|---|
| sender/receiver focus, LR heatmap, top network, condition differential, spatial proximity validation if available | all LR pairs, all pathways, dense full network, unfiltered p-value tables |

Panel order:

| Panel | Plot Type | Input | Package Stack | Reference Code |
|---|---|---|---|---|
| A | sender/receiver cell map | cell metadata + embedding/spatial | `scanpy`, `Seurat` | Panpipes/scPRINT |
| B | LR heatmap | source-target-LR score table | Python `seaborn`; R `ComplexHeatmap 待复核` | FastCCC demo/report scripts |
| C | top communication network | filtered LR table | `networkx`, `matplotlib`; R `ggraph 待复核` | FastCCC confirms `networkx` |
| D | differential LR volcano or dotplot | condition comparison table | `seaborn`, `matplotlib` | FastCCC `examples/report_differential_volcano.png` concept |
| E | spatial proximity validation | coordinates + cell type pairs | `matplotlib`, `scanpy`, `geopandas` | CAST/Panpipes spatial scripts |

Layout grid: heatmap carries the complete signal; network shows only top edges. Never make the network the only evidence.

Toy replication: create 60 LR rows with `source`, `target`, `ligand`, `receptor`, `score`, `p_adj`, and condition delta; draw heatmap, top network, and differential dot/volcano.

## Template 7: Spatial Multi-Sample Comparison Figure

Use for: multiple tissue slices, spatial alignment, cross-sample domain comparison, disease versus control spatial maps.

Main-figure information:

| Keep In Main | Move To Supplement |
|---|---|
| sample grid, domain map, alignment/projection result, similarity matrix, one case zoom | all slices, all alignment metrics, failed/low-quality samples, parameter sweeps |

Panel order:

| Panel | Plot Type | Input | Package Stack | Reference Code |
|---|---|---|---|---|
| A | sample grid thumbnails | image metadata | `matplotlib`/layout tool | CAST demos concept |
| B | domain maps by sample | coordinates + domains | `scanpy`, `matplotlib` | CAST, SMART, SpatialGlue |
| C | aligned/projection maps | aligned coordinates | `CAST`, `scanpy`, `geopandas` | CAST demo notebooks |
| D | similarity/transfer heatmap | sample x sample or domain x domain score | `seaborn`, `pheatmap` | CAST/SMART benchmark style |
| E | case zoom-in | selected region | `matplotlib` | CAST projection demo |

Layout grid: samples are columns; plot types are rows. This preserves visual comparability.

Toy replication: create 4 synthetic samples with domains and a similarity matrix; draw 2-row domain/alignment grid plus heatmap and zoom.

## Template 8: Treatment / Condition Response Figure

Use for: pre/post therapy, dose response, perturbation, intervention studies.

Main-figure information:

| Keep In Main | Move To Supplement |
|---|---|
| condition design, UMAP/state shift, cell fraction change, functional score, response-associated program | all treatment arms with no signal, all cytokines/genes, every subgroup analysis |

Panel order:

| Panel | Plot Type | Input | Package Stack | Reference Code |
|---|---|---|---|---|
| A | condition/timepoint design | metadata | `ggplot2`/schematic | Panpipes workflow style |
| B | UMAP split by condition | AnnData/Seurat | `scanpy`, `Seurat` | CellMentor/scPRINT |
| C | cell fraction or transition matrix | metadata | `ggplot2`, `seaborn` | CellMentor style |
| D | state/function score | score table | `ggplot2`, `seaborn` | CellMentor |
| E | response program heatmap | gene/module matrix | `pheatmap`, `seaborn` | CellMentor/Panpipes |
| F | validation/stat panel | validation table | `ggplot2`, `seaborn` | generic, repo-specific `待复核` |

Layout grid: conditions should be rows or columns consistently. Use condition colors only for condition panels; keep cell-type colors stable.

Toy replication: simulate 3 timepoints or 2 treatments, cell fractions, state scores, and a module heatmap.

## Template 9: Annotation / Marker Validation Figure

Use for: cell-type annotation, label transfer, new population validation, reference-query mapping.

Main-figure information:

| Keep In Main | Move To Supplement |
|---|---|
| reference map, query map, marker dotplot, transfer/confusion matrix, one new/rare population zoom | every marker, all classifier metrics, full label-transfer tables |

Panel order:

| Panel | Plot Type | Input | Package Stack | Reference Code |
|---|---|---|---|---|
| A | reference UMAP | reference object | `scanpy`, `Seurat` | CAMEX/CellMentor |
| B | query UMAP or projection | query object | `scanpy`, `harmonypy`, `CAMEX` | CAMEX analysis notebooks |
| C | marker dotplot | marker expression | `scanpy.pl.dotplot`, `Seurat::DotPlot` | Panpipes marker scripts |
| D | confusion/transfer matrix | predicted vs reference labels | `seaborn`, `pheatmap` | CellMentor benchmark style |
| E | new population zoom | embedding + selected cells | `scanpy`, `ggplot2` | Rare-cluster pattern from aKNNO/RareQ library entries |

Layout grid: reference and query maps side by side with identical color keys. Put validation matrix immediately after maps.

Toy replication: create reference/query labels, predicted labels, and marker genes; draw reference map, query map, dotplot, and confusion heatmap.

## Template 10: Benchmark + Biological Case Figure

Use for: method papers and project methods where a benchmark must connect to biology.

Main-figure information:

| Keep In Main | Move To Supplement |
|---|---|
| metric heatmap, average rank, runtime/robustness if essential, one biological case showing why the metric matters | all datasets, all secondary metrics, all ablation panels, hyperparameter sweeps |

Panel order:

| Panel | Plot Type | Input | Package Stack | Reference Code |
|---|---|---|---|---|
| A | benchmark design schematic | method/dataset table | `ggplot2`, schematic | SMART/Panpipes workflow style |
| B | method x dataset metric heatmap | metrics table | `seaborn`, `ComplexHeatmap 待复核` | SMART benchmark notebooks; CellANOVA tutorials |
| C | average rank/lollipop | metrics summary | `ggplot2`, `seaborn` | CellMentor metrics style |
| D | runtime/robustness compact panel | runtime table | `ggplot2`, `seaborn` | SMART/Novae benchmark concept |
| E | biological case example | embedding/spatial object | `scanpy`, `matplotlib` | SMART, CellANOVA, Novae |

Layout grid: metrics first, case second. A benchmark without a biological case often feels like a supplement figure.

Toy replication: create `metrics.tsv` with 5 methods x 6 datasets and one AnnData example; draw heatmap, rank plot, and case UMAP/spatial map.

## Template 11: Supplement QC Figure

Use for: quality assurance, reproducibility, reviewer trust.

Main-figure information:

| Keep In Main | Move To Supplement |
|---|---|
| usually none unless QC is the paper's method contribution | QC violin, sample distribution, sequencing depth, doublet rate, batch checks, parameter sensitivity |

Panel order:

| Panel | Plot Type | Input | Package Stack | Reference Code |
|---|---|---|---|---|
| A | sample/cell count bar | metadata | `ggplot2`, `seaborn` | Panpipes `plot_metrics.R` |
| B | QC violin | QC table | `ggplot2`, `scanpy` | Panpipes QC scripts |
| C | batch/dataset UMAP | AnnData/Seurat | `scanpy`, `Seurat` | Panpipes/CellMentor |
| D | marker sanity dotplot | marker table | `scanpy`, `Seurat` | Panpipes marker script |
| E | parameter sensitivity | metrics table | `seaborn`, `ggplot2` | CellANOVA/SMART benchmark pattern |

Layout grid: dense but readable. Supplement can use repeated small panels because its job is audit, not first-impression storytelling.

Toy replication: create QC metrics and 3 parameter settings; draw violin, batch UMAP, marker dotplot, and sensitivity heatmap.

## Template 12: NC Panel Hierarchy Figure

Use for: training how to assemble 6-8 panels into one journal-level main figure.

Main-figure information:

| Keep In Main | Move To Supplement |
|---|---|
| one dominant visual anchor, 2-3 quantitative supports, 1 mechanism layer, 1 validation/case panel | duplicated maps, every gene/metric, low-information decorative panels |

Panel hierarchy:

| Role | Typical Plot | Rule |
|---|---|---|
| Anchor | UMAP, spatial map, genome track, or benchmark heatmap | largest panel; establishes what the reader should remember |
| Context | workflow, metadata, sample map | small, left/top |
| Quantification | bar, violin, box, fraction, score | close to the map it explains |
| Mechanism | heatmap, LR network, trajectory, pathway dotplot | after the observed difference |
| Validation | independent cohort/sample/case zoom | right/bottom end of story |

Layout grid: 12-column mental grid. Use 2-3 panel widths only: small context, medium quantification, large anchor. Avoid equal-sized grids when one panel carries the argument.

Toy replication: take any 6 toy panels and arrange as `A context`, `B large map`, `C quantification`, `D heatmap`, `E mechanism`, `F validation`; export PDF/SVG with fixed panel labels.

## Template Selection Matrix

| User Project Signal | Recommended Template |
|---|---|
| first atlas/result overview | Atlas Overview Figure |
| disease or treatment shifts cell state | Disease vs Control Cell-State Figure; Treatment/Condition Response Figure |
| spatial domains or tissue microenvironment | Spatial Tissue Niche Figure |
| gene programs/pathways/modules are central | Cell-State Program Figure |
| differentiation or time/state transition | Trajectory Figure |
| ligand-receptor or microenvironment signaling | Cell-Cell Communication Figure |
| many tissue sections or alignment | Spatial Multi-Sample Comparison Figure |
| annotation quality or label transfer | Annotation/Marker Validation Figure |
| method comparison plus one biological case | Benchmark + Biological Case Figure |
| reviewer asks QC/reproducibility | Supplement QC Figure |
| user asks how to arrange panels | NC Panel Hierarchy Figure |
