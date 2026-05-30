# NC GitHub Code Mining Pipeline

Purpose: turn Nature Communications / Nature-series GitHub repositories into reusable plotting code patterns for local R packages. This pipeline is for static learning, not for copying paper code or rerunning full analyses.

## Mining Scope

Prioritize repositories that satisfy all three conditions:

| Requirement | Rule |
|---|---|
| journal quality | Nature Communications first; Nature Methods, Genome Biology, Nature Biotechnology, Nature, and strong companion repositories allowed |
| figure-code value | repository exposes `figures/`, `Fig*.ipynb`, `Figure*.R/py`, `SourceData`, plot scripts, RMarkdown, tutorials, or report generators |
| transferable figure skill | code teaches embedding, spatial map, heatmap, communication, trajectory, benchmark, multi-omics integration, genome track, or panel assembly |

## Evidence Levels

A1 requires explicit figure/source-data/reproduction evidence, not just a software package or model repository.

| Level | Evidence Required | Router Use |
|---|---|---|
| A1 | Explicit manuscript figure, source-data, reproduction, or plotting script path: `Figure*.R`, `Fig*.ipynb`, `figures/`, `SourceData`, `examples/report_*.py`, or figure RMarkdown. | Direct recipe and toy-data rewrite. |
| A2 | Analysis notebooks, tutorials, plotting modules, setup/requirements, or confirmed package stack, but manuscript figure scripts are incomplete. | Package design and structure learning; exact figure reproduction remains `待复核`. |
| A3 | Public repo has relevant concept but weak plotting entry, mostly model code, config, or install package. | Candidate only; do not recommend for direct replication unless user asks concept-only. |

## Mining Workflow

1. **Locate evidence**: record the concrete path, not just a repository URL.
2. **Classify figure family**: atlas, spatial, communication, trajectory, benchmark, multi-omics, genome/regulatory, or supplement QC.
3. **Extract input contract**: convert objects to source-data tables such as `embedding.tsv`, `cell_metadata.tsv`, `spatial_coordinates.tsv`, `lr_pairs.tsv`, `trajectory.tsv`, or `benchmark_metrics.tsv`.
4. **Extract package stack**: write confirmed imports and dependencies only; mark notebook-specific imports as `待复核` when not inspected.
5. **Define reusable pattern**: express the transferable idea as a panel pattern, not copied code.
6. **Map to local R package**: assign `ncfigR`, `scfigR`, `spfigR`, `commfigR`, `trajfigR`, `benchfigR`, or `multiomfigR`.
7. **Define target function**: name the local function that should eventually implement the pattern.
8. **Set follow-up status**: `ready for source-data rewrite`, `inspect imports`, `verify manuscript figure path`, `package planned`, or `candidate only`.

## Standard Output Row

Use this fixed schema when adding mined patterns:

```text
repo | paper | journal/year | biology/domain | figure_family | figure_panel | code_path | language | package_stack | input_schema | output_plot | reusable_pattern | target_r_package | target_function | evidence_level | license_note | followup_status
```

## Reuse Boundary

- Do not vendor or paste third-party repository code into local R packages.
- Learn input schemas, function boundaries, panel hierarchy, package choices, export habits, and QA checks.
- Rewrite patterns as local source-data-first functions with toy data and tests.
- Check upstream licenses before using any code fragment beyond citation-level learning.
- Keep biological claims separate from plotting templates; the user's data must supply the claim.

## Package Mapping Defaults

| Figure Family | Primary Package Target | Current Fallback |
|---|---|---|
| atlas / UMAP / marker / composition | `scfigR` | `ncfigR` |
| spatial tissue / domain / overlay / zoom | `spfigR` | `ncfigR` |
| communication / ligand-receptor / niche network | `commfigR` | `ncfigR` |
| trajectory / velocity / gene trend | `trajfigR` | `ncfigR` |
| benchmark / rank / runtime / case panel | `benchfigR` | `ncfigR` |
| multi-omics / cross-dataset / regulatory program | `multiomfigR` | `ncfigR` |

## Acceptance Checklist

- Each mined row has a concrete code path.
- A1 rows have explicit figure/source-data/reproduction evidence.
- A2 rows do not claim direct manuscript figure reproduction.
- A3 rows are clearly marked candidate-only.
- Each row maps to one target local R package and one target function.
- Each row includes source-data schema and a follow-up status.
