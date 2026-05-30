---
name: nc-bioinformatics-figure-skills
description: Build NC-style single-cell, spatial, communication, trajectory, benchmark, and multi-omics figure-level training templates from Nature Communications-first, GitHub-code-backed papers with A1/A2/A3 code-pattern evidence, figure decision support, visual QA, project plotting scaffolds, NC GitHub code mining, R package routing, deep code-learning recipes, and R-first ncfigR/scfigR/spfigR/commfigR/trajfigR/benchfigR/multiomfigR plotting toolkits. Use when the user wants to decide what belongs in main figures, choose visualization types, assemble panels, audit figures, generate project figure scaffolds, inspect GitHub figure code, map repo patterns to local R plotting packages, drill into repo-level plotting recipes, or train reproducible bioinformatics plotting code.
version: "2.1.0"
allowed-tools: Read, Write, Edit, Grep, Glob, WebSearch, Bash
---

# NC Bioinformatics Figure Skills

This skill helps the user build reusable, project-specific plotting skills from high-scoring bioinformatics and omics papers, especially Nature Communications papers with public GitHub analysis or figure code.

The primary use case is now: train figure-level NC-style plotting skills for single-cell and spatial omics, then map those templates onto the user's own project outputs.

Use this skill when the user asks about:

- NC / Nature Communications bioinformatics figure visualization
- public-data and multi-omics manuscript figures
- single-cell, spatial transcriptomics, multi-omics, tumor microenvironment, microbiome, genome-track, trajectory, cell-cell communication, or benchmark figure design
- deciding what information belongs in a main figure versus supplement
- choosing visualization types, panel order, composite-figure layouts, and color palettes
- scoring a figure plan, auditing an existing figure, or finding visual problems before submission
- generating a project-local figure scaffold with palettes, source-data manifests, and R/Python script templates
- learning plotting thinking from GitHub-backed papers
- extracting plotting packages, script paths, A1/A2/A3 evidence levels, and reusable code assets from paper repositories
- making a reproducible figure plan, code skeleton, or personal figure template library for a specific project
- selecting papers to imitate for a manuscript figure

## Core Reference

Before giving advice, choose the relevant reference files:

- `references/nc_bioinformatics_visualization_skill_library.md`
- `references/code_asset_inventory.md`
- `references/code_learning_playbook.md`
- `references/code_recipe_cards.md`
- `references/nc_github_code_mining_pipeline.md`
- `references/code_pattern_inventory.md`
- `references/r_package_router.md`
- `references/code_craft_rules.md`
- `references/ncfigR_api.md`
- `references/scfigR_api.md`
- `references/scfigR_code_patterns.md`
- `references/spfigR_api.md`
- `references/spfigR_code_patterns.md`
- `references/commfigR_api.md`
- `references/commfigR_code_patterns.md`
- `references/trajfigR_api.md`
- `references/trajfigR_code_patterns.md`
- `references/benchfigR_api.md`
- `references/benchfigR_code_patterns.md`
- `references/multiomfigR_api.md`
- `references/multiomfigR_code_patterns.md`
- `references/advanced_composite_code_templates.md`
- `references/figure_decision_engine.md`
- `references/visual_qa_scorecard.md`
- `references/project_scaffold_templates.md`
- `references/nc_sc_spatial_figure_templates.md`
- `references/visual_decision_rules.md`
- `references/nc_palette_and_layout_rules.md`
- `references/multiomics_public_project_templates.md`
- `references/plot_recipe_cards.md`

The references contain:

