#' Calculate Moorland Fire Danger Index
#'
#' @param rain Rainfall amount (mm)
#' @param temp Temperature (degrees C)
#' @param RH Relative humidity (RH)
#' @param wind Wind speed
#' @param age Age of fuel (time since fire)
#' @param time Vector of time values in minutes or days
#' @param daily If time data is daily set to TRUE, otherwise if it is in minutes set to FALSE
#'
#' @return Moorland FDI
#' @export
#'
#' @examples
#' calc_MFDI(rain=c(0,20,10,4),
#' temp=c(12,13,8,9),
#' RH=c(55,87,90,67),
#' wind=c(5,8,9,9),
#' age=c(25,25,25,25),
#' time=c(1,2,3,4),
#' daily=TRUE)
calc_MFDI<-function(rain,temp,RH,wind,age,time,daily=FALSE){
  MFDI <- rep(0,length(rain))
  tdiff<-c(0,diff(time))
  if(daily==TRUE){
    tdiff<-tdiff/24
  }else{
    tdiff<-tdiff/3600
  }
  oframe <- data.frame(Rain=rain,Temp=temp,RH=RH,Wind=wind,Age=age)
  oframe$SinceRain <- 0
  SinceRain<-48
  for(i in seq_along(oframe$Rain)){
    if(oframe$Rain[i]>0){
      SinceRain<-0

    }else{
      SinceRain <- SinceRain + tdiff[i]

    }
    oframe$SinceRain[i]<-SinceRain
  }

  for(i in seq_along(MFDI)){
    FM<-get_moor_FM(oframe$Temp[i],oframe$RH[i], oframe$SinceRain[i],oframe$Rain[i])
    SR<-get_moor_RS(FM,oframe$Wind[i],oframe$Age[i])
    MFDI[i]<-RS_to_MFI(SR)
  }
  return(MFDI)
}

