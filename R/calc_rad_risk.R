#' Calculate radiant-heat risk index for properties
#'
#' @param prop_table The supplemented property table from gen_property_fields
#' @param fuels Data frame containing fuels data (type, loads)
#'
#' @return tibble data frame with fields for fuel break width (FBW), fireline intensity (FL) and distance risk index (DRisk)
#' @export
#'
#' @examples
#' \dontrun{
#' output <- calc_rad_risk(houses,fuel)
#'}
calc_rad_risk <- function (prop_table, fuels)
{
  proc_fire <- function(i) {
    print(i)
    this_adr <- prop_table[i, ]
    vegetation_community = this_adr$VEG_GROUP
    fb_class <- this_adr$fb_class
    slope_type <- this_adr$slope_type
    max_fire_run_distance = this_adr$maxrun
    dist <- this_adr$dist
    effective_slope <- this_adr$effective_slope
    id <- this_adr$id
    ans <- FBW_calc(fb_class, vegetation_community, slope_type,
                         effective_slope, max_fire_run_distance, fuels, id,
                         dist)
  }
  out <- purrr::map_df(1:nrow(prop_table), proc_fire)
  DRisk <- ""
  id <- 0
  prop_table$FBW <- out$FBW
  prop_table$FL <- out$FL
  prop_table$id <- out$id
  prop_table$DRisk <- out$FBW - prop_table$dist
  prop_table <- dplyr::group_by(prop_table, id)
  prop_table <- dplyr::slice(prop_table, which.max(DRisk))
  return(prop_table)
}
