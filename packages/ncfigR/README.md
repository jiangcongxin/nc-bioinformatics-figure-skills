# ncfigR

Shared R tools for source-data figures: embeddings, composition bars, heatmaps, panel layouts, and PDF/SVG/PNG export.

```r
library(ncfigR)
p <- plot_embedding_panel(embedding, palette = c(T = "#0072B2", B = "#E69F00"))
export_figure_bundle(p, "embedding", out_dir = "figures", width = 5, height = 4)
```

`embedding` needs numeric `x,y` and a `cell_type` column. Tables are checked before plotting. Named palettes require valid colors and complete category coverage. Use `category_order` to control order, and `compose_nc_figure()` to arrange panels with automatic or custom labels.

Exports include a session record. Supply `source_manifest` to retain input paths/checksums alongside the figure. A failed render preserves an existing bundle and closes its graphics device.

See the repository's [single-cell guide](../../examples/single-cell/README.md) for installation, data contracts, and complete examples.
