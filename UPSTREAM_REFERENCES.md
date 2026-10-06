# Design references

The 0.2.1 ncfigR / 0.3.1 scfigR update uses existing package APIs and independently
written adapters. No third-party source functions were copied or vendored.

## patchwork

- Repository: https://github.com/thomasp85/patchwork
- Layout guide: https://patchwork.data-imaginist.com/articles/guides/layout.html
- Declared license: MIT + LICENSE.
- Applied ideas: explicit layout design, guide collection, dedicated guide area,
  and keeping marker guides local. ncfigR calls the installed patchwork package;
  it does not reimplement its layout engine.
- Fixed-aspect embeddings retain equal coordinate scaling. Layout improvements
  must not stretch embeddings just to fill a panel.

## dittoSeq

- Repository: https://github.com/dtm2451/dittoSeq
- Reference: https://github.com/dtm2451/dittoSeq/blob/devel/R/dittoDotPlot.R
- Declared license: MIT + LICENSE.
- Applied ideas: named groups of marker genes, explicit ordering, optional access
  to plot source data. Our return shape is `list(plot, data)`.
- Deliberate difference: scfigR means include every supplied cell, including zero
  expression. dittoDotPlot documents a default non-zero mean. We do not import
  that default or switch calculation definitions when borrowing interface ideas.
- Group labels are user-supplied presentation annotations, not cell-type inference.

References inspected on 2026-10-06. These are design references, not claims of
upstream endorsement or journal-quality certification. Any future copied code
must record the exact source revision and retain its applicable license notices.
