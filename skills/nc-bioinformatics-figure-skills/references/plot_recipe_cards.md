# Plot Recipe Cards

Purpose: convert NC-style figure thinking into reusable R/Python plotting recipes for the user's own projects. Use real user data paths when available; otherwise use toy schemas and leave file paths explicit.

## Recipe 1: Embedding Narrative

Use for: scRNA/snRNA, integrated public atlases, model embeddings, cross-dataset validation.

Input schema:

| File/Object | Required Columns/Fields |
|---|---|
| `adata.h5ad` or Seurat object | embedding coordinates, `cell_type`, `sample`, `group`, optional `module_score` |
| `metrics.tsv` | method/model, dataset, metric, value |

Recommended packages:

- Python: `scanpy`, `anndata`, `matplotlib`, `seaborn`, `datamapplot`
- R: `Seurat`, `ggplot2`, `cowplot`, `patchwork`, `dittoSeq`

Reference code:

- scPRINT: `figures/nice_umap.ipynb`, `figures/niceumap.py`
- CellMentor: `Figures.Rmd`
- Panpipes: `panpipes/python_scripts/plot_cluster_umaps.py`

Python skeleton:

```python
import scanpy as sc
import matplotlib.pyplot as plt

adata = sc.read_h5ad("input/project_integrated.h5ad")
palette = dict(zip(sorted(adata.obs["cell_type"].unique()), sc.pl.palettes.default_20))

fig, axes = plt.subplots(1, 3, figsize=(10.5, 3.2), constrained_layout=True)
for ax, color, title in zip(
    axes,
    ["cell_type", "group", "module_score"],
    ["Cell type", "Group", "Module score"],
):
    sc.pl.umap(adata, color=color, ax=ax, show=False, frameon=False, title=title, palette=palette if color == "cell_type" else None)
fig.savefig("outputs/fig1_embedding_narrative.svg")
```

NC-style checks:

- Same embedding coordinates across all panels.
- Cell-type colors do not change between main and supplement.
- Metrics panel explains why the embedding matters.

## Recipe 2: Annotation Heatmap / Module Heatmap

Use for: DE gene modules, pathway scores, cross-cohort validation, public-data meta-analysis.

Input schema:

| File | Required Columns |
|---|---|
| `module_scores.tsv` | sample/cell_type, group, dataset, module, score |
| `annotation.tsv` | sample/cell_type, cohort, platform, disease, response |

Recommended packages:

- R: `ComplexHeatmap`, `pheatmap`, `circlize`, `dplyr`, `tidyr`
- Python: `pandas`, `seaborn`, `matplotlib`

Reference code:

- CellMentor: `Figures.Rmd` confirms `pheatmap`, `ggplot2`, `patchwork`
- TranScale: `Source_Data/Source Data_Figure*.xlsx`
- cPeaks: `Applications/plots.r`

R skeleton:

```r
library(ComplexHeatmap)
library(circlize)
library(tidyverse)

scores <- readr::read_tsv("input/module_scores.tsv")
mat <- scores |>
  select(sample, module, score) |>
  pivot_wider(names_from = sample, values_from = score) |>
  column_to_rownames("module") |>
  as.matrix()

anno <- readr::read_tsv("input/sample_annotation.tsv")
top <- HeatmapAnnotation(
  group = anno$group,
  dataset = anno$dataset
)

pdf("outputs/fig2_module_heatmap.pdf", width = 7, height = 5)
Heatmap(mat, name = "score", top_annotation = top, cluster_rows = TRUE, cluster_columns = FALSE)
dev.off()
```

NC-style checks:

- Columns ordered by biological contrast, not by clustering alone.
- Annotation tracks explain cohort, disease, treatment, or platform.
- Highlight 2-4 modules in the legend/caption instead of all genes.

## Recipe 3: Multi-Omics Integration / Validation Matrix

Use for: RNA+ATAC/protein/spatial integration, cross-dataset validation, method benchmark.

Input schema:

| File/Object | Required Columns/Fields |
|---|---|
| `metrics.tsv` | method, dataset, modality, metric, value |
| `example_embedding.h5ad` | integrated embedding, method/domain labels |

Recommended packages:

- Python: `muon`, `scanpy`, `seaborn`, `matplotlib`, `scikit-learn`
- R: `ggplot2`, `ComplexHeatmap`, `patchwork`

Reference code:

- SMART: `tutorials/Tutorial_*.ipynb`, `benchmarks/*.ipynb`
- SpatialGlue: `requirements.txt`, `Workflow.jpg`
- CellANOVA: `tutorials/eval_signal_preservation.ipynb`
- CAMEX: `analysis/*/Integrate_*.ipynb`

Python skeleton:

```python
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

metrics = pd.read_csv("input/integration_metrics.tsv", sep="\\t")
heat = metrics.pivot_table(index="method", columns="dataset", values="score")

fig, ax = plt.subplots(figsize=(6, 4))
sns.heatmap(heat, cmap="viridis", annot=True, fmt=".2f", ax=ax)
ax.set_xlabel("Dataset")
ax.set_ylabel("Method")
fig.tight_layout()
fig.savefig("outputs/fig3_integration_benchmark.svg")
```

NC-style checks:

