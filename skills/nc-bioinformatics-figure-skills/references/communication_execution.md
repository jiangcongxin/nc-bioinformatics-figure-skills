# Existing Communication Results

Use this module for `communication_overview`, not raw expression or new
CellChat/CellPhoneDB/NicheNet inference. The locked runtime is ncfigR 0.3.0,
scfigR 0.4.0 and commfigR 0.3.0. Check `scripts/check_runtime.R` first.

## Inputs and Decisions

Canonical CSV/TSV requires `source,target,ligand,receptor,score`; optional
`condition,p_value`. Keys are unique per condition/source/target/ligand/receptor.
Scores must be finite and non-negative; p-values, when supplied, lie in [0,1].
Preserve leading-zero labels and receptor complexes. No automatic key merging.

CellChat CSV/TSV requires `source,target,ligand,receptor,prob,pval`; set format
`cellchat` and an explicit condition label. The adapter retains extra columns.
For multiple conditions adapt each table separately and concatenate canonical
results. An object-to-table export is a separate explicit step needing CellChat;
normal task execution needs neither CellChat nor serialized objects.

Confirm provenance, score definition, upstream p-value definition, export
thresholds and whether upstream settings are compatible across conditions.
Do not relabel CellChat model/permutation p-values as adjusted donor-level
tests. If definitions are unknown, ask; do not fabricate them.

Limits: 100 MiB per table, 500,000 rows, 30 types, 4 conditions. Default size is
183 x 220 mm. Dense comparisons may require a larger final size or a separately
confirmed biological subset; never silently discard conditions or data.

## Execute and Inspect

1. Prepare schema 1.0 task JSON; see `examples/communication/task-example.json`.
   Declare optional `analysis.p_max` explicitly; null means no additional filter.
   `figure.top_n`, `max_pairs` and `network_top_n` are presentation limits only.
2. Run `Rscript scripts/run_comm_job.R --job <task.json>`. Exit 1 means failed,
   exit 2 means needs_review. Capture the exact returned directory.
3. Read `report.json`, `report.md`, `methods.md` and source tables before viewing
   artwork. `edges.tsv` and `totals.tsv` sum retained scores separately by
   condition. `display.tsv` is the exact LR dot-plot input; `rank.tsv` and
   `pair_rank.tsv` document pooled display ranking; `network_edges.tsv` records
   the displayed top edges per condition. Summaries use all retained rows.
4. Inspect PNG plus PDF or SVG at the declared physical size. Check text,
   overlap, guides, layout, scale semantics and claim boundaries. Common limits
   must hold across conditions. Missing/unexported interactions are absent,
   not assumed zero. Blank matrix positions are not demonstrated no-signaling.
5. Submit six pass/revise checks with concrete observations through
   `scripts/review_comm_job.R --run <directory> --review <review.json>`.
   Use the same review schema as the atlas workflow. Never submit a fabricated
   inspection. Checksums, run ID, task type and dimensions must match.
6. A revise decision needs a new attempt; at most two automatic presentation
   corrections. Changing filters, scores, conditions, statistical design or
   biological subsets requires user confirmation.

Passed records self-reported review, not independent authentication or
publication/biological certification. Do not infer differential significance
from descriptive score differences. Deliver vector artwork, preview, checks,
methods and frozen reproduction configuration. Use the locked CLI with
`--job <run>/resolved_job.json` to reproduce. Direct R API reproduction needs
the correct installed package library and does not enforce the CLI lock.
