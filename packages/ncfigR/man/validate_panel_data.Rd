\name{validate_panel_data}
\alias{validate_panel_data}
\title{Validate a source-data table before plotting}
\description{Reject empty tables, missing columns or values, non-finite numeric values, and duplicate keys.}
\usage{
validate_panel_data(data, required, numeric_cols = character(),
  key_cols = character(), data_name = "data")
}
\arguments{
\item{data}{A non-empty data frame with unique column names.}
\item{required}{Character vector of required column names. These columns cannot contain missing or blank values.}
\item{numeric_cols}{Columns that must contain finite numeric values.}
\item{key_cols}{Columns whose combined values must identify unique rows.}
\item{data_name}{Table name used in error messages.}
}
\value{The input table, invisibly.}
\examples{
validate_panel_data(data.frame(x = 1, y = 2), c("x", "y"), c("x", "y"))
}
