#' Calculate 95th percentile ember distance from FDI, slope and fuel load
#'
#' @param FDI Forest Fire Danger Index value
#' @param slope Slope type, options are "Flat" and "Hilly"
#' @param fuel Surface fuel load in t/ha
#'
#' @return Distance in m
#' @export
#'
#' @examples
#' \dontrun{
#'
#' predict_ember(40,"Flat",15)
#' }


predict_ember <- function(FDI,slope,fuel){
  require(mgcv)
  require(qgam)
  slope <- factor(slope,levels=c("Flat","Hilly"))
  pf <- data.frame(FDI = FDI,Slope = slope,surface_FL = fuel)
  exp(predict(mod,newdata=pf)[[1]])
}
