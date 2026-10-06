---
name: nc-bioinformatics-figure-skills
description: Plot and review existing single-cell results using ncfigR, scfigR and commfigR. Use for annotated embeddings, cell composition, marker expression, gene-expression maps, atlas figures or exported cell-cell communication results with traceable source data and checks. Focus on existing results, not raw-matrix analysis or general literature learning.
metadata:
  version: "2.3.0"
allowed-tools: Read, Write, Edit, Grep, Glob, WebSearch, Bash
---

# Single-Cell Figure Agent

Turn existing single-cell results into checked, reproducible figures. The Agent
plans the presentation, calls the R execution layer, inspects its outputs, and
makes bounded corrections. Answer in Chinese unless the user asks otherwise.

## Scope

The stable task is `single_cell_atlas`: annotated embedding, sample-level cell
composition, marker dot plot, and optional three gene-expression maps. Inputs
are source tables or existing Seurat results exported through the documented
adapter. Keep the supplied annotations and embedding.

For existing cell-cell communication results, load only
[the communication execution protocol](references/communication_execution.md).
The `communication_overview` task accepts canonical or exported CellChat tables;
use `run_comm_job.R` and `review_comm_job.R`, not the atlas runner. It preserves
upstream inference and summarizes scores separately by condition. Differential
panels remain direct APIs, outside this stable task.

Do not run raw-matrix QC, normalization, clustering, annotation inference or
differential expression under this workflow. Direct module-score or other panel
functions require their documented inputs; they are not additional stable task
types. Never claim NC-level quality from technical success alone.

## Default Workflow

Read [the execution protocol](references/single_cell_execution.md) for every
atlas execution. It defines input contracts, status handling, visual review,
correction limits and frozen-input reproduction.

1. Resolve the repository root containing the runtime scripts. Check the runtime
   with `scripts/check_runtime.R`; respect `runtime-lock.tsv` (ncfigR 0.2.2,
   scfigR 0.3.1 and commfigR 0.2.0). A skill-only installation is not a working R runtime. Stop with
   setup instructions if unavailable; do not install or change the lock silently.
2. Inspect source headers and provenance. Confirm cell IDs, annotation/sample
   columns, selected genes, expression scale and intended descriptive claim.
   Read [scfigR API](references/scfigR_api.md) for panel contracts and
   [ncfigR API](references/ncfigR_api.md) only when adapters or export details are needed.
3. Prepare a task JSON without changing scientific inputs. Preserve explicit
   zero-expression rows. Display groups must contain the approved genes exactly
   once; they do not imply biological programs.
4. Invoke `scripts/run_sc_job.R --job <task.json>`. Capture its JSON result and
   exit status, and use the exact returned paths. Read reports, methods, source
   tables and marker plotting values before inspecting the figure.
5. Inspect this run's PNG plus PDF or SVG at the declared final size. Review
   legibility, overlap, legend consistency, layout, color semantics and claim
   boundaries. Submit concrete observations through `scripts/review_sc_job.R`;
   never fabricate a pass when an artifact could not be inspected.
6. Correct supported presentation parameters in a new attempt. Preserve source
   data and prior attempts. Scientific changes require confirmation; stop after
   two automatic correction attempts. Deliver results or state unresolved issues.

A rendering success remains `needs_review`. Failed runs are not deliverable;
`revise` requires a new attempt. A `passed` review is self-reported inspection,
not independent biological or journal certification.

## Deliverables

Give the figure preview and links to vector artwork, readable checks and methods.
Include source-data and reproduction locations when useful. State sample/rare-cell
limitations and unresolved issues. Do not replace a requested run with a tutorial,
a paper list, or a proposed figure plan.

## Optional Modules

Do not preload these modules or their inventories for an ordinary atlas task.
Load only the module matching an explicit additional request:

- [Figure planning](references/optional_figure_planning.md): main/supplement panel
  decisions, manuscript figure plans, plotting scaffolds or package design.
- [Paper and code learning](references/optional_paper_code_learning.md): named
  papers/repos, source-code inspection, learning exercises or code mining.
- [Other plotting domains](references/optional_other_domains.md): spatial,
  trajectory, benchmarks, multi-omics and related visualizations.
  Verify implementations separately; the atlas task runner does not support them.

These modules extend a requested task; they do not change the default single-cell
execution scope or authorize data transformations, external publication or GitHub pushes.
