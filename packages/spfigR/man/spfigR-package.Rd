\name{spfigR-package}
\alias{spfigR-package}
\alias{spfigR}
\alias{plot_spatial_domain_panel}
\alias{plot_spatial_feature_panel}
\alias{plot_spatial_composition_panel}
\alias{plot_spatial_zoom_panel}
\alias{compose_spatial_niche_figure}
\docType{package}
\title{NC-Style Spatial Omics Figure Toolkit}
\description{
Source-data-first R functions for training and generating NC-style spatial tissue niche figures.
}
\arguments{
\item{data}{A source-data data frame for one panel.}
\item{domain_col}{Spatial domain or niche column.}
\item{x_col}{Spatial x-coordinate column.}
\item{y_col}{Spatial y-coordinate column.}
\item{palette}{Named color vector or palette data frame.}
\item{point_size}{Point size for spatial coordinate panels.}
\item{alpha}{Point alpha for spatial coordinate panels.}
\item{title}{Panel or figure title.}
\item{value_col}{Numeric feature value or composition value column.}
\item{feature_col}{Optional feature/module column for faceting.}
\item{group_col}{Sample, region, group, or condition column.}
\item{category_col}{Categorical column for domain, niche, or cell type.}
\item{position}{Bar position for composition panels.}
\item{regions}{Zoom region table with region_id, xmin, xmax, ymin, and ymax.}
\item{region_id}{Optional region identifier to select one or more zoom regions.}
\item{spatial_coordinates}{Spatial coordinate source-data table.}
\item{spatial_features}{Spatial feature source-data table.}
\item{spatial_composition}{Spatial composition source-data table.}
\item{zoom_regions}{Optional zoom region source-data table.}
}
\usage{
plot_spatial_domain_panel(data, domain_col = "domain", x_col = "x", y_col = "y",
  palette = NULL, point_size = 0.8, alpha = 0.9, title = NULL)

plot_spatial_feature_panel(data, value_col = "feature_value", x_col = "x",
  y_col = "y", feature_col = NULL, point_size = 0.8, alpha = 0.9,
  title = NULL)

plot_spatial_composition_panel(data, group_col = "sample", category_col = "domain",
  value_col = "proportion", palette = NULL, position = c("fill", "stack", "dodge"),
  title = NULL)

plot_spatial_zoom_panel(data, regions, region_id = NULL, domain_col = "domain",
  x_col = "x", y_col = "y", palette = NULL, point_size = 1.2, alpha = 0.95,
  title = NULL)

compose_spatial_niche_figure(spatial_coordinates, spatial_features,
  spatial_composition, zoom_regions = NULL, palette = NULL, domain_col = "domain",
  title = "Spatial tissue niche overview")
}
\details{
The package builds on \pkg{ncfigR} for shared theme, palette, composition, and export behavior.
}
\keyword{package}
