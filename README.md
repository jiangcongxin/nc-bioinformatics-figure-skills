<p align="center">
  <img src="assets/project-banner.svg" alt="NC Bioinformatics Figure Skills banner" width="100%">
</p>

<h1 align="center">NC Bioinformatics Figure Skills</h1>

<p align="center">
  <strong>Nature Communications-first bioinformatics figure design skill library for Codex.</strong>
</p>

<p align="center">
  <a href="LICENSE"><img alt="License: MIT" src="https://img.shields.io/badge/License-MIT-111827.svg"></a>
  <img alt="Version" src="https://img.shields.io/badge/version-0.1.0-2563eb.svg">
  <img alt="Papers" src="https://img.shields.io/badge/papers-50-7c2d12.svg">
  <img alt="Language" src="https://img.shields.io/badge/language-ZH%20%7C%20EN-0f766e.svg">
</p>

---

## 项目简介

`NC Bioinformatics Figure Skills` 是一个面向 Codex 的生信绘图能力库。它从 Nature Communications 优先、GitHub 代码可追踪的单细胞、空间组学、多组学、微生物组和基因组学论文中提炼 figure 设计方法，帮助你把论文图形拆解成可复用的绘图模板和科研表达流程。

这个项目不是论文数据库，也不是自动绘图软件。它更像一个可持续扩展的“生信 Figure 训练项目”：

|能力|说明|
|---|---|
|论文索引|维护 50 篇高质量生信/组学 figure 学习样本|
|图形拆解|分析 figure 叙事、panel 顺序、版式和绘图包|
|模板沉淀|把 UMAP、空间图、热图、通讯网络、trajectory、benchmark 等转成个人模板|
|代码骨架|生成 R / Python 可编辑绘图 skeleton|
|项目复用|把自己的单细胞、空间组学、多组学结果转成主图设计方案|

## 适用场景

- 写单细胞、空间组学、多组学、生信方法或医学 AI 论文
- 学习 Nature Communications / Nature 系列论文的图形叙事方式
- 需要为已有分析结果设计主图、补充图或图形摘要
- 想建立自己的 R / Python 科研绘图模板库
- 想从公开 GitHub 论文仓库中学习可复刻 figure workflow

## 项目结构

```text
.
├── .codex-plugin/
│   └── plugin.json
├── skills/
│   └── nc-bioinformatics-figure-skills/
│       ├── SKILL.md
│       ├── README.md
│       └── references/
│           └── nc_bioinformatics_visualization_skill_library.md
├── assets/
│   └── project-banner.svg
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

## 核心模块

|模块|训练目标|典型输出|
|---|---|---|
|Embedding narrative|把 UMAP / embedding 与细胞类型、疾病状态、模型指标绑定|3 列 embedding + 右侧指标|
|Spatial domain story|统一组织坐标、空间 domain、marker feature 和 zoom-in|H&E + spatial scatter + marker + zoom|
|Marker heatmap|通过排序和注释提升 marker dotplot / heatmap 的解释力|cell type x marker heatmap|
|Communication story|将 ligand-receptor 热图和关键网络分层呈现|LR heatmap + top network|
|Trajectory story|同时表达 direction、pseudotime 和 gene dynamics|velocity arrows + pseudotime + gene trend|
|Benchmark story|用矩阵、rank 和真实案例组织方法比较|method x dataset heatmap + rank plot|
|Multi-omics integration|对齐 RNA、ATAC、protein、spatial 等多模态结果|multi-modal grid|
|Genome track story|统一 locus x-axis，展示 gene model、signal track 和 variant effect|multi-track genome panel|
|Microbiome network|拆分 composition、co-occurrence 和 host association|composition bar + network + heatmap|
|Journal-level layout|让每张主图只回答一个核心问题|workflow -> map -> quantification -> model|

## 快速开始

### 1. 查看知识库

核心索引文件：

[skills/nc-bioinformatics-figure-skills/references/nc_bioinformatics_visualization_skill_library.md](skills/nc-bioinformatics-figure-skills/references/nc_bioinformatics_visualization_skill_library.md)

这里包含：

- 50 篇论文
- article / code 链接
- 图形类型
- 证据等级 A / B
- 推荐复刻路径
- 个人模板沉淀建议

### 2. 在 Codex 中调用

把本仓库作为 Codex skill 或插件加载后，可以这样使用：

```text
请使用 nc-bioinformatics-figure-skills，帮我把这个单细胞结果设计成 NC 风格主图。核心结论是...
```

```text
请使用 nc-bioinformatics-figure-skills，给我一个空间组学绘图 skill 的 2 周训练计划，优先 GitHub 有 figure code 的 NC 论文。
```

```text
请使用 nc-bioinformatics-figure-skills，拆解这篇 Nature Communications 论文的 figure 版式和可复刻代码路径：...
```

## 工作流

```mermaid
flowchart LR
  A["输入: 论文 / GitHub 仓库 / 自己的分析结果"] --> B["选择绘图模块"]
  B --> C["拆解 figure story arc"]
  C --> D["定位代码入口和输入表"]
  D --> E["生成 R / Python 绘图 skeleton"]
  E --> F["沉淀为个人 figure template"]
```

## 证据等级

|等级|含义|优先级|
|---|---|---|
|A|已经看到 figures、notebooks、reproduce、source data 或明确代码入口|优先精读和复刻|
|B|Nature 页面或论文指向 GitHub，但具体 figure 脚本还需要进一步定位|适合作为扩展学习|

## Roadmap

- [x] 建立 50 篇 NC / Nature 系列生信 figure 索引
- [x] 整理 10 个可复用绘图 skill 模块
- [x] 提供 Codex skill 和插件 manifest
- [ ] 增加最小 toy data 示例
- [ ] 增加 R / Python 绘图模板目录
- [ ] 增加每个模块的 30 分钟练习任务
- [ ] 增加可复刻 figure 代码路径审计表

## 贡献

欢迎补充新的论文、代码仓库和绘图模板。提交前建议先阅读：

[CONTRIBUTING.md](CONTRIBUTING.md)

## 许可证与边界

本项目采用 [MIT License](LICENSE)。

项目中的论文标题、链接和 GitHub 入口仅用于索引、学习和方法拆解，不重新分发第三方论文全文、图片或代码。复刻论文图形时，请遵守对应论文、数据和代码仓库的许可证。
