# Plotting components

This package calls upstream public APIs; it does not vendor their implementation.

- cowplot, Claus O. Wilke: theme_half_open; GPL-2.
  https://github.com/wilkelab/cowplot
- colorspace, Ross Ihaka, Paul Murrell, Kurt Hornik, Jason C. Fisher, Reto
  Stauffer, Claus O. Wilke, Claire D. McWhite and Achim Zeileis: qualitative_hcl
  and color-vision simulations; BSD-3-Clause.
  https://colorspace.R-Forge.R-project.org/
- scico, Thomas Lin Pedersen: scico; MIT package code.
  https://github.com/thomasp85/scico
- Scientific Colour Maps, Fabio Crameri: color data supplied by scico, CC BY 4.0.
  https://doi.org/10.5281/zenodo.1243909
  https://creativecommons.org/licenses/by/4.0/
  Sequential maps are sampled and reversed; diverging maps are sampled without
  reversal. These operations do not imply endorsement by the palette authors.
- R grDevices: palette.colors, Okabe-Ito categorical palette. R's own license
  and attribution remain applicable.

Color data exported to source-data retain this attribution; the project's code
license does not replace upstream code or color-data licenses. See each installed
dependency's license before redistributing the dependency itself.
