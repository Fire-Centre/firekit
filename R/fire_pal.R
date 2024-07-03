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
#'

fire_pal <- function(n = 5,
                     pal = 'fire') {

  .pal = stringr::str_to_lower(pal)

  if (!.pal %in% c("bw", "climate", "fire", "grey", "red", "rfs", "utas", "utas2")) {
    stop("Please choose a valid color scheme:\n' 'bw', 'climate', 'fire', 'grey', 'red', 'rfs', 'utas', 'utas2'.")
  }

  .colors <-
    if (.pal %in% c("climate")) {
      c("#D73027", "#FC8D59", "#FEE090", "#E0F3F8", "#91BFDB", "#4575B4")
    } else if (.pal %in% c("fire")) {
      c("brown", "red", "orange", "yellow", "lightyellow")
    } else if (.pal %in% c("grey")) {
      c("#595959", "#808080", "#BFBFBF", "#d8d8d8")
    } else if  (.pal %in% c("red")) {
      c("#F7A49E", "#F3786D", "#E32412", "#bf0813")
    } else if (.pal %in% c("rfs")) {
      c("#595959", "#AD0909", "#F78100", "#FEDD3A", "#64BF30")
    } else if (.pal %in% c("utas")) {
      c("#838383", "#DAE1DE", "#8AA8A3")
    } else if (.pal %in% c("utas2")) {
      c("#595959", "#808080", "#BFBFBF", "#d8d8d8", "#F7A49E", "#F3786D", "#E32412", "#bf0813")
    } else {
      c("black", "white")
    }

  grDevices::colorRampPalette(.colors)(n)
}
