<p align="center">
  <img src="assets/project-banner.svg" alt="NC Bioinformatics Figure Skills banner" width="100%">
</p>

<h1 align="center">NC Bioinformatics Figure Skills</h1>

<p align="center">
  <strong>从可复现的生信/组学论文中学习 figure 设计，并整理成 Codex skill。</strong>
</p>

<p align="center">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-111827.svg"></a>
  <img alt="Version" src="https://img.shields.io/badge/version-2.0.0-2563eb.svg">
  <img alt="Papers" src="https://img.shields.io/badge/papers-50-7c2d12.svg">
  <img alt="Language" src="https://img.shields.io/badge/language-ZH%20%7C%20EN-0f766e.svg">
</p>

## 有什么用

这个项目整理了一批 Nature Communications / Nature 系列为主的生信、单细胞、空间组学、多组学论文，重点记录：

- 哪些论文的 figure 值得学习；
- 哪些论文有 GitHub、Zenodo、notebook、source data 或复现入口；
- 每篇文章适合学习什么图型；
- 如何把论文里的 figure 思路转成自己的 R / Python 绘图模板；
- 如何让 Codex 帮你拆解论文图、设计主图、生成绘图代码骨架。

它不是自动绘图软件，也不保存第三方论文图片或代码。它主要用于学习 figure 设计、整理绘图思路和复刻路径。

## 怎么用

先看这个文件：

[`skills/nc-bioinformatics-figure-skills/references/nc_bioinformatics_visualization_skill_library.md`](skills/nc-bioinformatics-figure-skills/references/nc_bioinformatics_visualization_skill_library.md)

里面有 50 篇论文索引、代码入口、图形类型和推荐复刻顺序。

在 Codex 中可以这样调用：

```text
请使用 nc-bioinformatics-figure-skills，帮我把这个单细胞结果设计成 NC 风格主图。核心结论是...
```

```text
请使用 nc-bioinformatics-figure-skills，给我一个空间组学绘图 skill 的 2 周训练计划，优先 GitHub 有 figure code 的 NC 论文。
```

```text
请使用 nc-bioinformatics-figure-skills，拆解这篇论文/仓库的 figure 版式和可复刻代码路径：...
```

## 适合处理的图型

- UMAP / embedding 叙事
- 空间组织图、histology overlay、局部 zoom-in
- marker dotplot、heatmap、annotation heatmap
- cell-cell communication、niche、network
- pseudotime、trajectory、RNA velocity
- benchmark 和方法比较图
- 多组学整合图
- genome track、variant effect、pangenome 图
- microbiome composition 和 network 图
- 期刊级多 panel 主图设计

## 主要文件

```text
skills/nc-bioinformatics-figure-skills/SKILL.md
skills/nc-bioinformatics-figure-skills/references/nc_bioinformatics_visualization_skill_library.md
.codex-plugin/plugin.json
```

## 证据等级

|等级|含义|
|---|---|
|A|已经看到 figure、notebook、reproduce、source data 或明确代码入口，适合优先复刻|
|B|论文指向 GitHub，但具体 figure 脚本还需要继续定位|

## 许可证

MIT License。

论文标题、链接和 GitHub 入口只作为学习索引。复刻具体图形时，请遵守原论文、数据和代码仓库的许可证。
