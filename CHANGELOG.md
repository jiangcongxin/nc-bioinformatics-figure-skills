# Changes

## Skill 2.5.0 / Shared plotting styles

- Move coordinated colors and the cowplot theme into ncfigR 0.3.0.
- Upgrade scfigR 0.4.0 and commfigR 0.3.0 task outputs with named categorical
  colors, continuous color stops, color-vision previews and palette attribution.
- Preserve input values, statistical definitions, filters and explicit palettes;
  freeze resolved display settings for reproduction. Keep commfigR-v0.2.0 intact.
- Use the shared resolver in spfigR 0.2.2. Add style arguments to trajfigR,
  benchfigR and multiomfigR 0.1.1 panel APIs without promoting them to checked tasks.
- Add real-data style comparisons and broaden package checks to all seven packages.

## spfigR 0.2.1

- Use cowplot's theme, colorspace categorical palettes/CVD simulations and scico
  continuous palettes through public APIs as the spatial plotting base.
- Add balanced, muted, vivid and Okabe-Ito styles, independently selectable feature
  palettes, strict sequential/diverging semantics and explicit category capacity.
- Freeze categorical colors, continuous color stops and CVD preview values;
  record plotting dependency versions without changing scientific source values.
- Add a real-data style comparison and document upstream roles and licenses.

## Skill 2.4.0 / spfigR 0.2.0

- Add a section-aware spatial overview task with complete spot-feature tables,
  explicit units/orientation, shared scales, consistent annotation colors and ROI zooms.
- Derive annotated spot fractions per section; retain absent categories with zeros
  and keep ROI selection separate from composition denominators.
- Export frozen inputs, exact plotting values, methods, reproduction config and
  JSON checks; use the shared task-bound review gate for inspected artwork.
- Add the public mouse-cortex Visium example with fixed checksum and CC BY 4.0
  attribution. Existing labels and expression are exported, not recomputed.
- Extend the runtime, package checks and CLI checks to four packages; leave
  commfigR 0.2.0 and its release tag unchanged.

## Skill 2.3.0 / commfigR 0.2.0 / ncfigR 0.2.2

- Add an existing-results communication task with canonical/CellChat table
  adapters, strict input contracts and condition-separated score summaries.
- Export four-panel overviews, exact display selections, methods, frozen inputs,
  reproduction configuration and actionable JSON checks; successful rendering
  remains needs_review until evidence-backed visual inspection.
- Add a task-bound generic figure review gate in ncfigR, used by commfigR.
- Preserve LR identities in heatmaps; reject condition pooling in legacy network
  panels, and sum supplied single-condition edges rather than average them.
- Add the public human-skin CellChat example with fixed object checksums and
  CC BY 4.0 attribution. Existing inference is exported, not recomputed.
- Lock the three-package runtime and extend package/CLI checks and CI coverage.
- Route communication requests to a small on-demand execution module; keep
  spatial, trajectory, benchmark and multi-omics packages explicitly experimental.

## Skill 2.2.0

- Focus the main skill on plotting and reviewing existing single-cell results.
- Move figure planning, paper/code learning and other-domain modes into optional
  references, keeping existing knowledge inventories available on demand.
- Align plugin discovery text with the bounded single-cell execution workflow.
- Preserve input confirmation, locked-runtime checks, actual visual review and
  two-attempt correction limits. No R package versions or algorithms changed.

## Stable runtime entry points

- Pin ncfigR 0.2.1 and scfigR 0.3.1 in runtime-lock.tsv.
- Add an explicit offline local installer and a runtime health check.
- Task/review entry points prefer .r-library and reject mismatched versions.
- Record third-party dependency versions without claiming a complete environment lock.
- Document version-checked reproduction through the frozen task configuration.

## ncfigR 0.2.1 / scfigR 0.3.1

- Add explicit layout widths, heights and guide handling to ncfigR composition.
- Replace independently nested six-panel rows with one explicit design and a
  feature-expression guide area; isolate long abundance/marker labels.
- Add optional named marker groups and `data.out` to marker/atlas functions.
- Export marker plotting values and reproduce named groups through job specs.
- Retain zero-inclusive expression means, detection fractions and source data.
- Record patchwork and dittoSeq design references; no source functions vendored.

## scfigR 0.3.0

- Add a fixed single-cell task executor with structured JSON input, explicit expression-scale/provenance requirements, and actionable errors.
- Preserve immutable attempt directories, source data, methods, resolved tasks, reproduction scripts and file checksums.
- Separate technical success from evidence-backed visual approval; revised and failed runs require new attempts.
- Connect the skill to execution/review entry points with bounded, presentation-only automatic correction rules.
- Test entry-point exit codes, invalid data, review payloads, changed artifacts, and frozen-input reproduction.

## ncfigR 0.2.0 / scfigR 0.2.0

- Validate table structure, finite numeric values, palette colors, unique keys, and fraction ranges before plotting.
- Preserve category order and share cell-type colors across atlas panels.
- Support custom panel labels and patchwork layout designs.
- Render exports in temporary files, close devices on errors, and preserve previous bundles on rendering failure.
- Include session information with every export; support overwrite protection.
- Reject unknown genes in Seurat expression extraction rather than silently omitting them.
- Add cell-level atlas preparation with explicit expression denominators and zero-count sample categories.
- Use a fixed fraction/point-area scale in marker dot plots.
- Add a one-call synthetic example, a checksum-verified PBMC3k workflow, data contracts, and cross-platform CI configuration.
- Add a compact publication-layout preset with explicit marker transformations and three expression maps; retain the standard atlas layout.

The other plotting packages and Codex skill remain at their existing versions.
