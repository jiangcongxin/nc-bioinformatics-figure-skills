# NC Bioinformatics Figure Skills

本地 Codex skill：从 Nature Communications 优先、GitHub 代码可追踪的生信/组学论文中学习 figure 可视化思维，并围绕自己的研究项目沉淀成可复用绘图 skills。

当前版本优先服务“Figure Decision + Visual QA + Project Scaffold + NC GitHub Mining + R Package Router + Code Learning Deep Dive + ncfigR + scfigR + spfigR + commfigR + trajfigR + benchfigR + multiomfigR”：先判断主图该放什么和怎么画，再审稿式检查视觉问题，然后把可复用绘图目录、palette、source data manifest、脚本骨架、GitHub 代码模式、R 包路由和 R 优先绘图函数沉淀到项目里。

## 能做什么

- 把多组学/公共数据项目映射成 NC 风格 Figure 1-4 和 Supplement
- 为单细胞/空间组学项目选择 Figure 级模板
- 根据项目结果输出 Figure 决策：保留哪些 panel、哪些移到补图、缺什么证据
- 对已有 Figure 方案或图片做 Visual QA：claim、panel hierarchy、plot choice、palette、legend、layout、source data、export
- 生成项目绘图脚手架：`figures/palettes/`、`figures/source_data/`、`figures/scripts/`、`figures/exports/`、`figures/qa/`
- 判断主图应该放什么信息、哪些信息放补图
- 判断每个 panel 应该用 UMAP、空间图、热图、dotplot、network、trajectory 还是 benchmark
- 训练 6-8 个 panel 的 NC 风格组图和高级组合图
- 给出稳定的细胞类型、分组、连续变量和空间 domain 配色规则
- 按绘图能力模块推荐论文和 GitHub 入口
- 从约 30 个 A 级 GitHub 仓库中按 A1/A2/A3 证据等级筛选可学习代码
- 按 `repo | 论文 | 图型 skill | 路径 | 包 | 可复刻 panel | Figure 模板 | 可信等级` 输出代码学习路线
- 深挖 A1/A2 仓库，输出脚本路径、输入对象、输出图型、确认包、可复用模式、toy data 练习和项目迁移步骤
- 继续挖掘 NC/Nature 系 GitHub 代码，把 repo/panel 转成 `figure_family -> input_schema -> reusable_pattern -> target_r_package -> target_function`
- 根据项目 figure 需求路由到本地 R 包：`ncfigR`、`scfigR`、`spfigR`、`commfigR`、`trajfigR`、`benchfigR`、`multiomfigR`
- 使用已实现的 `scfigR` MVP 绘制单细胞 Atlas Overview Figure：embedding、cell fraction、marker dotplot、module score 和组合图
- 使用已实现的 `spfigR` MVP 绘制空间 Spatial Tissue Niche Figure：domain map、spatial feature、domain composition、zoom-in 和组合图
- 使用已实现的 `commfigR` MVP 绘制通讯 Cell-Cell Communication Figure：LR heatmap、filtered network、sender/receiver score、differential LR 和组合图
- 使用已实现的 `trajfigR` MVP 绘制轨迹 Trajectory Figure：pseudotime map、velocity arrows、branch probability、gene trend、state transition 和组合图
- 使用已实现的 `benchfigR` MVP 绘制 Benchmark + Biological Case Figure：metric heatmap、rank plot、runtime/memory、robustness、case embedding 和组合图
- 使用已实现的 `multiomfigR` MVP 绘制 Multi-omics Integration Figure：integrated embedding、modality metrics、cross-dataset validation、feature/regulatory links、pathway/program panel 和组合图
- 在其他领域 R 包尚未实现时，给出 `ncfigR` fallback 调用和 `stub needed/package planned` 状态
- 按 `Repo Drilldown`、`Skill Drilldown`、`Project Transfer` 三种方式学习代码
- 生成 `figures/code_learning/` 学习脚手架：`repo_index.tsv`、`learning_plan.tsv`、`recipes/`、`toy_data/`、`scripts/`
- 使用本地 R 包 `ncfigR` 生成可复用高级组合图函数和调用模板
- 将高质量 GitHub repo 模式转成 source-data-first 的 R 函数、toy data、测试和导出规范
- 整理 A 级仓库的 `notebook/script/figure/code` 路径、R 包和 Python 库
- 拆解单篇论文的 figure 叙事、版式和代码路径
- 把用户自己的单细胞、空间组学、多组学、微生物组或基因组轨道分析结果转成主图方案
- 生成 R/Python 绘图代码骨架
- 维护个人 figure template checklist

## 主要知识库

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

这些文件包含 50 篇论文索引、约 30 个 A 级仓库静态代码资产、A1/A2/A3 可信等级、Code Learning Deep Dive playbook、A1/A2 repo-level 代码配方卡、NC GitHub code mining pipeline、repo-to-pattern 清单、R package router、Code Craft 规则、`ncfigR` API、`scfigR` API、`spfigR` API、`commfigR` API、`trajfigR` API、`benchfigR` API、`multiomfigR` API、高级组合图代码模板、Figure 决策引擎、Visual QA 打分表、项目绘图脚手架、单细胞/空间/通讯/轨迹/benchmark/多组学 Figure 级模板、视觉决策规则、NC 配色与组版检查清单、10 个绘图 skill 模块、多组学/公共数据主图模板、证据等级和复刻路线。

## 推荐调用方式

