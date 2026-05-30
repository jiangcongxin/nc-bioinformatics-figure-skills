# Figure Decision Engine

Purpose: convert a user's project results into an NC-style figure decision, before code is written. This is a decision layer, not an automatic scientific-claim generator.

## Required Intake

| Field | Examples | Why It Matters |
|---|---|---|
| project_type | scRNA, spatial, scRNA+spatial, public-data multi-omics, benchmark | Selects the figure template family. |
| core_claim | "Disease X expands inflammatory fibroblast state in lesion tissue." | Determines what belongs in main figures. |
| available_outputs | metadata, UMAP, marker table, cell fraction, module scores, spatial domains, LR table, trajectory, benchmark, validation | Determines which panels are executable now. |
| target_figure | Figure 1 overview, mechanism figure, validation figure, supplement QC | Controls panel budget and detail level. |
| preferred_stack | R, Python, both, unknown | Controls starter scripts and GitHub code sources. |

If a field is missing, infer conservatively and mark it as an assumption.

## Decision Output Schema

Always return these sections for project figure decisions:

1. `Claim`: one sentence, rewritten conservatively.
2. `Recommended template`: one Figure-level template from `nc_sc_spatial_figure_templates.md`.
3. `Main figure panel table`: panel ID, role, plot type, input object/table, package, code asset, keep/drop.
4. `Supplement moves`: panels that should move out of the main figure.
5. `Missing evidence`: results needed before a panel can support the claim.
6. `Palette and layout rules`: stable color mappings and panel hierarchy.
7. `Next action`: either scaffold, QA, or code-learning route.

## Template Selection Rules

| Project Signal | Recommended Template |
|---|---|
| first atlas overview, cell-type discovery, public scRNA integration | Atlas Overview Figure |
| disease/control or lesion/normal cell-state shift | Disease vs Control Cell-State Figure |
| tissue domains, tumor microenvironment, spatial niches | Spatial Tissue Niche Figure |
| programs, modules, signatures, pathways | Cell-State Program Figure |
| differentiation, activation, developmental time, velocity | Trajectory Figure |
| ligand-receptor, sender/receiver, niche signaling | Cell-Cell Communication Figure |
| multiple slides, alignment, query-reference spatial comparison | Spatial Multi-Sample Comparison Figure |
| therapy, timepoint, dose, perturbation, response | Treatment / Condition Response Figure |
| annotation transfer, new population, marker validation | Annotation / Marker Validation Figure |
| method/model comparison | Benchmark + Biological Case Figure |
| filters, metrics, full marker lists, batch checks | Supplement QC Figure |
| user asks how to arrange 6-8 panels | NC Panel Hierarchy Figure |

## Main-Vs-Supplement Decision

Keep in main figure when the panel supports one of these:

| Evidence Role | Keep If | Example |
|---|---|---|
| Context | It defines cohort/data/tissue quickly. | sample summary, compact workflow |
| Anchor map | It shows the main biological structure. | UMAP, spatial map, trajectory |
| Quantification | It proves the observed contrast. | fraction bar, score violin |
| Mechanism | It explains the contrast. | module heatmap, LR heatmap, gene trend |
| Validation | It tests generalization or a representative case. | external cohort, second slide, case zoom |

Move to supplement when:

- It is QC, filtering, doublet, mitochondrial, or parameter evidence.
- It is all genes/all pathways/all LR pairs/all metrics.
- It repeats the same map with only a cosmetic difference.
- It is a weak exploratory result not needed for the main claim.
- It needs private or unavailable source data to redraw.

## Panel Priority Score

Use this 0-2 scoring internally and explain only the conclusion:

| Criterion | 0 | 1 | 2 |
|---|---|---|---|
| claim relevance | decorative or unrelated | related but not essential | necessary for the claim |
| data readiness | missing/unverified | partial table/object exists | source data object/table exists |
| interpretability | hard to read | readable with revision | immediately interpretable |
| code learnability | no code source | A2/A3 code source | A1 code source |
| template fit | does not fit selected template | fits with modification | canonical panel for template |

Default decisions:

- `keep`: score 8-10.
- `revise or move to supplement`: score 5-7.
- `drop`: score 0-4.

## Plot Type Decision Matrix

| Input Data | Plot Type | Avoid |
|---|---|---|
| `cells x embedding` with `cell_type`, `group`, `score` | UMAP split or repeated coloring | changing coordinates between panels |
| `cell_type x marker` | dotplot or compact heatmap | full marker table in main figure |
| `sample x cell_type x proportion` | stacked/fraction bar, composition dotplot | pie charts for many cell types |
| `sample/cell_type x module score` | annotation heatmap or grouped violin | clustering columns when biology order matters |
| `spatial coordinates + image/domain` | tissue map, domain map, overlay, zoom | inconsistent aspect ratio |
| `source-target-ligand-receptor` | LR heatmap + filtered network | dense network alone |
| `pseudotime + gene expression` | trajectory map + gene trend | direction without stage/marker support |
| `method x dataset x metric` | benchmark heatmap + rank plot | only average bar without raw matrix |

## Code Asset Matching

Prefer A1 for direct replication, A2 for structure, A3 for concept only.

| Need | First Repositories |
|---|---|
| Atlas / UMAP | scPRINT, Panpipes, CellMentor, scFoundation |
| Spatial niche | scHolography, NEP_comparison, Sopa, FineST, NiCo, Tumor-cell-villages |
| Communication | FastCCC, Human_endometrium, FineST, NiCo |
| Trajectory | MoFlow, ddHodge_figures, ILC-NK-HIPEC, Human_endometrium |
| Treatment response | Figueroa_etal_2026, Human_endometrium |
| Benchmark | NEP_comparison, cPeaks, scFoundation, SMART, CellANOVA |

## Example Decision Output

Use this compact form:

```text
Claim: ...
Recommended template: ...

Main figure:
A | context | dataset table/workflow | metadata.tsv | ggplot2/matplotlib | keep
B | anchor | UMAP by cell type | object.h5ad | scanpy | keep
C | quantification | cell fraction by group | cell_metadata.tsv | ggplot2 | keep
D | mechanism | module heatmap | module_scores.tsv | pheatmap/seaborn | keep
E | validation | second dataset score | validation_scores.tsv | seaborn | keep if available

Move to supplement:
- QC violin
- all markers
- parameter sensitivity

Missing evidence:
- validation cohort is not yet present

Learn from:
- A1 Panpipes ...
- A1 scPRINT ...
```