- 50 papers, with Nature Communications prioritized
- article links and GitHub/code links
- A/B evidence levels
- 10 plotting skill modules
- statically inspected code assets from about 30 A-level repositories, graded as A1/A2/A3
- figure decision engine for template selection, panel priority, and main-vs-supplement placement
- visual QA scorecard for layout, palette, evidence, source data, and export checks
- project scaffold templates for `figures/palettes`, `figures/source_data`, `figures/scripts`, and `figures/exports`
- single-cell and spatial figure-level training templates
- visual decision rules for main-figure information, plot type, panel assembly, composite figures, and palettes
- NC-style palette, legend, spacing, panel-label, and export checks
- multi-omics / public-data Figure 1-4 manuscript templates
- reusable plotting recipe cards with input schemas, package choices, and skeleton code
- recommended replication order
- personal template schema
- repo-level code recipe cards for A1/A2 repositories
- NC GitHub code mining rules that turn repository evidence into reusable code patterns
- code pattern inventory that maps repo panels to source-data schemas, target R packages, and target functions
- R package router rules for `ncfigR`, `scfigR`, `spfigR`, `commfigR`, `trajfigR`, `benchfigR`, and `multiomfigR`
- code-learning project scaffold rules for `figures/code_learning/`
- `ncfigR` R package API for reusable source-data-first plotting functions
- `scfigR` R package API for single-cell Atlas Overview figure panels
- scPRINT, Panpipes, CellMentor, and scFoundation code-pattern mapping to `scfigR`
- `spfigR` R package API for spatial tissue niche figure panels
- Sopa, scHolography, FineST, and Tumor-cell-villages code-pattern mapping to `spfigR`
- `commfigR` R package API for LR heatmap, filtered network, sender/receiver score, and differential communication panels
- FastCCC, Human_endometrium, FineST, and Tumor-cell-villages code-pattern mapping to `commfigR`
- `trajfigR` R package API for pseudotime maps, velocity arrows, branch probability, gene trends, and state-transition panels
- MoFlow, ddHodge_figures, ILC-NK-HIPEC, and VeloCD code-pattern mapping to `trajfigR`
- `benchfigR` R package API for metric heatmaps, rank plots, runtime/memory, robustness, representative case panels, and benchmark-case composites
- NEP_comparison, CellANOVA, scFoundation, TranScale, Novae, and Evo2 code-pattern mapping to `benchfigR`
- `multiomfigR` R package API for integration embeddings, modality metrics, cross-dataset validation, feature/regulatory links, pathway/program panels, and multi-omics composites
- SMART, SpatialGlue, cPeaks, GET, AlphaGenome, CAMEX, and Human_endometrium code-pattern mapping to `multiomfigR`
- code craft rules for turning repo patterns into tested R plotting functions

## Operating Modes

### 1. Figure Decision Mode

Use this when the user has a project result set, figure idea, or uncertain panel list and asks what should go into the main figure.

Read:

- `references/figure_decision_engine.md`
- `references/nc_sc_spatial_figure_templates.md`
- `references/visual_decision_rules.md`
- `references/code_asset_inventory.md` when code-learning sources are needed

Return:

- the inferred project type, one-sentence claim, and available evidence layers
- the best matching Figure-level template
- panel keep/drop/move-to-supplement decisions
- plot type for each retained panel and the reason
- missing evidence or weak claims that should not be overdrawn
- A1/A2/A3 code assets to learn from
- a compact implementation-ready panel table

### 2. Visual QA Mode

Use this when the user provides a draft figure, a panel table, exported image, or asks whether a figure looks NC-style and submission-ready.

Read:

- `references/visual_qa_scorecard.md`
- `references/nc_palette_and_layout_rules.md`
- `references/visual_decision_rules.md`

Return:

- an overall QA verdict: `pass`, `revise`, or `major redesign`
- severity-ranked issues: `critical`, `major`, `minor`
- checks for claim focus, panel hierarchy, plot-choice fit, palette stability, legend economy, layout density, source-data readiness, and export format
- precise fixes, not vague aesthetic comments
- a revised panel order if needed

### 3. Project Scaffold Mode

Use this when the user wants a reusable project-local plotting system, figure directory, palette files, source-data manifests, or starter R/Python scripts.

