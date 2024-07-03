#' labeless
#'
#' Remove all text labels in a ggplot object. Standard for reporting in PowerPoint.
#'
#' @return ggplot object with no labels.
#' @export
#'
#'
#' @examples
#' \dontrun{
#'
#' }

labeless <- function() {
  ggplot2::labs(x = NULL,
                y = NULL,
                fill = NULL,
                colour = NULL,
                shape = NULL,
                title = NULL,
                subtitle = NULL,
                caption = NULL,
                tag = NULL,
                alt = NULL,
                alt_insight = NULL,
                label = NULL)
}
