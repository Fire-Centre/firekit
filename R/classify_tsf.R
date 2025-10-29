#' classify_tsf
#'
#' Classify raster time since fire into bins
#'
#' @param raster Raster ({terra}).
#' @param mask Optional raster mask layer.
#'
#' @return Raster layer with time since fire classes.
#' @export
#'
#' @examples
#' \dontrun{
#'
#' }
#'
classify_tsf <- function(raster, mask = NULL) {
  .reclass_matrix <- matrix(
    c(
      -1,
      2,
      1,
      2,
      5,
      2,
      5,
      10,
      3,
      10,
      20,
      4,
      20,
      30,
      5,
      30,
      Inf,
      6
    ),
    ncol = 3,
    byrow = TRUE
  )

  .max <- terra::minmax(raster)[2]

  raster[is.na(raster)] <- .max + 1

  if (!is.null(mask)) {
    raster <- terra::mask(raster, mask)
  }

  .raster_reclass <- terra::classify(raster, .reclass_matrix)

  return(.raster_reclass)
}