Read:

- `references/project_scaffold_templates.md`
- `references/plot_recipe_cards.md`
- `references/nc_palette_and_layout_rules.md`

Return or create, when explicitly asked to write files:

- a `figures/` scaffold with `palettes/`, `source_data/`, `scripts/`, `exports/`, and `qa/`
- palette templates for cell types, groups, domains, methods, and continuous scores
- a `figure_plan.tsv` and `source_data_manifest.tsv`
- starter R/Python scripts matched to the selected Figure template
- a QA checklist that can be rerun after every export

### 4. Figure Template Training Mode

Use this as the default when the user asks how to design a main figure, how to learn NC-style plotting, how to decide plot types, how to assemble panels, or how to choose colors.

Read:

- `references/nc_sc_spatial_figure_templates.md`
- `references/visual_decision_rules.md`
- `references/nc_palette_and_layout_rules.md`
- `references/code_asset_inventory.md` when GitHub code paths are needed

Return:

- the best matching figure-level template
- what information belongs in the main figure and what should move to supplement
- panel order and visual grammar
- layout grid and panel hierarchy
- recommended R/Python plotting stack, using only confirmed package evidence or marking `待复核`
- GitHub/notebook/script entrypoints to learn from
- one toy-data replication exercise and one project-transfer exercise
- palette and legend rules that should remain fixed across the manuscript

Template priority for single-cell/spatial projects:

1. Atlas Overview Figure
2. Disease vs Control Cell-State Figure
3. Spatial Tissue Niche Figure
4. Cell-State Program Figure
5. Trajectory Figure
6. Cell-Cell Communication Figure
7. Spatial Multi-Sample Comparison Figure
8. Treatment/Condition Response Figure
9. Annotation/Marker Validation Figure
10. Benchmark + Biological Case Figure
11. Supplement QC Figure
12. NC Panel Hierarchy Figure

### 5. Project Figure Planning Mode

Use this as the default when the user has a research project, result table, or manuscript claim.

First establish or infer:

- project type: public-data multi-omics, scRNA, spatial, bulk transcriptomics, proteomics, epigenomics, microbiome, or model benchmark
- core claim: one sentence the main figure should prove
- available outputs: metadata, UMAP/embedding, DE table, pathway scores, module scores, interaction results, trajectory, validation cohort, benchmark metrics

For single-cell or spatial projects, first map to `references/nc_sc_spatial_figure_templates.md`; for broad public-data or multi-omics projects, map to `references/multiomics_public_project_templates.md`.

Return:

- Figure 1-4 structure plus Supplement plan
- panel order and plot type per panel
- exact input tables/objects needed for each panel
- recommended R/Python plotting stack
- code-learning sources from `references/code_asset_inventory.md`
- NC-style polish checklist

### 6. Code Learning Deep Dive Mode

Use when the user wants to learn from GitHub code, not just from paper images.

Read:

- `references/code_learning_playbook.md`
- `references/code_recipe_cards.md`
- `references/code_asset_inventory.md`

Choose one submode:

- `Repo Drilldown`: when the user names a repository, paper, or GitHub path.
- `Skill Drilldown`: when the user names a figure skill such as trajectory, spatial niche, communication, benchmark, UMAP, heatmap, or genome track.
- `Project Transfer`: when the user provides their own project, result set, or Figure panel list.

Return:

- A1/A2/A3 repository filtering when requested
- repository priority order
- concrete files/notebooks/scripts to inspect
- confirmed packages and imports
- expected input object or table
- expected output plot
- reusable functions or plotting patterns when present
- mapped Figure-level template for each repository
- toy-data replication exercise
- project-transfer step for the user's own data
- what to copy as a template and what not to copy
- uncertain dependencies marked as `待复核`

Evidence behavior:

