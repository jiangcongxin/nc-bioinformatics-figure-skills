<p align="center">
  <img src="assets/project-banner.svg" alt="NC Bioinformatics Figure Skills banner" width="100%">
</p>

<h1 align="center">NC Bioinformatics Figure Skills</h1>

<p align="center">
  <strong>A single-cell figure workflow for Codex, backed by tested R tools.</strong>
</p>

<p align="center">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-111827.svg"></a>
  <img alt="ncfigR" src="https://img.shields.io/badge/ncfigR-0.3.0-2563eb.svg">
  <img alt="scfigR" src="https://img.shields.io/badge/scfigR-0.4.0-0f766e.svg">
  <img alt="commfigR" src="https://img.shields.io/badge/commfigR-0.3.0-477d72.svg">
  <img alt="spfigR" src="https://img.shields.io/badge/spfigR-0.2.2-5479a5.svg">
</p>

## What this project is for

Give the Codex skill existing single-cell tables and a figure task. The skill calls a fixed R entry point, reads the checks, inspects the outputs, and requests corrections when needed. `ncfigR` handles shared plotting and export; `scfigR` prepares atlas panels and records each task attempt. The first workflow produces descriptive atlas figures; statistical analysis engines are a later step.

Skill 2.5 keeps the atlas workflow as the default, with communication tasks through
`commfigR` and section-aware spatial tasks through `spfigR`. Figure planning,
paper/code learning and other plotting domains are preserved as on-demand modules,
not loaded for an ordinary atlas task. See the [skill entry point](skills/nc-bioinformatics-figure-skills/SKILL.md).

## Figure Styles

Use `color_style = "balanced"`, `"muted"`, `"vivid"` or `"okabe_ito"` in composite
plot calls, or set `figure.color_style` in atlas and communication task JSON.
Named custom palettes take precedence. Expression, signed scores and categories
have separate scales; switching styles does not change input values or filters.
Okabe-Ito supports at most nine categories, so the full 12-type human-skin example
uses the three HCL styles. Large categorical palettes still require visual review.

![PBMC3k styles](assets/single-cell-color-comparison.png)

Generate the same-data comparisons with `Rscript examples/compare_package_styles.R`
after preparing the PBMC3k and human-skin example tables. The three prototype
packages (`trajfigR`, `benchfigR`, `multiomfigR`) also accept `color_style`, but do
not yet provide the checked task/review workflow of the stable runtime.

## Install

Requires R 4.1 or later. From the repository root:

```sh
git clone https://github.com/jiangcongxin/nc-bioinformatics-figure-skills.git
cd nc-bioinformatics-figure-skills
```

```r
install.packages("remotes")
remotes::install_local("packages/ncfigR", dependencies = NA, upgrade = "never")
remotes::install_local("packages/scfigR", dependencies = NA, upgrade = "never")
remotes::install_local("packages/commfigR", dependencies = NA, upgrade = "never")
remotes::install_local("packages/spfigR", dependencies = NA, upgrade = "never")
```

For a project-local stable runtime, then run:

```sh
Rscript scripts/install_runtime.R
Rscript scripts/check_runtime.R
```

The installer places `ncfigR 0.3.0`, `scfigR 0.4.0`, `commfigR 0.3.0` and `spfigR 0.2.2` in `.r-library/`.
It does not download or upgrade dependencies. The task/review entry points prefer
that library and reject versions differing from `runtime-lock.tsv`. The health
check records R and dependency versions; third-party dependencies are not fully
locked. Direct R API calls do not use the CLI version gate.

## Run a task

```sh
Rscript scripts/run_sc_job.R --job examples/single-cell/task-demo.json
```

This synthetic example returns a JSON response and exits **2** (`needs_review`) after technical checks. It deliberately does not approve its own figures. See the [task workflow](examples/single-cell/JOB_WORKFLOW.md) for real inputs, reports, visual review and corrections. The [skill protocol](skills/nc-bioinformatics-figure-skills/references/single_cell_execution.md) defines the agent's steps; an agent host must load the updated skill and have the R runtime installed.

## Plot directly in R

