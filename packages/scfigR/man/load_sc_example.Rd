\name{load_sc_example}
\alias{load_sc_example}
\title{Load the bundled synthetic atlas example}
\description{Read the small synthetic source tables bundled with scfigR. They illustrate the table formats and are not experimental evidence.}
\usage{load_sc_example()}
\value{A list containing embedding, composition, markers, module_scores, and palette.}
\examples{
example <- load_sc_example()
do.call(compose_sc_atlas_figure, example)
}