- If the user asks for "only A1", include only repositories with explicit figure/source-data/reproduction evidence.
- If the user asks for a figure skill, rank repositories by matching `图型 skill` and `适配哪个 Figure 模板`.
- Do not upgrade A2/A3 repositories to A1 unless a concrete figure/script/notebook path is available.
- Do not include A3 repositories in deep-dive recipe recommendations unless the user explicitly asks for concept-only extensions.
- When the user asks for a project-local learning system, propose or create `figures/code_learning/` with `repo_index.tsv`, `learning_plan.tsv`, `recipes/`, `toy_data/`, and `scripts/`.

### 7. Code Craft / ncfigR Package Mode

Use when the user wants to write code at the level of high-quality GitHub repositories, build reusable R plotting functions, or generate advanced composite figures with the local `ncfigR` package.

Read:

- `references/code_craft_rules.md`
- `references/ncfigR_api.md`
- `references/advanced_composite_code_templates.md`
- `references/code_recipe_cards.md` when a repo pattern is named

Return:

- the repo pattern being abstracted, without copying paper code
- the `ncfigR` function calls or new function design
- required source-data table schema
- optional Seurat adapter step if relevant
- palette/source-data/export requirements
- toy-data test plan
- code review checklist for matching high-quality repo standards

### 8. NC GitHub Mining Mode

Use when the user asks to continue expanding NC/Nature GitHub learning, inspect repositories, turn GitHub code into reusable plotting patterns, or decide which repository should feed which local plotting package.

Read:

- `references/nc_github_code_mining_pipeline.md`
- `references/code_pattern_inventory.md`
- `references/code_asset_inventory.md`
- `references/code_recipe_cards.md` when a repo needs drilldown

Return:

- candidate repositories with A1/A2/A3 evidence level
- concrete code paths, not just repository names
- figure family, panel role, input schema, output plot, and package stack
- reusable pattern extracted from the repository without copying third-party code
- target local R package and target function
- license/reuse boundary and follow-up status
- a short next mining action: verify path, inspect imports, add recipe card, or design package function

Evidence behavior:

- A1 requires explicit figure/source-data/reproduction paths such as `Figure*.R`, `Fig*.ipynb`, `figures/`, `SourceData`, or manuscript figure scripts.
- A2 can route to package design, but answers must state that exact manuscript reproduction is incomplete.
- A3 can be listed as candidate only; do not recommend it for direct replication unless the user explicitly asks for concept-only learning.

### 9. R Package Router Mode

Use when the user asks which local R package should draw a figure, how to call self-built R packages from the plugin, or how to turn a project figure into package functions.

Read:

- `references/r_package_router.md`
- `references/code_pattern_inventory.md`
- `references/ncfigR_api.md`
- `references/scfigR_api.md` when the request is single-cell atlas, marker, composition, or module-score work
- `references/spfigR_api.md` when the request is spatial domain, tissue niche, spatial feature, zoom, or composition work
- `references/commfigR_api.md` when the request is ligand-receptor, cell-cell communication, sender/receiver score, or differential communication work
- `references/trajfigR_api.md` when the request is pseudotime, branch, velocity, gene trend, or state-transition work
- `references/benchfigR_api.md` when the request is benchmark, method comparison, runtime, robustness, rank, or biological case panel work
- `references/multiomfigR_api.md` when the request is multi-omics integration, cross-dataset validation, regulatory links, feature links, pathway programs, or modality metrics
- `references/project_scaffold_templates.md`

Return:

- recommended package: `ncfigR`, `scfigR`, `spfigR`, `commfigR`, `trajfigR`, `benchfigR`, or `multiomfigR`
- current implementation status: `implemented in ncfigR`, `implemented in scfigR`, `implemented in spfigR`, `implemented in commfigR`, `implemented in trajfigR`, `implemented in benchfigR`, `implemented in multiomfigR`, `stub needed`, or `package planned`
- target function names and source-data table schemas
- fallback `ncfigR` calls when a domain package is not implemented yet
- reference GitHub repo/code paths that motivated the pattern
- QA checks and project-transfer steps

