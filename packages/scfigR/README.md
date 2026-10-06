# scfigR

Version 0.3.1 adds explicit six-panel layout, named marker display groups and
`data.out = TRUE` for plot/source-data returns. Jobs also export the marker
plotting table, retaining zero-inclusive means and detection fractions.
See [design references](../../UPSTREAM_REFERENCES.md).

Version 0.3.0 adds a structured execution layer for skills: `run_sc_job()` returns figures and a report; `review_sc_job()` records evidence-backed visual review. Technical success stops at `needs_review`. See the [task workflow](../../examples/single-cell/JOB_WORKFLOW.md).

Build single-cell atlas figures from exported tables: an embedding, cell fractions, marker expression, and optional module scores.

```r
library(scfigR)
data <- load_sc_example()
figure <- do.call(compose_sc_atlas_figure, data)
figure
ncfigR::export_figure_bundle(figure, "atlas", width = 9, height = 7)
```

For cell-level input, `prepare_sc_atlas_data(embedding, expression)` calculates sample-level fractions and marker summaries. Cell IDs must match, and expression needs every cell/gene pair including zeros. Detection fractions use `[0,1]`; missing rows are not treated as zeros.

The composite keeps cell-type colors and order consistent. The bundled data are synthetic. See the [single-cell guide](../../examples/single-cell/README.md) for the real PBMC3k example and the table formats.
