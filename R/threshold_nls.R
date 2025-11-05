#' threshold_nls
#'
#' Identify and extract potential threshold by comparing two variables.
#'
#' @param df Dataframe output by threshold_curve.
#' @param x Variable from which a threshold is identified (x axis)
#' @param y Variable used to identify a constraining threshold (y axis)
#' @param plot Binary determining whether to automatically plot the relationships to assess the ouput.
#'
#' @return Output of broom::tidy() on nls models.
#' @export
#'
#' @examples
#' \dontrun{
#'   threshold_curve(mtcars, mpg, cyl, n_range = 25, dir = ">", extend = 0.1, rescale = F) |>
#'     threshold_nls(mpg, cyl, dir = ">", plot = TRUE)
#' }
#'

threshold_nls <- function(df, x, y, dir = ">", plot = FALSE) {
  # If the data frame is grouped, nest it, run the model on each group, and unnest.
  if (dplyr::is_grouped_df(df)) {
    return(
      df |>
        tidyr::nest() |>
        dplyr::mutate(
          model_res = purrr::map(
            data,
            ~ threshold_nls(
              df = .x,
              x = {{ x }},
              y = {{ y }},
              plot = plot
            )
          )
        ) |>
        dplyr::select(-data) |>
        tidyr::unnest(cols = model_res)
    )
  }
  .df <- df
  .dir <- dir
  .x_colname <- rlang::as_name(rlang::enquo(x))
  .y_colname <- rlang::as_name(rlang::enquo(y))

  .formula <- as.formula(paste0(
    .y_colname,
    "~ SSlogis(",
    .x_colname,
    ", Asym, xmid, scal)"
  ))

  .out <- tryCatch(
    {
      tibble::tibble(
        phi = c(
          "asymptote",
          "curve inflection point",
          "curve scale parameter"
        )
      ) |>
        ## {minpack.lm} is supposedly better than {stats} here....but we'll see.
        dplyr::bind_cols(
          minpack.lm::nlsLM(formula = .formula, data = df) |>
            broom::tidy()
        )
    },
    error = function(cond) {
      warning(
        "One or more models failed to run. Try increasing the `extend` value of the `threshold_curve` function to values between 0.1 and 0.3 as a potential fix."
      )
      tibble::tibble(
        phi = c(
          "asymptote",
          "curve inflection point",
          "curve scale parameter"
        ),
        term = c("Asym", "xmid", "scal"),
        estimate = rep(NA_real_, 3),
        std.error = rep(NA_real_, 3),
        statistic = rep(NA_real_, 3),
        p.value = rep(NA_real_, 3)
      )
    }
  )

  .ymin = min(dplyr::pull(.df, {{ y }}), na.rm = TRUE)
  .ymax = max(dplyr::pull(.df, {{ y }}), na.rm = TRUE)
  .threshold <- dplyr::filter(.out, term == "xmid") |>
    dplyr::pull(estimate)

  ## TODO: WARNING here, the percentile associated with the NLS threshold is simply the *nearest* value in the actual data above the threshold. See, for example, the percentile column does not 1:1 associate with the {{ y }} column, but is impacted by the actual data distributions.
  .x_int <- dplyr::arrange(.df, {{ x }}) |>
    dplyr::filter({{ x }} >= .threshold) |>
    dplyr::slice(1) |>
    dplyr::mutate(
      {{ x }} := .threshold,
      percentile = {{ y }} / .ymax,
      threshold_desc = "Non-linear least squares"
    ) |>
    dplyr::bind_rows(
      dplyr::filter(.df, {{ y }} >= (0.05 * .ymax)) |>
        dplyr::arrange(
          if (.dir == ">") {
            dplyr::desc({{ x }})
          } else {{ x }}
        ) |>
        dplyr::slice(1) |>
        dplyr::mutate(percentile = 0.05) |>
        dplyr::bind_rows(
          dplyr::filter(.df, {{ y }} >= (0.1 * .ymax)) |>
            dplyr::arrange(
              if (.dir == ">") {
                dplyr::desc({{ x }})
              } else {{ x }}
            ) |>
            dplyr::slice(1) |>
            dplyr::mutate(percentile = 0.1)
        ) |>
        dplyr::bind_rows(
          dplyr::filter(.df, {{ y }} >= (0.25 * .ymax)) |>
            dplyr::arrange(
              if (.dir == ">") {
                dplyr::desc({{ x }})
              } else {{ x }}
            ) |>
            dplyr::slice(1) |>
            dplyr::mutate(percentile = 0.25)
        ) |>
        dplyr::bind_rows(
          dplyr::filter(.df, {{ y }} >= (0.5 * .ymax)) |>
            dplyr::arrange(
              if (.dir == ">") {
                dplyr::desc({{ x }})
              } else {{ x }}
            ) |>
            dplyr::slice(1) |>
            dplyr::mutate(percentile = 0.5)
        ) |>
        dplyr::bind_rows(
          dplyr::filter(.df, {{ y }} >= (0.75 * .ymax)) |>
            dplyr::arrange(
              if (.dir == ">") {
                dplyr::desc({{ x }})
              } else {{ x }}
            ) |>
            dplyr::slice(1) |>
            dplyr::mutate(percentile = 0.75)
        ) |>
        dplyr::bind_rows(
          dplyr::filter(.df, {{ y }} >= (0.9 * .ymax)) |>
            dplyr::arrange(
              if (.dir == ">") {
                dplyr::desc({{ x }})
              } else {{ x }}
            ) |>
            dplyr::slice(1) |>
            dplyr::mutate(percentile = 0.9)
        ) |>
        dplyr::bind_rows(
          dplyr::filter(.df, {{ y }} >= (0.95 * .ymax)) |>
            dplyr::arrange(
              if (.dir == ">") {
                dplyr::desc({{ x }})
              } else {{ x }}
            ) |>
            dplyr::slice(1) |>
            dplyr::mutate(percentile = 0.95)
        ) |>
        dplyr::bind_rows(
          dplyr::filter(.df, {{ y }} >= (0.975 * .ymax)) |>
            dplyr::arrange(
              if (.dir == ">") {
                dplyr::desc({{ x }})
              } else {{ x }}
            ) |>
            dplyr::slice(1) |>
            dplyr::mutate(percentile = 0.975)
        ) |>
        dplyr::bind_rows(
          dplyr::filter(.df, {{ y }} >= (0.99 * .ymax)) |>
            dplyr::arrange(
              if (.dir == ">") {
                dplyr::desc({{ x }})
              } else {{ x }}
            ) |>
            dplyr::slice(1) |>
            dplyr::mutate(percentile = 0.99)
        ) |>
        dplyr::mutate(
          threshold_desc = scales::percent(
            percentile,
            accuracy = ifelse(percentile == 0.975, 0.1, 1)
          )
        )
    )

  if (plot) {
    p <-
      ggplot2::ggplot(
        data = .df,
        mapping = ggplot2::aes(x = {{ x }}, y = {{ y }})
      )

    # Add the vertical lines if there are any valid intercept values
    if (nrow(.x_int) > 0 && !all(is.na(.x_int))) {
      `%>%` <- magrittr::`%>%`
      p <- p +
        ggplot2::geom_linerange(
          data = dplyr::filter(.x_int, threshold_desc == "Percentile"),
          mapping = ggplot2::aes(ymax = {{ y }}),
          ymin = .ymin,
          linewidth = 0.7,
          alpha = 0.45,
          linetype = "dotdash"
        ) +
        ggplot2::geom_linerange(
          data = . %>%
            dplyr::arrange({{ x }}) %>%
            dplyr::filter({{ x }} >= .threshold) %>%
            dplyr::slice(1),
          mapping = ggplot2::aes(ymax = {{ y }}),
          ymin = .ymin,
          linewidth = 1,
          color = "darkred",
          alpha = 0.45,
          linetype = "dotdash"
        )
    }

    p <- p +
      ggplot2::geom_line() +
      # ggplot2::geom_smooth(method = "glm", method.args = list(family = "binomial"), se = FALSE, col = "grey40") +
      ggplot2::theme_classic()

    # Instead of just printing, return the plot object along with the results
    return(list(nls = .out, thresholds = .x_int, plot = p))
  }

  # If not plotting, return results directly or in a list for consistency
  # Returning a list is better for the recursive grouped call
  return(list(nls = .out, thresholds = .x_int))
}