Routing defaults:

- single-cell atlas, UMAP, marker dotplot, composition, module score -> `scfigR` implemented MVP, `ncfigR` shared base/fallback
- spatial tissue map, domain, spatial feature, zoom, niche composition -> `spfigR` implemented MVP, `ncfigR` shared base/fallback
- histology image overlay / segmentation mask overlay -> `spfigR` package target, image-specific overlay still `stub needed`
- LR heatmap, communication network, sender/receiver score, differential communication -> `commfigR` implemented MVP, `ncfigR` shared base/fallback
- pseudotime, velocity, branch, gene trend, state transition -> `trajfigR` implemented MVP, `ncfigR` shared base/fallback
- method benchmark, rank plot, runtime/memory, robustness, biological case panel -> `benchfigR` implemented MVP, `ncfigR` shared base/fallback
- multi-omics integration, cross-dataset validation, regulatory/feature links, pathway/program panel -> `multiomfigR` implemented MVP, `ncfigR` shared base/fallback

### 10. Template Generation Mode

Use when the user asks for R/Python plotting code.

Read `references/plot_recipe_cards.md`, then generate minimal editable code using the user's file paths or toy data.

Supported recipe families:

- UMAP / embedding narrative
- spatial domain / histology overlay
- annotation heatmap
- pathway or module heatmap
- ligand-receptor / communication network
- trajectory / velocity
- genome track / variant effect
- benchmark heatmap / rank plot
- multi-omics Figure 1 assembly

### 11. Skill Library Mode

Use when the user asks what to learn or how to build skills.

Return a compact learning plan organized by skill modules:

- UMAP / embedding narrative
- spatial tissue map and histology overlay
- marker dotplot / heatmap / annotation heatmap
- cell-cell communication / niche / network
- pseudotime / trajectory / state transition
- benchmark / statistical comparison
- multi-omics integration
- genome track / variant / pangenome
- microbiome / metagenomics network
- journal-level panel hierarchy

For each module, include:

- 2-4 representative papers from the reference
- the GitHub/code entry to inspect first
- the figure pattern to imitate
- R/Python packages to learn
- one small reproducible exercise

### 12. Paper Dissection Mode

Use when the user names a paper, article link, repository, or GitHub code path.

Inspect available paper/code context when possible, then return:

- biological question
- figure story arc
- most useful panels to imitate
- layout logic
- plotting language/packages, marking uncertainty clearly
- which files/notebooks/scripts to inspect
- a minimal reproduction plan using public or toy data

Never claim a figure script exists unless the repository or reference shows a concrete path.

### 13. Code Skeleton Mode

Use when the user asks for plotting code.

Generate a minimal, editable code skeleton in the appropriate stack:

- R: Seurat, ggplot2, ComplexHeatmap, patchwork, ggraph/igraph, Gviz
- Python: scanpy, squidpy, spatialdata, matplotlib, seaborn, networkx, pyGenomeTracks

Prefer reusable functions and stable aesthetics:

- fixed color maps for cell types/domains
- consistent legend order
- fixed panel sizes
- explicit input tables
- export paths for SVG/PDF/PNG

Do not fabricate real data. Use toy data or require the user's file paths when needed.

## Output Rules

