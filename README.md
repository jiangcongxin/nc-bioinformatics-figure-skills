# NC Bioinformatics Figure Skills

一个面向 Codex 的生信绘图 skill 项目，用于从 Nature Communications 优先、GitHub 代码可追踪的单细胞、空间组学、多组学、微生物组和基因组学论文中学习 figure 设计，并沉淀成可复用的绘图模板。

## 项目定位

这个项目不是论文数据库，也不是自动绘图软件。它更像一个“生信 Figure 可视化训练库”：

- 按绘图能力模块组织代表论文
- 优先选择有 GitHub / Zenodo / figure code / notebook / source data 入口的论文
- 帮助用户拆解论文 figure 的叙事、版式、绘图包和可复刻路径
- 为自己的单细胞、空间组学、多组学或医学 AI 项目生成主图设计方案
- 输出 R / Python 绘图代码骨架和个人模板 checklist

## 主要内容

- `skills/nc-bioinformatics-figure-skills/SKILL.md`  
  Codex skill 的主说明文件，定义使用场景、工作模式和输出规则。

- `skills/nc-bioinformatics-figure-skills/references/nc_bioinformatics_visualization_skill_library.md`  
  50 篇以 Nature Communications 为主的生信/组学可视化论文索引，包含代码入口、绘图类型、证据等级和复刻建议。

- `.codex-plugin/plugin.json`  
  Codex 插件 manifest，可用于本地插件打包或二次分发。

## 覆盖的绘图 skill 模块

1. 单细胞 UMAP / embedding 叙事
2. 空间组织图与 histology overlay
3. marker dotplot / heatmap / annotation heatmap
4. cell-cell communication / niche / network 图
5. pseudotime / trajectory / state transition 图
6. benchmark / 统计比较图
7. 多组学整合组合图
8. genome track / variant / pangenome 图
9. microbiome / metagenomics 网络图
10. 期刊级 Figure 组版

## 在 Codex 中使用

把本项目放到 Codex skills 或插件目录后，可以用类似提示词调用：

```text
请使用 nc-bioinformatics-figure-skills，帮我把这个单细胞结果设计成 NC 风格主图。核心结论是...
```

```text
请使用 nc-bioinformatics-figure-skills，给我一个空间组学绘图 skill 的 2 周训练计划，优先 GitHub 有 figure code 的 NC 论文。
```

```text
请使用 nc-bioinformatics-figure-skills，拆解这篇 Nature Communications 论文的 figure 版式和可复刻代码路径：...
```

## 适合谁使用

- 正在写生信、单细胞、空间组学、多组学论文的人
- 希望学习 Nature Communications / Nature 系列 figure 叙事的人
- 想建立个人 R / Python 绘图模板库的人
- 想把公开论文仓库拆解成可复用绘图方法的人

## 许可证

MIT License。

注意：项目中的论文标题、链接和 GitHub 入口仅用于索引和学习，不重新分发第三方论文全文、图片或代码。复刻论文图形时，请遵守对应论文、数据和代码仓库的许可证。
