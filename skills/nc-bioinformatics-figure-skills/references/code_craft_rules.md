# Code Craft Rules

Purpose: learn from high-quality GitHub figure repositories until the user can write comparable project-local plotting code. This does not mean copying paper code. It means extracting engineering patterns and rewriting them as reusable, tested functions.

## What High-Quality Figure Code Has

| Dimension | Expected Standard |
|---|---|
| input contract | each panel declares required columns or object fields |
| function boundary | plot functions take data and options, not hidden global variables |
| palette control | colors are loaded from reusable palette files |
| source data | each panel can be redrawn from saved tables or documented objects |
| export discipline | vector output first, PNG preview second |
| composition | panel assembly is separated from panel generation |
| QA | figure plan, source manifest, and visual checks live beside scripts |

## Code Craft Workflow

1. Pick one A1/A2 repo pattern from `code_recipe_cards.md`.
2. Extract the input schema, panel role, package stack, and export convention.
3. Rewrite the idea as an `ncfigR` function or function call.
4. Test first on toy source-data tables.
5. Transfer to the user's project tables.
6. Run visual QA before treating the figure as manuscript-ready.

## Function Design Rules

- Prefer `data` plus explicit column-name parameters.
- Never read project files inside low-level plot functions.
- Never hard-code disease, cell type, or sample labels.
- Keep plot functions returning ggplot/patchwork objects.
- Keep exporting in `export_figure_bundle()`, not inside panel functions.
- Make optional Seurat handling an adapter step via `as_panel_data()`.

## Review Checklist For User-Written Code

Score each item as `pass`, `revise`, or `missing`:

| Item | Pass Condition |
|---|---|
| source-data interface | function can run on TSV/data.frame without hidden state |
| package boundary | imports are explicit and minimal |
| palette handling | palette is passed in or read from a file |
| panel role | plot title and function match one figure-panel role |
| composability | panel can be combined with patchwork/cowplot |
| export | PDF/SVG/PNG are generated with stable dimensions |
| reproducibility | toy data and at least one test exist |
| manuscript safety | code does not encode unsupported biological claims |

## Mapping Repo Patterns To ncfigR

| Repo Pattern | ncfigR Rewrite |
|---|---|
| scPRINT nice UMAP helper | `plot_embedding_panel()` plus fixed palette |
| FastCCC report heatmap/network | `plot_lr_heatmap()` + `plot_lr_network()` |
| MoFlow cell/gene plots | `plot_embedding_panel()` + `plot_trajectory_trend()` |
| CellMentor RMarkdown figures | `compose_nc_figure()` plus source-data panels |
| Panpipes pipeline plots | source-data scripts plus reusable panel functions |
| scHolography spatial/niche maps | coordinate table + composition/heatmap panels |
| cPeaks benchmark/genome panels | `plot_benchmark_heatmap()` and explicit genomic source tables |

## Do Not Do This

- Do not vendor or paste full paper scripts into user projects.
- Do not build one giant notebook that mixes preprocessing, plotting, export, and interpretation.
- Do not make every parameter configurable when a stable project convention is better.
- Do not hide palette or source-data decisions inside a single script.
