#' Calculate moorland FDI humidity factor
#'
#' @param temp Temperature in degrees C
#' @param humid Humidity percentage
#'
#' @return Moorland FDI Humidity Factor
#' @export
#'
#' @examples
#' get_moor_HF(12,87)
get_moor_HF<-function(temp,humid){
  temp<-max(temp,8)
  temp<-min(temp,35)
  RH<-max(humid,20)
  RH<-min(humid,100)
  y <-exp(2.572e+00 + (-2.563e-02 * temp) + (-3.288e-05 * temp^2) + (5.218e-03 * RH) + (6.673e-05 * RH ^2))
  return(y)
}
