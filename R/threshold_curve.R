#' threshold_curve
#'
#' Reframe data for extracting a threshold or exploring causal relationships.
#'
#' @param df Dataframe
#' @param x Variable from which a threshold is identified (x axis)
#' @param y Variable used to identify a constraining threshold (y axis)
#' @param n_range Number of values to use to blow out the x axis and identify a threshold.
#' @param dir Direction along x axis constraining the threshold.
#' @param extend Value between 0 and 1 to blow out the x axis (sometimes important if threshold is near the upper or lower limits; this can crash the model)
#' @param rescale Whether to rescale the y axis to between 0 and 1.
#'
#' @return Dataframe prepared for threshold_nls(...)
#' @export
#'
#' @examples
#' \dontrun{
#'   threshold_curve(mtcars, mpg, cyl, n_range = 25, dir = ">", extend = 0.1, rescale = F)
#' }
#'

threshold_curve <- function(
    df,
    x,
    y,
    n_range = 100,
    dir = c(">", "<"),
    extend = NULL,
    rescale = FALSE
) {
  # If the data frame is grouped, nest it, run the model on each group, and unnest.
  if (dplyr::is_grouped_df(df)) {
    # Use {{}} to correctly pass the column names to the recursive call
    return(
      df |>
        tidyr::nest() |>
        dplyr::mutate(
          model_res = purrr::map(
            data,
            ~ threshold_curve(
              df = .x,
              x = {{ x }},
              y = {{ y }},
              n_range = n_range,
              dir = dir,
              extend = extend,
              rescale = rescale
            )
          )
        ) |>
        dplyr::select(-data) |>
        tidyr::unnest(cols = model_res)
    )
  }

  .dir = rlang::arg_match(dir)
  .vals <- dplyr::pull(df, {{ x }})
  .max = max(.vals, na.rm = TRUE)
  .min = min(.vals, na.rm = TRUE)
  if (!is.null(extend)) {
    if (!dplyr::between(extend, 0, 1)) {
      stop("`extend` parameter must be between 0 and 1")
    }
    .max <- .max + (.max * extend)
    .min <- .min - (.max * extend)
  }
  .range = seq(from = .min, to = .max, length.out = n_range)

  .df <- purrr::map_df(.range, function(threshold) {
    dplyr::filter(
      df,
      if (.dir == ">") {
        {{ x }} > threshold
      } else {
        {{ x }} < threshold
      }
    ) |>
      dplyr::summarise(
        {{ x }} := threshold,
        {{ y }} := sum({{ y }}, na.rm = TRUE)
      )
  }) |>
    tidyr::fill({{ y }}, .direction = "downup")

  if (rescale) {
    .df <-
      dplyr::mutate(
        .df,
        {{ y }} := scales::rescale({{ y }}, to = c(0, 1))
      )
  }

  return(tibble::as_tibble(.df))
}
