<p align="center">
  <img src="assets/project-banner.svg" alt="NC Bioinformatics Figure Skills banner" width="100%">
</p>

<h1 align="center">NC Bioinformatics Figure Skills</h1>

<p align="center">
  <strong>NC-style bioinformatics figure training, code mining, and R plotting toolkit collection for Codex.</strong>
</p>

<p align="center">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-111827.svg"></a>
  <img alt="Version" src="https://img.shields.io/badge/version-2.1.0-2563eb.svg">
  <img alt="Papers" src="https://img.shields.io/badge/papers-50-7c2d12.svg">
  <img alt="R packages" src="https://img.shields.io/badge/R%20packages-7-0f766e.svg">
</p>

## What this project is for

This repository collects a Codex skill, reference notes, and small R plotting packages for learning and building Nature Communications-style bioinformatics figures.

It is useful when you want to:

- decide what belongs in a single-cell, spatial, trajectory, communication, benchmark, or multi-omics main figure;
- inspect GitHub-backed paper code and turn figure patterns into reusable plotting recipes;
- route a project to the right local plotting package;
- build source-data-first R figure panels that can be audited and reused.

## Contents

```text
skills/nc-bioinformatics-figure-skills/
packages/ncfigR/
packages/scfigR/
packages/spfigR/
packages/commfigR/
packages/trajfigR/
packages/benchfigR/
packages/multiomfigR/
```

## R package map

| Package | Scope |
|---|---|
| `ncfigR` | Shared base toolkit for embedding, composition, heatmap, network, trajectory, benchmark, and export panels |
| `scfigR` | Single-cell atlas overview figures |
| `spfigR` | Spatial tissue niche and spatial-feature figures |
| `commfigR` | Cell-cell communication, ligand-receptor, and differential communication figures |
| `trajfigR` | Pseudotime, branch, gene-trend, velocity, and state-transition figures |
| `benchfigR` | Benchmark plus biological case-study figures |
| `multiomfigR` | Multi-omics integration, modality metric, feature-link, and pathway-program figures |

## Codex skill

The skill entry point is:

```text
skills/nc-bioinformatics-figure-skills/SKILL.md
```

The reference folder includes figure decision rules, visual QA scorecards, code-pattern inventories, package API notes, project scaffold templates, and reusable plotting recipe cards.

## Install package locally

Example:

```r
install.packages("remotes")
remotes::install_local("packages/ncfigR")
remotes::install_local("packages/scfigR")
```

Install `ncfigR` first because the other packages reuse its theme, palette, export, and base-panel helpers.

## License

MIT License.

Paper titles, article links, and GitHub/code links are used as learning indexes. Follow the license of each original paper, dataset, and code repository when reproducing specific figures.
