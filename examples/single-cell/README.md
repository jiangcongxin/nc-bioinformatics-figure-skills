# Single-cell figures

## Quick start

Install `ncfigR` and `scfigR` using the commands in the repository README, then run:

```sh
Rscript examples/single-cell/run_example.R
```

The synthetic example writes PDF, SVG, PNG, source provenance, and session information to `examples/single-cell/output/`. It is a format demonstration, not a biological result.

## Your own tables

`prepare_sc_atlas_data()` accepts two data frames:

| Table | Required columns | Contract |
|---|---|---|
| Embedding | `cell_id,x,y,cell_type,sample` | One row per cell; finite numeric coordinates; unique cell IDs |
| Expression | `cell_id,feature,value` | One row per cell/gene pair, including zeros; finite numeric expression |

The cell IDs must match exactly. Select a small marker set before exporting expression. Missing records are not interpreted as zero; incomplete tables are rejected. Use counts or log-normalized values for detection, rather than centered/scaled values. With the default threshold, a cell is positive when `value > 0`.

```r
embedding <- readr::read_tsv("embedding.tsv", show_col_types = FALSE)
expression <- readr::read_tsv("expression.tsv", show_col_types = FALSE)
data <- prepare_sc_atlas_data(embedding, expression)
figure <- compose_sc_atlas_figure(
  data$embedding, data$composition, data$markers,
  cell_type_order = c("T", "B", "Myeloid"),
  feature_order = c("LYZ", "MS4A1", "CD3D")
)
export_figure_bundle(figure, "my_atlas", out_dir = "figures", width = 9, height = 7)
```

Replace the example category and gene lists with values present in your tables. Omit the order arguments to retain factor levels or first appearance. One named palette is shared across the atlas panels; for example `c(T = "#0072B2", B = "#E69F00", Myeloid = "#009E73")`.

Cell fractions are computed separately for each sample, including zero-count categories. Marker means and positive fractions pool cells of each cell type; the returned marker table records `n_cells`. These are descriptive summaries, not differential expression tests. For comparisons across donors, retain sample-level summaries and use an appropriate replicate-aware analysis upstream.

## Already summarized data

Pass these tables directly to `compose_sc_atlas_figure()`:

| Argument | Columns |
|---|---|
| `embedding` | `x,y,cell_type` |
| `composition` | `group,cell_type,proportion` |
| `markers` | `feature,cell_type,avg_expression,pct_expression` |
| `module_scores` (optional) | `x,y,score` |

All three required tables must use the same cell-type categories. Composition values are fractions in `[0,1]`, with one row per sample/cell-type pair, summing to one per sample. Marker detection values also use `[0,1]`, not `[0,100]`. There must be one marker row per gene/cell-type pair. Numeric values must be finite and required labels cannot be missing or blank.

For a subset of cell types, use `plot_cell_fraction_panel(..., position = "stack")`; fill bars deliberately reject incomplete proportions. For count bars, use `ncfigR::plot_composition_panel(..., value_type = "count", value_col = "n", position = "stack")`.

## Seurat objects

```r
embedding <- ncfigR::as_panel_data(object, "embedding", reduction = "umap")
expression <- ncfigR::as_panel_data(object, "expression",
  features = c("CD3D", "MS4A1", "LYZ"), assay = "RNA", layer = "data")
```

Assign `cell_type` and `sample` in the embedding table before preparation. `SeuratObject` is optional and must be installed for these adapters. Unknown genes produce an error. For split Seurat v5 layers, join the relevant layers before extraction. Expression extraction densifies only the requested genes: do not request the entire assay.

## PBMC3k real-data example

```r
install.packages("SeuratObject")
```

```sh
Rscript examples/single-cell/run_pbmc3k.R
```

The script downloads the approximately 90 MB `pbmc3k.SeuratData_3.1.4.tar.gz` archive from [Satija Lab's dataset server](https://seurat.nygenome.org/src/contrib/pbmc3k.SeuratData_3.1.4.tar.gz), verifies its checksum, and loads `pbmc3k.final`. Background: [Seurat's PBMC3k tutorial](https://satijalab.org/seurat/articles/pbmc3k_tutorial) and [SeuratData](https://github.com/satijalab/seurat-data).

Verified example: 2,638 cells and nine annotated cell types. It retains the dataset's existing UMAP and identities and summarizes nine specified genes from the RNA `data` layer. Existing labels are not independently revalidated. Mean expression is the arithmetic mean of the supplied log-normalized values, not a mean on the raw-count scale. There is one sample, so the composition panel is descriptive rather than a donor comparison.

Output in `examples/single-cell/pbmc3k-output/` includes the figure, exported source tables, table checksums, dataset URL/archive checksum, calculation notes, and R session information. The cache and generated outputs are ignored by Git. Some SeuratObject versions print object-upgrade notices when loading this older object.

The real-data example uses `compose_sc_publication_figure()` at 183 x 126 mm. Panels a-c show cell identities, abundance, and marker expression; d-f show CD3D, MS4A1, and LYZ on the same UMAP with one common raw log-expression color scale. Dot colors are per-gene z-scores of cell-type means (sample standard deviation, constant genes mapped to zero), with display values clipped to [-2,2]. Dot area remains the fraction of expressing cells. This transformation improves within-gene comparisons; it does not make expression levels comparable between genes. Use `marker_scale = "raw"` to retain supplied means.

The preset uses lower-case bold panel tags, 7-point base text, no overall title by default, and a compact layout. These are presentation defaults, not a journal-quality certificate. Inspect exported vector artwork at final size, verify labels and scales, and assess the biological evidence separately. Guidelines: [Nature Communications](https://www.nature.com/ncomms/submit/how-to-submit); [Nature artwork sizing and typography](https://www.nature.com/nature/for-authors/final-submission) is a separate reference, not an NC-specific size requirement.

Dataset attribution: Satija Lab, PBMC3k data from 10x Genomics, distributed as `pbmc3k.SeuratData` 3.1.4 under **CC BY 4.0**, according to the archive's DESCRIPTION. The README preview is a derived visualization under the same attribution/license. Code in this repository remains MIT; the original dataset is not bundled here.

## Export behavior

`export_figure_bundle()` renders all formats before replacing existing files. A rendering error closes its graphics device and leaves a previous bundle unchanged. Use `overwrite = FALSE` to reject existing output paths. Width and height are in inches. Custom panel tags can be supplied with `labels = c("a", "b", "c")`; use `labels = NULL` to suppress them.

Optional provenance:

```r
manifest <- data.frame(
  file = c("embedding.tsv", "expression.tsv"),
  md5 = unname(tools::md5sum(c("embedding.tsv", "expression.tsv")))
)
export_figure_bundle(figure, "atlas", source_manifest = manifest)
```
