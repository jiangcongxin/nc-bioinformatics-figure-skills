# Optional Paper and Code Learning

Load only when the user explicitly asks to learn from papers, inspect a named paper/repository, mine figure code, or generate learning exercises. Ordinary single-cell plotting does not require this module. Read only matching reference files, verify external sources when needed, and retain source/license attribution before code reuse. Reference inventories are learning leads, not proof of inspected or reproducible code.

### 6. Code Learning Deep Dive Mode

Use when the user wants to learn from GitHub code, not just from paper images.

Read:

- `code_learning_playbook.md`
- `code_recipe_cards.md`
- `code_asset_inventory.md`

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

### 8. NC GitHub Mining Mode

Use when the user asks to continue expanding NC/Nature GitHub learning, inspect repositories, turn GitHub code into reusable plotting patterns, or decide which repository should feed which local plotting package.

Read:

- `nc_github_code_mining_pipeline.md`
- `code_pattern_inventory.md`
- `code_asset_inventory.md`
- `code_recipe_cards.md` when a repo needs drilldown

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