- Answer in Chinese unless the user asks otherwise.
- Prioritize practical replication over literature summary.
- Use the reference files as the primary internal paper/code list.
- Prefer figure-level templates and visual decision rules before listing papers.
- Prefer project templates and recipe cards over generic figure advice.
- For GitHub-code learning, prefer Code Learning Deep Dive Mode and `code_recipe_cards.md` over the raw asset inventory.
- For requests about writing code at the same level as high-quality repos, prefer Code Craft / ncfigR Package Mode.
- For requests about expanding NC GitHub learning, prefer NC GitHub Mining Mode and return code patterns with target R package/function mapping.
- For requests about calling local R packages, prefer R Package Router Mode and show `ncfigR` fallback when a domain package is still planned.
- For project figure work, prefer Figure Decision Mode before writing code.
- For existing draft figures, use Visual QA Mode before suggesting new panels.
- For reusable output, use Project Scaffold Mode and keep source-data tables explicit.
- Prefer A-level papers for first-pass recommendations.
- Mark uncertain plotting tools as `推断，需复核`.
- Mark uncertain code dependencies, uninspected scripts, or inferred functions as `待复核`.
- Keep claim boundaries tight: focus on visualization thinking and code learning, not scientific endorsement.
- When creating deliverables, save them under the current workspace `outputs/` unless the user requests a different location.

## Ready-To-Paste Prompts

Use these prompts when the user asks for examples.

### Build My Skill Plan

请使用 `nc-bioinformatics-figure-skills` 的 Figure Template Training Mode，基于 NC/Nature 系 GitHub 绘图代码可追踪的单细胞/空间组学论文，帮我制定一个 30 天 Figure 级绘图训练计划。要求每天复刻一个 panel 或一个小组合图，每周完成一张 Figure 级模板，并说明主图信息取舍、图型选择、组版逻辑、配色规则、对应 GitHub 入口和 R/Python 包。

### Choose A Figure Template

请使用 `nc-bioinformatics-figure-skills`，根据我的项目结果判断最适合套用哪个 NC 单细胞/空间 Figure 级模板。我的项目类型是：[scRNA/spatial/scRNA+spatial/治疗前后/疾病对照]；核心结论是：[一句话结论]；已有结果包括：[UMAP、marker、cell fraction、module score、spatial domain、LR、trajectory、benchmark]。请告诉我主图放什么、补图放什么、每个 panel 用什么图、怎么组图、怎么配色、复刻哪个 GitHub 代码。

### Figure Decision

请使用 `nc-bioinformatics-figure-skills` 的 Figure Decision Mode，帮我把项目结果转成 NC 风格主图决策。项目类型是：[单细胞/空间/多组学/公共数据]；核心结论是：[一句话结论]；已有结果包括：[metadata、UMAP、marker、cell fraction、module score、spatial domain、LR、trajectory、benchmark、validation]。请输出：推荐 Figure 模板、主图保留 panel、移到补图 panel、每个 panel 的图型、缺失证据、A1/A2/A3 学习仓库和最终 panel table。

### Visual QA

请使用 `nc-bioinformatics-figure-skills` 的 Visual QA Mode，检查我的 Figure 方案/图片是否达到 NC 风格。请按 claim focus、panel hierarchy、plot choice、palette、legend、layout、source data、export format 打分，列出 critical/major/minor 问题，并给出具体修改方案。

### Project Scaffold

请使用 `nc-bioinformatics-figure-skills` 的 Project Scaffold Mode，为我的项目生成一个可复用绘图脚手架。项目类型是：[单细胞/空间/多组学]；目标 Figure 是：[Atlas Overview/Spatial Tissue Niche/Trajectory/Communication/Benchmark]；使用语言是：[R/Python/两者]。请生成目录结构、palette 表、source_data_manifest、figure_plan 和 starter script 骨架。

### Build My Project Figure System

请使用 `nc-bioinformatics-figure-skills`，围绕我的多组学/公共数据研究项目建立 NC 风格绘图 skill 系统。我的项目主题是：[项目主题]；核心结论是：[一句话结论]；已有结果包括：[metadata、表达矩阵、DE、通路、模块评分、验证队列、通讯、trajectory、benchmark 等]。请输出 Figure 1-4 和 Supplement 的 panel 设计、每个 panel 需要的输入表、推荐 R/Python 包、应学习的 NC GitHub 代码路径，以及最小绘图代码骨架。

### Learn From Code Assets

