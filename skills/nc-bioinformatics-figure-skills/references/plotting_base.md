# Plotting Base and Coordinated Colors

Use mature components through their public APIs. Keep input validation, frozen
tables and task review in our packages; do not present copied upstream engines
as our own implementation. ncfigR owns the shared theme and color resolver.
Atlas, communication and spatial tasks use this base; trajectory, benchmark
and multi-omics panels expose style arguments but remain experimental.

| Component | Actual use | Upstream license |
|---|---|---|
| [cowplot](https://github.com/wilkelab/cowplot) | theme_half_open in the task; plot_grid in the comparison | GPL-2 |
| [colorspace](https://colorspace.R-Forge.R-project.org/) | qualitative_hcl, deutan, protan, tritan | BSD-3-Clause |
| [scico](https://github.com/thomasp85/scico) | scico continuous color stops | MIT code; Crameri maps CC BY 4.0 |
| R grDevices | palette.colors, Okabe-Ito | R license |
| patchwork | existing panel layout and shared legends | its upstream license |

Sources inspected: cowplot `R/themes.R`, commit
`b18d820d3af26b749235c4e4bc18bf416fba88e1`; scico `R/scico.R`, commit
`e94d08c334c8de7ba5dd0c405baeb578a5d2651c`. Runtime dependency versions are
recorded separately; these inspection commits are not dependency locks.
Voyager's spatial plotting code is a design reference for geometry and scale
semantics, not an installed backend. dittoSeq and SCpubr were considered for
future single-cell adapters, not adopted as active plotting engines here.

## Color styles

| color_style | Categories | Nonnegative features | Signed scores |
|---|---|---|---|
| balanced | HCL Dark 2 | lapaz | vik |
| muted | HCL Set 2, chroma 35 / luminance 65 | lajolla | broc |
| vivid | HCL Dark 3 | batlow | roma |
| okabe_ito | Okabe-Ito, at most nine | grayC | vik |

Select a complete style, then compare the same inputs at the same size. Do not
assign different category colors between maps, sections, zooms and composition.
The shared HCL resolver accepts at most 64 categories; spatial tasks retain their
30-annotation input limit. These are capacity limits, not claims that all colors
are readily distinguishable. With many groups, prefer
fewer displayed panels, direct labels or an explicit approved palette.

`feature_palette` can override the continuous palette independently:
nonnegative: lapaz, lajolla, batlow, grayC, davos, oslo;
signed: vik, broc, roma, bam. Diverging palettes are rejected for nonnegative
expression, and sequential palettes for signed scores. Signed limits are
symmetric around zero by default; supplied explicit limits retain zero as the
diverging midpoint. Task feature limits start at zero and are shared across
features. Continuous palettes are sampled at 256 stops; nonnegative palettes
are reversed. Keep supplied values unchanged.

Explicit `inputs.palette` (spatial) or `figure.palette` (atlas/communication)
takes precedence over categorical presets. Named
keys are matched to labels, not row positions. Missing keys, equivalent colors
and transparency are rejected; colors are never recycled to satisfy capacity.
The style still controls the continuous palette unless overridden.

## Inspect

`source-data/palette.tsv` freezes actual category colors;
`feature_colors.tsv` records continuous stops; `color_preview.tsv` includes
deutan/protan/tritan simulations. These previews aid review, not an accessibility
certificate. Atlas outputs use hyphenated names (`color-preview.tsv`,
`feature-colors.tsv`); communication also freezes separate condition colors.
Check small points on white, low-contrast pale groups and similar
colors after simulation. Generate alternatives through
`examples/spatial/compare_color_styles.R` and `examples/compare_package_styles.R`;
comparison runs remain needs_review. Do not automatically label a palette as
accessible or publication-ready based on capacity or successful rendering.

Attribute Scientific Colour Maps to Fabio Crameri, CC BY 4.0:
https://doi.org/10.5281/zenodo.1243909. The installed package's
`COLOR_ATTRIBUTION.md` is copied into each task's frozen source-data.
