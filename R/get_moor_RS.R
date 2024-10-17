#' Calculate Moorland FDI rate of spread
#'
#' @param FM Fuel moisture as calculated by get_moor_FM
#' @param wind Wind speed
#' @param age Age of fuel (time since fire)
#'
#' @return Rate of Spread
#' @export
#'
#' @examples
#' get_moor_RS(18,10,25)
get_moor_RS <- function(FM,wind,age){
  age <- min(age,20)
  if(FM>100){return(0)}
  wind <- min(wind,60)
  a<-0.678
  b<-1.312
  c<-0.0243
  d<-0.116
  R <- a * (wind**b) * exp(-c * FM)* (1-exp(-d * age))
  return(R)
}
