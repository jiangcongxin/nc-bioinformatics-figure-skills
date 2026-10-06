spatial_fixture <- function() {
  list(coordinates = readr::read_tsv(system.file("extdata/overview_coordinates.tsv", package = "spfigR"),
    col_types = readr::cols(spot_id = readr::col_character())),
    features = readr::read_tsv(system.file("extdata/overview_features.tsv", package = "spfigR"),
      col_types = readr::cols(spot_id = readr::col_character())))
}
