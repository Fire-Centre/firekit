#' fire_pal
#'
#' Create custom-length vector of color hex codes that fall within one of the many Fire Centre-themed colour palettes.
#'
#' @param n int : Number of unique color values to use.
#' @param pal chr : Internal palette choice, including 'new', 'new2', 'classic', 'blue', 'green', 'grey', 'red', 'nature', 'nature2', 'forest', 'oak', 'ochre', and 'basalt'.
#'
#' @return Vector of color hex codes using shades of UTAS-themed colours.
#' @export
#'
#' @examples
#' utas_pal(6, pal = 'grey')
#' utas_pal(3)
#'

## TODO: Update with fire-themed colours
utas_pal <- function(n = 8,
                     pal = 'new') {

  .pal = stringr::str_to_lower(pal)

  if (.pal %in% c('classic')) {
    .colors = c("#595959", "#808080", "#BFBFBF", "#d8d8d8",
                 "#F7A49E", "#F3786D", "#E32412", "#bf0813")
  } else if (.pal %in% c('new')) {
    .colors = c("#838383", "#DAE1DE", "#8AA8A3")
  } else if (.pal %in% c('new2')) {
    .colors = c("#838383", "#DAE1DE", "#AFC4BD")
  } else if (.pal %in% c('nature')) {
    .colors = c('#B0D2E1', '#B0C5BE', '#AEB797', '#C0BBA7', '#C9A695', '#848383')
  } else if (.pal %in% c('nature2')) {
    .colors = c('#D7E4EC', '#DBE0DA', '#D4DDCA', '#E3E1CD', '#E1D0C6', '#D2CECD')
  } else if (.pal %in% c('blue')) {
    .colors = c('#B0D2E1', '#D7E4EC')
  } else if (.pal %in% c("green")) {
    # .colors = c('#B0C5BE', '#DBE0DA')
    .colors <-  c("#D0DCD8", "#8AA8A3")
  } else if (.pal %in% c('forest')) {
    .colors = c('#AEB797', '#D4DDCA')
  } else if (.pal %in% c('oak')) {
    .colors = c('#C0BBA7', '#E3E1CD')
  } else if (.pal %in% c('ochre')) {
    .colors = c('#C9A796', '#E1D0C6')
  } else if (.pal %in% c('basalt')) {
    .colors = c('#848383', '#D2CECD')
  } else if (.pal %in% c('grey')) {
    .colors = c("#595959", "#808080", "#BFBFBF", "#d8d8d8")
  } else if (.pal %in% c('red')) {
    .colors = c("#F7A49E", "#F3786D", "#E32412", "#bf0813")
  } else {
    stop("Please choose a valid color scheme:\n'new', 'new2', 'classic', 'blue', 'green', 'grey', 'red', 'nature', 'nature2', 'forest', 'oak', 'ochre', or 'basalt'.")
  }

  grDevices::colorRampPalette(.colors)(n)
}