```text
请使用 nc-bioinformatics-figure-skills 的 Figure Decision Mode，根据我的项目结果判断 Figure 1 应该放什么、哪些结果放补图、每个 panel 用什么图型，并给出 A1/A2/A3 学习仓库。
```

```text
请使用 nc-bioinformatics-figure-skills 的 Visual QA Mode，检查这张 Figure 方案是否达到 NC 风格，按 critical/major/minor 给出问题和修改方案。
```

```text
请使用 nc-bioinformatics-figure-skills 的 Project Scaffold Mode，为我的单细胞项目生成 figures/ 绘图脚手架、palette 表、source_data_manifest、figure_plan 和 R/Python starter script。
```

```text
请使用 nc-bioinformatics-figure-skills，只看 A1 仓库，帮我学习 spatial niche figure。请列出 repo、论文、具体 notebook/script 路径、R/Python 包、可复刻 panel 和适配模板。
```

```text
请使用 nc-bioinformatics-figure-skills 的 Code Learning Deep Dive Mode，只看 A1 仓库学习 trajectory figure。请返回 Repo/Skill Drilldown：代码路径、语言和确认包、输入对象、输出图型、toy data 练习、项目迁移步骤和待复核项。
```

```text
请使用 nc-bioinformatics-figure-skills 的 Project Transfer 子模式，把我的 Figure 2 映射到可复刻代码路线，并设计 figures/code_learning/ 学习脚手架。
```

```text
请使用 nc-bioinformatics-figure-skills 的 Code Craft / ncfigR Package Mode，把 FastCCC 风格通讯图迁移到我的项目，输出 source-data schema、ncfigR R 代码、toy data 测试和导出规范。
```

```text
请使用 nc-bioinformatics-figure-skills 的 NC GitHub Mining Mode，继续挖掘 NC/Nature 系 GitHub 绘图代码，并把每个 repo/panel 映射到 target R package、target function、input schema、A1/A2/A3 证据等级和下一步复核动作。
```

```text
请使用 nc-bioinformatics-figure-skills 的 R Package Router Mode，判断我的空间 niche 主图应该调用 spfigR 还是 ncfigR fallback。请输出函数、输入 TSV schema、参考 GitHub code path、当前实现状态和 QA 检查。
```

```text
请使用 nc-bioinformatics-figure-skills 的 R Package Router Mode 和 scfigR，为我的单细胞 Figure 1 生成 Atlas Overview Figure 的 source-data schema 和 R 调用：embedding、cell fraction、marker dotplot、module score、组合图和 ncfigR 导出。
```

```text
请使用 nc-bioinformatics-figure-skills 的 R Package Router Mode 和 spfigR，为我的空间 niche 主图生成 Spatial Tissue Niche Figure 的 source-data schema 和 R 调用：domain map、spatial feature、domain composition、zoom-in、组合图和 ncfigR 导出。
```

```text
请使用 nc-bioinformatics-figure-skills 的 R Package Router Mode 和 commfigR，把 FastCCC 风格通讯图迁移到我的项目。请输出 lr_pairs、communication_scores、differential_lr、network_edges 的 schema，LR heatmap、filtered network、sender/receiver score、differential LR 的 R 调用，以及 ncfigR 导出。
```

```text
请使用 nc-bioinformatics-figure-skills 的 R Package Router Mode 和 trajfigR，把我的轨迹分析结果设计成 Trajectory Figure。请输出 trajectory_cells、velocity_vectors、branch_probabilities、gene_trends、state_transitions 的 schema，pseudotime map、velocity arrows、branch probability、gene trend、state transition 的 R 调用，以及 ncfigR 导出。
```

```text
请使用 nc-bioinformatics-figure-skills 的 R Package Router Mode 和 benchfigR，把我的方法比较结果设计成 Benchmark + Biological Case Figure。请输出 benchmark_metrics、benchmark_ranks、runtime_metrics、robustness_metrics、case_embedding 的 schema，metric heatmap、rank plot、runtime/memory、robustness、case panel 的 R 调用，以及 ncfigR 导出。
```

```text
请使用 nc-bioinformatics-figure-skills 的 R Package Router Mode 和 multiomfigR，把我的多组学整合结果设计成 Multi-omics Integration Figure。请输出 integration_embedding、modality_metrics、cross_dataset_validation、feature_links、pathway_programs 的 schema，integrated embedding、modality metric、cross-dataset validation、feature/regulatory links、pathway/program panel 的 R 调用，以及 ncfigR 导出。
```

```text
请使用 nc-bioinformatics-figure-skills，根据我的单细胞/空间项目结果，选择最适合的 NC Figure 级模板，并说明主图放什么、补图放什么、怎么组版、怎么配色。
```

```text
请使用 nc-bioinformatics-figure-skills，训练我复刻一个 Spatial Tissue Niche Figure：告诉我看哪个 GitHub 脚本、用什么包、先画哪个 panel、怎么迁移到自己的数据。
```

```text
请使用 nc-bioinformatics-figure-skills，帮我把这个单细胞结果设计成 NC 风格主图。核心结论是...
```

```text
请使用 nc-bioinformatics-figure-skills，围绕我的多组学公共数据项目建立 Figure 1-4 绘图系统。项目主题是...
```

```text
请使用 nc-bioinformatics-figure-skills，给我一个空间组学绘图 skill 的 2 周训练计划，优先 GitHub 有 figure code 的 NC 论文。
```

```text
请使用 nc-bioinformatics-figure-skills，拆解这篇 Nature Communications 论文的 figure 版式和可复刻代码路径：...
```
