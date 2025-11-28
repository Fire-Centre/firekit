#' Generate sf vector line in a given direction from point, default north-west
#'
#' @param point sf point object
#' @param dist Distance in meters
#' @param ang Angle in degrees
#'
#' @return Data frame with slope, r2 value and angle in degrees
#' @export
#'
#' @examples
#' nw_vector(sf::st_as_sf(data.frame(x=521310,y=5244614),coords=c("x","y"),crs=28355),350)
nw_vector=function(point,dist=350,ang=315){
  out = line_vector(point,ang,dist)
  sf::st_sfc(out,crs=sf::st_crs(point))
}
