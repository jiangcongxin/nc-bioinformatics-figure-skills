# Existing communication results

From the repository root, install the locked runtime and run the synthetic task:

```sh
Rscript scripts/install_runtime.R
Rscript scripts/check_runtime.R
Rscript scripts/run_comm_job.R --job examples/communication/task-example.json
```

Rendering success exits 2 (`needs_review`). Exit 1 means failure, not success.
Read the returned report, methods and source tables before reviewing artwork.

## Your results

Export CSV/TSV with `source,target,ligand,receptor,score`; optional
`condition,p_value`. Confirm the score definition and upstream p-value meaning.
Use the example JSON as a template. Paths are relative to that JSON, not the
shell working directory. `analysis.p_max=null` adds no filter.

For a `CellChat::subsetCommunication()` export, use `format=cellchat` with an
explicit condition. The adapter preserves prob, pval, receptor complexes and
extra columns. Combine multiple adapted tables for multi-condition tasks.
The task runner never loads RDS or runs inference.

Four panels show sender/receiver score sums, incoming/outgoing sums, selected
LR rows and directed networks. All summaries separate conditions. Dot plots
intersect top LR and top cell pairs ranked by pooled score sum; networks select
top edges per condition. Display limits do not change heatmap/totals. Exact
selection tables are exported. Missing interactions are absent, not measured
zero. Upstream settings/coverage must be comparable before interpreting sums.

## Public human-skin example

The existing CellChat objects are published by Suoqin Jin (2023),
[doi:10.6084/m9.figshare.24516340.v1](https://doi.org/10.6084/m9.figshare.24516340.v1),
CC BY 4.0. LS denotes lesional and NL non-lesional skin. These are existing
inference results, not a new analysis or donor-level condition test.

The export step requires CellChat installed explicitly. It downloads the two
objects with fixed MD5 checks, then calls `subsetCommunication(thresh=0.05)`
(upstream pval < 0.05). It does not recompute communication. The downloaded
objects and extracted tables stay in ignored `cache/`.

```sh
Rscript examples/communication/prepare_human_skin.R
Rscript scripts/run_comm_job.R --job examples/communication/task-human-skin.json
```

The tested export contains 556 interactions, 12 cell types and two conditions.
The methods record states the upstream export threshold separately from any
additional task filter. Keep the attribution with derived figures.

## Review and reproduce

Inspect the PNG plus PDF or SVG at the configured physical size. Submit JSON:

```json
{
  "schema_version": "1.0",
  "run_id": "COPY_THE_RETURNED_RUN_ID",
  "reviewer": "REVIEWER",
  "inspected_artifacts": ["figures/png/communication.png", "figures/pdf/communication.pdf"],
  "final_size_mm": {"width": 183, "height": 220},
  "checks": {
    "text_legibility": {"status": "revise", "evidence": "Record a concrete observation after inspection."},
    "label_overlap": {"status": "revise", "evidence": "Record a concrete observation after inspection."},
    "legend_consistency": {"status": "revise", "evidence": "Record a concrete observation after inspection."},
    "panel_layout": {"status": "revise", "evidence": "Record a concrete observation after inspection."},
    "color_scale": {"status": "revise", "evidence": "Record a concrete observation after inspection."},
    "biological_claims": {"status": "revise", "evidence": "Record a concrete observation after inspection."}
  }
}
```

The example is not a completed review. Replace ID, dimensions and evidence;
set pass only for checks actually inspected. At least one vector file must be
inspected. Review is self-reported, not authenticated or journal certification.

```sh
Rscript scripts/review_comm_job.R --run /absolute/run --review /absolute/review.json
Rscript scripts/run_comm_job.R --job /absolute/run/resolved_job.json
```

Passed exits 0; revise exits 2 and requires a new attempt. Frozen artifacts
cannot be edited and then approved. Keep earlier attempts and obtain user
confirmation before changing scientific inputs or filters.
