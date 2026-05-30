---
name: nc-bioinformatics-figure-skills
description: Build personal bioinformatics figure visualization skills from Nature Communications-first, GitHub-code-backed omics papers. Use when the user asks to learn NC/Nature Communications figure design, reproduce bioinformatics visualizations, inspect GitHub figure code, or turn paper figures into plotting skills/templates.
version: "2.0.0"
allowed-tools: Read, Write, Edit, Grep, Glob, WebSearch, Bash
---

# NC Bioinformatics Figure Skills

This skill helps the user build reusable plotting skills from high-scoring bioinformatics and omics papers, especially Nature Communications papers with public GitHub analysis or figure code.

Use this skill when the user asks about:

- NC / Nature Communications bioinformatics figure visualization
- single-cell, spatial transcriptomics, multi-omics, tumor microenvironment, microbiome, genome-track, trajectory, cell-cell communication, or benchmark figure design
- learning plotting thinking from GitHub-backed papers
- making a reproducible figure plan, code skeleton, or personal figure template library
- selecting papers to imitate for a manuscript figure

## Core Reference

Before giving paper-specific advice, read the reference:

- `references/nc_bioinformatics_visualization_skill_library.md`

The reference contains:

- 50 papers, with Nature Communications prioritized
- article links and GitHub/code links
- A/B evidence levels
- 10 plotting skill modules
- recommended replication order
- personal template schema

## Operating Modes

### 1. Skill Library Mode

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

### 2. Paper Dissection Mode

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

### 3. Figure Planning Mode

Use when the user has their own analysis results and wants a manuscript figure plan.

Ask for or infer:

- data type: scRNA, spatial, multi-omics, bulk, microbiome, genome track, model benchmark
- intended biological claim
- available outputs: embeddings, markers, DE, pathways, interactions, trajectories, metrics

Then map the user's data to a proven template from the reference.

Return:

- Figure 1 / main figure structure
- panel order
- plot type per panel
- input data required per panel
- plotting stack
- publication polish checklist

### 4. Code Skeleton Mode

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
- Use the reference as the primary internal paper list.
- Prefer A-level papers for first-pass recommendations.
- Mark uncertain plotting tools as `推断，需复核`.
- Keep claim boundaries tight: focus on visualization thinking and code learning, not scientific endorsement.
- When creating deliverables, save them under the current workspace `outputs/` unless the user requests a different location.

## Ready-To-Paste Prompts

Use these prompts when the user asks for examples.

### Build My Skill Plan

请使用 `nc-bioinformatics-figure-skills`，基于 Nature Communications 优先、GitHub 绘图代码可追踪的 50 篇文献库，帮我制定一个 30 天生信绘图 skill 训练计划。我的重点是：[单细胞/空间组学/多组学/肿瘤微环境/微生物组/基因组轨道图]。要求每周输出可复刻图型、对应论文和 GitHub 入口、R/Python 包、最小练习任务。

### Turn My Results Into A Figure

请使用 `nc-bioinformatics-figure-skills`，把我的分析结果设计成 NC/Nature Communications 风格的主图。我的数据类型是：[数据类型]；核心结论是：[一句话结论]；已有结果包括：[UMAP/空间坐标/marker/DE/通路/通讯/trajectory/benchmark]。请给出 panel 顺序、每个 panel 的图型、输入文件、推荐 R/Python 包、组版逻辑和可执行绘图步骤。

### Dissect A Paper

请使用 `nc-bioinformatics-figure-skills`，拆解这篇论文/仓库的 figure 可视化思维：[论文链接或 GitHub 链接]。请输出：核心生物问题、最值得模仿的 3 个 figure/panel、版式结构、绘图语言/包、代码入口、我可以如何用 toy data 复刻。
