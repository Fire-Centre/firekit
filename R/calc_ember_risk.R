#' Calculate ember risk
#'
#' @param prop_table Table of properties with ancillary fields added, output from generate_property_fields()
#' @param fuels Fuels table
#' @param FFDI Forest Fire Danger Index for calculation
#'
#' @return Table with ember distance and risk index added
#' @export
#'
#' @examples
#' \dontrun{
#'
#' calc_ember_risk(houses,fuels,50)
#' }
calc_ember_risk <- function(prop_table, fuels,FFDI){
  prop_table <- dplyr::left_join(prop_table,fuels,join_by(VEG_GROUP==Vegetation_Community))
  prop_table <- prop_table %>% mutate(slope_emb = case_when(slope_type  == "downslope" ~ "Hilly",
                                                            slope_type == "flat" ~ "Flat",
                                                            slope_type == "level" ~ "Flat",
                                                            slope_type == "upslope" ~ "Flat"))
  prop_table$ember_dist <- NA
  for(i in 1:nrow(prop_table)){
    prop_table$ember_dist[i] <- predict_ember(FFDI,prop_table$slope_emb[i], prop_table$SFFL[i])
  }
  prop_table$ERisk <- prop_table$ember_dist - rad_output$dist
  prop_table
}