```r
library(ncfigR)
library(scfigR)

data <- load_sc_example()
figure <- do.call(compose_sc_atlas_figure, data)
figure
export_figure_bundle(figure, "atlas", out_dir = "figures", width = 9, height = 7)
```

The bundled example is synthetic. Exports include PDF, SVG, 300-dpi PNG, and the R session information. A source manifest can be supplied as a data frame.

For your own data, use `prepare_sc_atlas_data()` with a cell metadata/embedding table and a long expression table. See the [single-cell guide](examples/single-cell/README.md) for exact columns, zero-expression handling, and the real PBMC3k example.

## Real-data example

![PBMC3k atlas figure](assets/pbmc3k-atlas.png)

2,638 cells and nine annotated cell types from Satija Lab's `pbmc3k.final` dataset. The figure uses existing UMAP coordinates and annotations; marker summaries are calculated from the RNA data layer. [Source and reproduction instructions](examples/single-cell/README.md#pbmc3k-real-data-example). Dataset and derived preview: CC BY 4.0, attributed to Satija Lab and 10x Genomics.

## Other tools

`commfigR` now has a fixed execution/review entry point for existing communication
tables, with condition-separated summaries and traceable display selection:

```sh
Rscript scripts/run_comm_job.R --job examples/communication/task-example.json
```

[Communication inputs, real human-skin example and review](examples/communication/README.md).

![Existing human-skin communication results](assets/human-skin-communication.png)

556 existing interactions across 12 cell types and LS/NL conditions. Derived
from Suoqin Jin's [public CellChat objects](https://doi.org/10.6084/m9.figshare.24516340.v1),
CC BY 4.0. Displayed networks show top edges; score summaries retain all
exported rows. This is descriptive visualization, not a condition-level test.

`spfigR` accepts existing spatial coordinates, annotations and feature values.
It draws separate sections, shared-scale feature maps, optional ROI zooms and
annotated spot fractions, with frozen inputs and an evidence-backed review gate.

```sh
Rscript scripts/run_sp_job.R --job examples/spatial/task-example.json
```

[Spatial inputs, mouse-cortex Visium example and review](examples/spatial/README.md).

Spatial tasks offer four coordinated color styles (`balanced`, `muted`, `vivid`,
`okabe_ito`), using cowplot, colorspace and scico as plotting components.
[Compare styles and choose a feature palette](examples/spatial/README.md#choose-colors).

![Existing mouse-cortex spatial results](assets/mouse-cortex-spatial.png)

1,073 spots, eight existing annotations and three exported features. Source:
Suoqin Jin's [mouse-brain Visium object](https://doi.org/10.6084/m9.figshare.24516436.v1),
CC BY 4.0. ROI-1 illustrates a zoom, not an inferred anatomical niche.

`trajfigR`, `benchfigR` and `multiomfigR` remain early plotting prototypes;
they have not been validated to the task-runtime standard.

The [Codex skill](skills/nc-bioinformatics-figure-skills/SKILL.md) includes figure-planning notes, source-data templates, and plotting recipes.

## Development

Install `rcmdcheck`, `testthat`, `knitr`, and `rmarkdown`, and make sure Pandoc is available (it is included with RStudio).

```sh
Rscript scripts/check_packages.R
```

Checks build the four task-runtime packages, execute tests, and render the vignettes. GitHub Actions is configured for Linux, macOS, and Windows. Changes are listed in [CHANGELOG.md](CHANGELOG.md).

## License

Code: MIT License. The PBMC3k dataset and derived preview are attributed to Satija Lab and 10x Genomics under CC BY 4.0. The human-skin communication and mouse-cortex spatial examples and derived previews are attributed to Suoqin Jin under CC BY 4.0. Scientific Colour Maps are attributed to Fabio Crameri under CC BY 4.0; sequential maps are sampled and reversed through scico. [Color attribution](packages/ncfigR/inst/COLOR_ATTRIBUTION.md).

Paper titles, article links, and GitHub/code links are used as learning indexes. Follow the license of each original paper, dataset, and code repository when reproducing specific figures.
