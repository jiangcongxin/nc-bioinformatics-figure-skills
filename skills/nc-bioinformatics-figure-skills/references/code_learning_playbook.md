# Code Learning Playbook

Purpose: turn GitHub-backed NC/Nature bioinformatics figure code into a practical training system. Use this file with `code_asset_inventory.md` and `code_recipe_cards.md`.

## Default Behavior

When the user asks to learn plotting from code, prefer code-level training over literature summary.

Return one of three shapes:

1. `Repo Drilldown`: for a named repository or paper.
2. `Skill Drilldown`: for a figure skill such as trajectory, communication, spatial niche, benchmark, UMAP, or heatmap.
3. `Project Transfer`: for a user's own project, figure plan, or result set.

Always include:

- evidence level: `A1`, `A2`, or `A3`
- exact code paths from the inventory or recipe cards
- confirmed package stack only; mark unconfirmed packages as `待复核`
- input object/table expected by the code pattern
- output plot type
- what to copy as a reusable pattern
- what not to copy directly
- one toy-data replication exercise
- one project-transfer step

## Evidence Rules

| Level | Code Learning Use | Boundary |
|---|---|---|
| A1 | Direct first-pass replication from figure/script/notebook evidence. | Can recommend as primary code source. |
| A2 | Learn workflow structure, package choice, plotting modules, and panel logic. | Must say manuscript figure code may be incomplete. |
| A3 | Concept-only extension. | Do not include in deep-dive recipes unless user explicitly asks. |

Do not upgrade a repository to A1 without an explicit figure/source-data/reproduction path.

## Repo Drilldown Output

Use this when the user asks about one repository.

```text
Repo:
Evidence:
Best code entry:
Language and confirmed packages:
Expected input:
Expected output:
Reusable pattern:
Learning order:
1. inspect ...
2. reproduce ...
3. transfer ...
Toy exercise:
Project transfer:
Pitfalls / 待复核:
```

## Skill Drilldown Output

Use this when the user asks to learn one figure skill.

```text
Skill:
Recommended code route:
| priority | repo | level | code path | package stack | panel to reproduce | transfer target |
Practice ladder:
1. toy panel
2. two-panel composite
3. project panel
4. NC-style figure block
Avoid:
```

Default skill routes:

| Skill | A1 First | A2 Extension | Notes |
|---|---|---|---|
| UMAP / embedding narrative | scPRINT, CellMentor, Panpipes, scFoundation | CellANOVA, CAMEX | Keep one embedding coordinate system across panels. |
| Spatial tissue niche | scHolography | Sopa, FineST, Tumor-cell-villages, NiCo, CellRefiner | Use spatial map as anchor; quantify niche signal next to it. |
| Communication / LR network | FastCCC, scHolography | Human_endometrium, FineST, Tumor-cell-villages, NiCo | Heatmap carries the full signal; network should be filtered. |
| Trajectory / velocity | MoFlow, ddHodge_figures, ILC-NK-HIPEC | Human_endometrium, VeloCD | Pair vector/trajectory map with gene trend or state composition. |
| Benchmark + case | cPeaks, NEP_comparison, scFoundation, scPRINT | SMART, CellANOVA, CAST, AlphaGenome, Evo2 | Combine metric matrix with one biological case. |
| Genome / regulatory track | cPeaks | AlphaGenome, Evo2, GET | Treat model-only repos as concept unless plotting paths are explicit. |

## Project Transfer Output

Use this when the user gives their own project result set.

Map each panel to a code-learning asset:

```text
| user panel | plot type | input needed | best repo recipe | code path | package stack | transfer action |
```

Then give a minimal `figures/code_learning/` scaffold:

- `repo_index.tsv`: selected repos and why they are used
- `learning_plan.tsv`: panel-to-recipe learning steps
- `recipes/*.md`: one local note per repo or skill
- `toy_data/`: toy schemas only
- `scripts/`: minimal scripts written for user's project, not copied paper code

## What To Copy

Copy these:

- input table schema and object expectations
- plotting function structure
- panel ordering logic
- palette and legend discipline
- export conventions
- benchmark matrix layout
- filtered network logic

Do not copy these:

- biological claims
- disease-specific conclusions
- hidden preprocessing assumptions
- unverified model weights or large data paths
- paper-specific color semantics unless they match the user's project

## QA Before Recommending Code

Before returning a code-learning route, check:

- Does the repo path actually exist in `code_asset_inventory.md` or `code_recipe_cards.md`?
- Is the evidence level compatible with the user's request, especially "only A1"?
- Are packages confirmed from manifest/script/notebook text?
- Does the proposed panel match the user's figure template?
- Is a toy exercise possible without downloading paper-scale data?
