#' Fuel Break Width Calculator With Variable FFDI
#'
#' @param fb_class Fuel break class; string class1 = Managed fuel, class2 = Protective break only, class3 = high FFDI
#' @param vegetation_community Vegetation community from the Vegetation_Community field of fuel load data frame
#' @param slope_type Position of property; string upslope, downslope or none
#' @param effective_slope Slope in degrees
#' @param max_fire_run_distance Maximum fire run distance in metres
#' @param datdf Data frame with Vegetation_Community, SFFL (surface) and OFFL (overall) fine fuel loads, understory height in HGT, and Vegetation_Category ("Forest, Rainforest and Woodland", "Shrub, Scrub and Heath","Grassland" or "Tussock Moorland") to select fire model
#' @param id Point ID number
#' @param dist Distance field, unsure purpose
#' @param var_FFDI Defined FFDI for calculation
#'
#' @return Maximum fuel break width in m
#' @export
#'
#' @examples
#' \dontrun{
#'
#' FBW_calc("class1","DOB","downslope",5,340,fuel_data)
#' }

FBW_calc <- function (fb_class, vegetation_community, slope_type, effective_slope,
                      max_fire_run_distance, datdf, id, dist,var_FFDI)
{
  vegetation_category = ""
  fuel_type = ""
  RHF_THRESHOLD = 12.5
  FFDI = var_FFDI
  GFDI = var_FFDI
  V = 0
  Ws = 0
  Wo = 0
  VH = 0
  ros = 0
  fireline_intensity = 0
  Lf = 0
  Wf = 100
  moisture_factor = 5
  age = 20
  FlameAngle = 0
  FlameAngleWithMaxView = 0
  MaxViewFactor = 0
  Tf = 1100
  e = 0.95
  Sigama = 5.67 * 10^-11
  transmissivity = 1
  Hc = 18600
  h = 2
  site_slope = 0
  FBW = 0
  Ta = 0
  RH = 0.25
  L = 0
  if (fb_class == "class1") {
    FFDI = var_FFDI
    GFDI = var_FFDI
    V = 26
    Ta = 305
  }
  if (fb_class == "class2") {
    FFDI = var_FFDI
    GFDI = var_FFDI
    V = 45
    Ta = 308
  }
  if (fb_class == "class3") {
    FFDI = var_FFDI
    GFDI = var_FFDI
    V = 45
    Ta = 308
  }
  if (fb_class == "class4") {
    FFDI = var_FFDI
    GFDI = var_FFDI
    V = 65
    Ta = 308
  }
  if (max_fire_run_distance == "< 300m") {
    Wf = 50
  }
  else {
    Wf = 100
  }
  Ws = datdf$SFFL[datdf$Vegetation_Community == vegetation_community][1]
  Wo = datdf$OFFL[datdf$Vegetation_Community == vegetation_community][1]
  VH = max(0, datdf$HGT[datdf$Vegetation_Community == vegetation_community][1])
  fuel_type = datdf$Vegetation_Category[datdf$Vegetation_Community ==
                                          vegetation_community][1]
  n = 0
  d = 0
  d_increment = 1
  Rd = 0
  if (slope_type != "downslope") {
    effective_slope = 0
  }
  if (fuel_type == "Forest, Rainforest and Woodland") {
    if (slope_type == "downslope") {
      ros = 0.0012 * FFDI * Ws * exp(0.069 * effective_slope)
    }
    else {
      ros = 0.0012 * FFDI * Ws * exp(-0.069 * effective_slope)
    }
  }
  if (fuel_type == "Shrub, Scrub and Heath") {
    if (slope_type == "downslope") {
      ros = 0.023 * V^1.21 * VH^0.54 * exp(0.069 * effective_slope)
    }
    else {
      ros = 0.023 * V^1.21 * VH^0.54 * exp(-0.069 * effective_slope)
    }
  }
  if (fuel_type == "Grassland") {
    if (slope_type == "downslope") {
      ros = 0.13 * GFDI * exp(0.069 * effective_slope)
    }
    else {
      ros = 0.13 * GFDI * exp(-0.069 * effective_slope)
    }
  }
  if (fuel_type == "Tussock Moorland") {
    if (slope_type == "downslope") {
      ros = 0.024 * V^1.312 * exp(-0.0243 * moisture_factor) *
        (1 - exp(-0.116 * age)) * exp(0.069 * effective_slope)
    }
    else {
      ros = 0.024 * V^1.312 * exp(-0.0243 * moisture_factor) *
        (1 - exp(-0.116 * age)) * exp(-0.069 * effective_slope)
    }
  }
  fireline_intensity = Hc * Wo * ros/36
  if (fuel_type == "Forest, Rainforest and Woodland") {
    Lf = (13 * ros + 0.24 * Wo)/2
  }
  if (fuel_type == "Shrub, Scrub and Heath") {
    Lf = 0.0775 * fireline_intensity^0.46
  }
  if (fuel_type == "Tussock Moorland") {
    Lf = 0.0775 * fireline_intensity^0.46
  }
  if (fuel_type == "Grassland") {
    Lf = 1.192 * (fireline_intensity/1000)^0.5
  }
  ros = round(ros * 100)/100
  fireline_intensity = round(fireline_intensity)
  Lf = round(Lf * 100)/100
  d = 6
  minFBW = 6
  rec = c()
  while (abs(RHF_THRESHOLD - Rd) > 0.01 && n <= 1000) {
    MaxViewFactor = determineMaxViewFactor(d, Lf, site_slope,
                                           h, Wf)
    Rd = transmissivity * e * Sigama * MaxViewFactor * Tf^4
    rec = c(rec, Rd)
    n = n + 1
    if (Rd > RHF_THRESHOLD) {
      d = d + d_increment
    }
    else {
      d = d - d_increment
      d_increment = d_increment/10
    }
  }
  if (Rd > RHF_THRESHOLD) {
    d = d - d_increment
  }
  else {
    d = d + d_increment * 10
  }
  if (minFBW > round(d)) {
    theFBW = minFBW
  }
  else {
    theFBW = round(d)
  }
  return(data.frame(id = id, dist = dist, FBW = theFBW, FL = fireline_intensity,
                    Rd = rec[1]))
}