- Benchmark matrix plus one representative visual example.
- Datasets grouped by modality or cohort.
- Metrics defined in the caption/source data.

## Recipe 4: Cell-Cell Communication / Niche Network

Use for: ligand-receptor analysis, microenvironment interactions, niche programs.

Input schema:

| File | Required Columns |
|---|---|
| `lr_pairs.tsv` | source, target, ligand, receptor, score, p_adj |
| `celltype_positions.tsv` | cell_id, x, y, cell_type, niche optional |

Recommended packages:

- Python: `FastCCC`, `scanpy`, `networkx`, `seaborn`, `matplotlib`
- R: `CellChat`, `NicheNet`, `ggraph`, `ComplexHeatmap`

Reference code:

- FastCCC: `fastccc_demo.ipynb`, `examples/report_single_condition.py`, `examples/report_multi_condition.py`
- NiCo tutorial: niche covariation logic

Python skeleton:

```python
import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt

lr = pd.read_csv("input/lr_pairs.tsv", sep="\\t")
top = lr.query("p_adj < 0.05").sort_values("score", ascending=False).head(30)

G = nx.DiGraph()
for _, r in top.iterrows():
    G.add_edge(r["source"], r["target"], weight=r["score"], label=f'{r["ligand"]}-{r["receptor"]}')

pos = nx.circular_layout(G)
weights = [G[u][v]["weight"] for u, v in G.edges()]
nx.draw_networkx_nodes(G, pos, node_size=900, node_color="#E5EEF8")
nx.draw_networkx_labels(G, pos, font_size=8)
nx.draw_networkx_edges(G, pos, width=[1 + w / max(weights) * 4 for w in weights], arrows=True)
plt.axis("off")
plt.savefig("outputs/fig4_communication_network.svg", bbox_inches="tight")
```

NC-style checks:

- Network only shows top interpretable interactions.
- Full LR matrix appears as heatmap or supplement.
- Edge width and node size encode documented quantities.

## Recipe 5: Trajectory / Velocity / State Transition

Use for: pseudotime, RNA velocity, chromatin-RNA relay dynamics, differentiation.

Input schema:

| File/Object | Required Fields |
|---|---|
| `adata_velocity.h5ad` | embedding, velocity vectors or pseudotime, cell_state |
| `gene_trends.tsv` | gene, pseudotime_bin, expression/smoothed_score |

Recommended packages:

- Python: `scvelo`, `dynamo`, `MoFlow`, `matplotlib`, `seaborn`
- R: `monocle3`, `slingshot`, `tradeSeq`, `ggplot2`

Reference code:

- MoFlow: `notebooks/fig2.ipynb` to `fig7.ipynb`
- MoFlow plotting helpers: `src/MoFlow/plot_cell.py`, `src/MoFlow/plot_gene.py`

NC-style checks:

- Direction arrows agree with state labels.
- Gene trend panel validates the direction.
- Avoid over-claiming causality from pseudotime alone.

## Recipe 6: Genome Track / Variant Effect

Use for: ATAC peaks, enhancer variants, pangenome loci, splicing/isoform panels.

Input schema:

| File | Required Fields |
|---|---|
| `tracks.bedgraph` / `bigwig` | genomic coordinates, signal |
| `features.bed` | gene/peak/variant coordinates |
| `delta.tsv` | variant/peak/gene, effect size, FDR |

Recommended packages:

- R: `Gviz`, `GenomicRanges`, `ggplot2`, `cicero`
- Python: `pyGenomeTracks`, `matplotlib`, `pandas`

Reference code:

- cPeaks: `Applications/plots.r`, `Applications/data*_*/analysis_WITHcPeaks.ipynb`
- CAST/GET/AlphaGenome references for track-style layout

NC-style checks:

- All tracks share the same genomic x-axis.
- Variant/effect panel placed below observed/predicted tracks.
- Use consistent strand/gene model conventions.

## Recipe 7: Benchmark Heatmap / Rank Plot

Use for: method comparison, public-data validation, sensitivity analysis.

Input schema:

| File | Required Columns |
|---|---|
| `benchmark_metrics.tsv` | method, dataset, metric, value |
| `example_cases.tsv` | dataset, method, case_id, figure_path optional |

Recommended packages:

- Python: `pandas`, `seaborn`, `matplotlib`, `scikit-learn`
- R: `ggplot2`, `ComplexHeatmap`, `ggpubr`

Reference code:

- SMART benchmark notebooks
- CellANOVA evaluation tutorials
- Novae benchmark configs

NC-style checks:

- Keep one primary metric per heatmap.
- Add average-rank panel if many datasets.
- Include one representative real-data panel.

## Recipe 8: Figure Assembly

Use for: assembling Figure 1-4 from already exported panels.

Recommended packages:

- R: `patchwork`, `cowplot`
- Python: `matplotlib.gridspec`
- Final polish: Illustrator, Inkscape, or Affinity Designer

R skeleton:

```r
library(patchwork)

p <- (panel_a | panel_b | panel_c) /
     (panel_d | panel_e | panel_f) +
     plot_annotation(tag_levels = "A")

ggsave("outputs/figure1_main.pdf", p, width = 11, height = 7)
```

NC-style checks:

- Panel labels are stable and readable.
- White space separates conceptual blocks.
- Each figure has one take-home sentence.