请使用 `nc-bioinformatics-figure-skills` 的代码学习模式，帮我从 A1/A2/A3 分层 GitHub 仓库里学习生信绘图。请按仓库列出：repo、论文、图型 skill、先看哪个 notebook/script、确认用了哪些 R 包/Python 库、可复刻哪个 panel、适配哪个 Figure 模板、可信等级，以及我应该如何用自己的数据复刻。

### A1 Only Code Learning

请使用 `nc-bioinformatics-figure-skills`，只筛选 A1 GitHub 仓库，帮我学习 [UMAP/空间 niche/通讯/trajectory/benchmark] 绘图。不要混入 A2/A3。每个仓库请给出具体 figure/script/notebook 路径、确认包、可复刻 panel 和最小练习。

### Code Learning Deep Dive

请使用 `nc-bioinformatics-figure-skills` 的 Code Learning Deep Dive Mode，帮我深挖 [repo 名称或 figure skill]。请按 Repo Drilldown / Skill Drilldown 输出：证据等级、具体代码路径、语言和确认包、输入对象/表格、输出图型、可复用模式、toy data 复刻步骤、如何迁移到我的项目，以及所有 `待复核` 项。

### Project Code Learning Scaffold

请使用 `nc-bioinformatics-figure-skills` 的 Project Transfer 子模式，把我的 Figure 方案映射到可学习的 A1/A2 GitHub 代码，并设计 `figures/code_learning/` 学习脚手架。请输出 `repo_index.tsv`、`learning_plan.tsv`、recipes 文件建议、toy data schema 和项目迁移步骤。

### Code Craft With ncfigR

请使用 `nc-bioinformatics-figure-skills` 的 Code Craft / ncfigR Package Mode，把 [repo/figure skill] 的高质量绘图代码模式抽象成 `ncfigR` 可复用 R 函数或调用模板。请输出：输入 source-data schema、可选 Seurat 适配、函数参数设计、R 代码骨架、toy data 测试、PDF/SVG/PNG 导出和代码质量 checklist。

### NC GitHub Mining

请使用 `nc-bioinformatics-figure-skills` 的 NC GitHub Mining Mode，继续挖掘 Nature Communications / Nature 系 GitHub 绘图代码。请按 repo 输出：论文、期刊年份、figure family、具体代码路径、语言和包、输入 schema、输出图型、可复用模式、目标本地 R 包、目标函数、A1/A2/A3 证据等级、license/reuse 边界和下一步复核动作。

### R Package Router

请使用 `nc-bioinformatics-figure-skills` 的 R Package Router Mode，根据我的项目 figure 需求决定应该调用 `ncfigR/scfigR/spfigR/commfigR/trajfigR/benchfigR/multiomfigR` 中哪个包。我的数据类型是：[单细胞/空间/通讯/trajectory/benchmark/多组学]；目标 figure 是：[Figure 模板或 panel 列表]。请输出：推荐 R 包、函数、输入 TSV schema、当前实现状态、ncfigR fallback、参考 GitHub code path、QA 检查和下一步复刻动作。

### Single-Cell Atlas With scfigR

请使用 `nc-bioinformatics-figure-skills` 的 R Package Router Mode 和 `scfigR`，把我的单细胞 Figure 1 设计成 Atlas Overview Figure。请输出需要的 `embedding.tsv`、`composition.tsv`、`marker_dotplot.tsv`、`module_scores.tsv` schema，推荐 `scfigR` 函数调用、`ncfigR` 导出方式、参考 scPRINT/Panpipes/CellMentor/scFoundation 的代码模式，以及 QA checklist。

### Spatial Niche With spfigR

