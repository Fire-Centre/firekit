#' Calculates Moorland FDI Fuel Moisture
#'
#' @param temp Temperature in degrees C
#' @param humid Humidity percentage
#' @param rainHours Number of hours over which rainfall fell
#' @param rainAmount Amount of rainfall (mm)
#'
#' @return Moorland Fuel Moisture
#' @export
#'
#' @examples
#' get_moor_FM(12,87,24,22)
get_moor_FM<-function(temp,humid, rainHours,rainAmount){
  RF <- get_moor_RF(rainHours,rainAmount)
  HF <- get_moor_HF(temp,humid)
  return(max(RF+HF,0))
}
