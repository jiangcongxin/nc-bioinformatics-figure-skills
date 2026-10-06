# Changes

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