请使用 `nc-bioinformatics-figure-skills` 的 R Package Router Mode 和 `spfigR`，把我的空间组学结果设计成 Spatial Tissue Niche Figure。请输出需要的 `spatial_coordinates.tsv`、`spatial_features.tsv`、`spatial_composition.tsv`、`spatial_zoom_regions.tsv`、`domain_palette.tsv` schema，推荐 `spfigR` 函数调用、`ncfigR` 导出方式、参考 Sopa/scHolography/FineST/Tumor-cell-villages 的代码模式，以及 QA checklist。

### Communication Figure With commfigR

请使用 `nc-bioinformatics-figure-skills` 的 R Package Router Mode 和 `commfigR`，把我的细胞通讯结果设计成 Cell-Cell Communication Figure。请输出需要的 `lr_pairs.tsv`、`communication_scores.tsv`、`differential_lr.tsv`、`network_edges.tsv` schema，推荐 `commfigR` 函数调用、`ncfigR` 导出方式、参考 FastCCC/Human_endometrium/FineST/Tumor-cell-villages 的代码模式，以及 QA checklist。

### Trajectory Figure With trajfigR

请使用 `nc-bioinformatics-figure-skills` 的 R Package Router Mode 和 `trajfigR`，把我的轨迹分析结果设计成 Trajectory Figure。请输出需要的 `trajectory_cells.tsv`、`velocity_vectors.tsv`、`branch_probabilities.tsv`、`gene_trends.tsv`、`state_transitions.tsv` schema，推荐 `trajfigR` 函数调用、`ncfigR` 导出方式、参考 MoFlow/ddHodge_figures/ILC-NK-HIPEC/VeloCD 的代码模式，以及 QA checklist。

### Benchmark Case Figure With benchfigR

请使用 `nc-bioinformatics-figure-skills` 的 R Package Router Mode 和 `benchfigR`，把我的方法比较结果设计成 Benchmark + Biological Case Figure。请输出需要的 `benchmark_metrics.tsv`、`benchmark_ranks.tsv`、`runtime_metrics.tsv`、`robustness_metrics.tsv`、`case_embedding.tsv` schema，推荐 `benchfigR` 函数调用、`ncfigR` 导出方式、参考 NEP_comparison/CellANOVA/scFoundation/TranScale 的代码模式，以及 QA checklist。

### Multi-Omics Figure With multiomfigR

请使用 `nc-bioinformatics-figure-skills` 的 R Package Router Mode 和 `multiomfigR`，把我的多组学整合结果设计成 Multi-omics Integration Figure。请输出需要的 `integration_embedding.tsv`、`modality_metrics.tsv`、`cross_dataset_validation.tsv`、`feature_links.tsv`、`pathway_programs.tsv` schema，推荐 `multiomfigR` 函数调用、`ncfigR` 导出方式、参考 SMART/SpatialGlue/CAMEX/cPeaks/GET/AlphaGenome/Human_endometrium 的代码模式，以及 QA checklist。

### Turn My Results Into A Figure

请使用 `nc-bioinformatics-figure-skills`，把我的分析结果设计成 NC/Nature Communications 风格的主图。我的数据类型是：[数据类型]；核心结论是：[一句话结论]；已有结果包括：[UMAP/空间坐标/marker/DE/通路/通讯/trajectory/benchmark]。请给出 panel 顺序、每个 panel 的图型、输入文件、推荐 R/Python 包、组版逻辑和可执行绘图步骤。

### Improve My Figure Decisions

请使用 `nc-bioinformatics-figure-skills` 的 visual decision rules，帮我判断这张主图方案是否合理。请逐项检查：主图信息是否过多、图型是否匹配数据结构、panel 顺序是否符合叙事、组合图是否有主视觉和验证层、配色是否稳定且适合投稿。

### Dissect A Paper

请使用 `nc-bioinformatics-figure-skills`，拆解这篇论文/仓库的 figure 可视化思维：[论文链接或 GitHub 链接]。请输出：核心生物问题、最值得模仿的 3 个 figure/panel、版式结构、绘图语言/包、代码入口、我可以如何用 toy data 复刻。
