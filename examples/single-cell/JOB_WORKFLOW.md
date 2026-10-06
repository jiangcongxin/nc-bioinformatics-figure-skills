# Single-cell task workflow

Install the local ncfigR and scfigR packages using the repository README. scfigR 0.3.0 is required. The agent reads the skill's [execution protocol](../../skills/nc-bioinformatics-figure-skills/references/single_cell_execution.md), prepares a task, runs a fixed tool, and reviews its outputs.

## Run

For the stable CLI release, use `Rscript scripts/install_runtime.R` followed by
`Rscript scripts/check_runtime.R`. Entry points enforce `runtime-lock.tsv` (ncfigR
0.2.1 and scfigR 0.3.1), using the project-local library when present. The installer
requires dependencies to be available already and does not upgrade them.

From the repository root:

```sh
Rscript scripts/run_sc_job.R --job examples/single-cell/task-demo.json
```

The six-cell example is synthetic. A correct run exits **2**, with `status: "needs_review"`. This is intentional: technical success is not visual approval. The one-line JSON response gives the exact `run_dir` and `report_path`.

For real data, copy the task JSON outside the example directory and update the input paths, expression scale, provenance and user-approved parameters. CSV/TSV inputs follow the [single-cell data contracts](README.md). Every run creates a unique attempt directory; it never overwrites source data or previous attempts. An optional `--output` argument overrides the output root. Relative paths are resolved from the task JSON, not the current terminal directory.

| Status | Exit | Meaning |
|---|---|---|
| `failed` | 1 | Read structured errors; no result may be approved |
| `needs_review` | 2 | Data and rendering checks completed; actual visual inspection is required |
| `revise` | 2 | Reviewer identified issues; preserve this attempt and rerun after correction |
| `passed` | 0 | Submitted visual review passed the protocol; not a journal-quality certification |

## Outputs

For the real PBMC3k example, prepare the source tables once and submit the task through the same entry point:

```sh
Rscript examples/single-cell/run_pbmc3k.R
Rscript scripts/run_sc_job.R --job examples/single-cell/task-pbmc3k.json
```

The preparation script downloads and verifies the SeuratData archive. The task retains its existing embedding and annotations; the dataset attribution and expression scale are recorded in the report. This is a single-sample descriptive workflow, not a new raw-data analysis.

Optional `figure.marker_groups` is an object of named gene arrays. It must assign
every selected gene exactly once; it does not select or discard genes. Group order
sets display order. If `feature_order` is also provided, it must match flattened
group order. Example: `{"Group A": ["CD3D", "MS4A1"], "Group B": ["LYZ"]}`
for the three-gene synthetic task. Names describe user-supplied display groups,
not inferred biological programs.

scfigR 0.3.1 exports `source-data/marker-plot-data.tsv` alongside the unmodified
summaries: the plotting table includes grouping and pre-clipping color values.
Both atlas composition functions and `plot_marker_dotplot_panel()` support
`data.out = TRUE`, returning `list(plot, data)`; default plot returns are unchanged.

`report.json` contains stage, status, errors/actions, checks, warnings, summary, figure dimensions, artifact paths and checksums. `report.md` is the readable counterpart. Each successful run preserves source tables and palette, original/resolved tasks, methods, reproduction code, session information and PDF/SVG/PNG.

The pipeline computes sample-level cell fractions and pooled cell-type marker summaries. It does not infer annotations, test differential expression, or treat cells as biological replicates. Single-sample and small-category notes require consideration during review. Expression scale and provenance are mandatory; there is no silent conversion from scaled expression or percentages.

v1 resource limits: 100 MiB per source table, 200,000 cells, 2,000,000 expression rows, 40 cell types, 200 samples and 100 selected genes. Oversized tasks stop with an actionable error; the runtime never silently subsamples or removes genes. These limits bound execution, not readability: dense plots still require visual revision or a different figure plan.

## Review and correction

Inspect this run's PNG plus PDF or SVG at the reported dimensions. Create `review.json` with the exact `run_id`, a reviewer identifier, inspected relative artifact paths, final width/height, and all six evidence-backed checks defined in the [execution protocol](../../skills/nc-bioinformatics-figure-skills/references/single_cell_execution.md). Do not copy a canned all-pass review: the observations must refer to the actual outputs.

```sh
Rscript scripts/review_sc_job.R --run /absolute/path/to/run --review /absolute/path/review.json
```

Any check marked `revise` keeps the run unapproved. The agent may fix supported presentation parameters and create a new task attempt. Data changes, expression transforms, annotation, marker selection and detection thresholds require confirmation. The review tool checks file hashes and payload completeness; visual inspection is self-reported, not independently authenticated or automated by a text model.

For version-checked reproduction, run the fixed entry point with the frozen task:

```sh
Rscript scripts/run_sc_job.R --job /absolute/path/to/run/resolved_job.json
```

The new result again requires review. The generated `reproduce.R` is a direct R
API alternative requiring the packages on R's library path; it bypasses the CLI
version gate. Matching software versions is part of reproducibility. MD5 records
detect ordinary file changes but are not tamper-proof attestations.
