#' fhi_nls
#'
#' Run a non-linear least squares algorithm on the output of the `r_fhi_curve` function and extract the fire heterogeneity index. Optionally plot the outcome.
#'
#' @param x Output of `r_fhi_curve`.
#' @param start_fhi Start parameter for calculating the FHI from the NLS algorithm. Change if processing errors.
#' @param plot Flag to plot the outcome curve and the identified FHI.
#'
#' @return Either a ggplot output or a single FHI value.
#' @export
#'
#' @examples
#' \dontrun{
#'
#' }
#'

fhi_nls <- function(x, start_fhi = 0.01, plot = FALSE) {
  .mod <-
    stats::nls(
      area ~ 1 / (10^(fhi * buffer)),
      data = x,
      start = list(fhi = start_fhi)
    )

  .fhi <-
    stats::coef(.mod)

  if (plot) {
    .p <-
      .mod |>
      broom::augment() |>
      ggplot2::ggplot(mapping = ggplot2::aes(x = buffer)) +
      ggplot2::geom_point(mapping = ggplot2::aes(y = area), alpha = 0.45) +
      ggplot2::geom_line(
        mapping = ggplot2::aes(y = .fitted),
        linetype = "solid",
        linewidth = 1.5,
        alpha = 0.65
      ) +
      ggplot2::theme_classic() +
      ggplot2::scale_x_continuous(
        labels = scales::comma,
        limits = c(0, NA_real_)
      ) +
      ggplot2::scale_y_continuous(
        labels = scales::percent,
        limits = c(0, 1.05)
      ) +
      ggplot2::coord_cartesian(expand = 0) +
      ggplot2::labs(
        x = "Internal buffer distance",
        y = "% area",
        title = glue::glue(
          "Fire heterogeneity index: {round(.fhi, digits = 5)}"
        )
      )

    return(.p)
  } else {
    return(.fhi)
  }
}
