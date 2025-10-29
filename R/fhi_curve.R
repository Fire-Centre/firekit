#' fhi_curve
#'
#' Calculate a fire heterogeneity index curve for a raster layer with showing fires.
#'
#' @param raster {terra} SpatRaster reflecting fires (either binary 1/0 or FESM severity data).
#' @param step Step to use for internal buffers. User larger values on larger fires, smaller values on smaller fires.
#' @param filter_severity Flag to filter fire severity to high and extreme fires *if* the raster input layer is FESM.
#'
#' @return Dataframe prepared for fhi_nls(...)
#' @export
#'
#' @examples
#' \dontrun{
#'
#' }
#'

fhi_curve <- function(raster, step = 10, filter_severity = TRUE) {
  .r <- raster

  if (filter_severity) {
    .r[.r <= 3] <- NA
  }

  .r[!is.na(.r)] <- 1

  .v <- terra::as.polygons(.r) |>
    sf::st_as_sf()

  .d <- list()

  .idx <- 1
  .flag <- FALSE

  .area_total <- sum(as.numeric(sf::st_area(.v)))

  while (!.flag) {
    .dist <- step * (.idx - 1)

    .buffer <- sf::st_buffer(.v, -.dist)

    .area_buffer <- sum(as.numeric(sf::st_area(.buffer)))

    if (.area_buffer <= 0) {
      .flag = TRUE
    }

    .d[[.idx]] <- tibble::tibble(
      buffer = .dist,
      area = .area_buffer / .area_total
    )

    .idx <- .idx + 1
  }

  .d <- dplyr::bind_rows(.d)

  return(.d)
}
