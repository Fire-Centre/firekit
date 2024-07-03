#' compare_cols
#'
#' Quick method to compare columns and classes between datasets. Primarily intended for EDW data -- comparable functions (e.g., `janitor::compare_df_cols`) do not work with Oracle connections.
#'
#' @param .x EDW-pulled table or query.
#' @param .y EDW-pulled table or query.
#' @param .z EDW-pulled table or query.
#'
#' @return Dataframe with column names, classes, and source (.x, .y., and/or .z).
#' @export
#'
#' @examples
#' \dontrun{
#' }

## TODO: Currently seems to duplicate column data.

compare_cols <- function(.x = NULL,
                         .y = NULL,
                         .z = NULL,
                         view = TRUE) {
  if (is.null(.x) & is.null(.y) & is.null(.z)) {
    stop("Please provide at least one dataset or EDW connection.")
  }

  summarise_classes <- function(x, .src) {
    x %>%
      head(1) %>%
      dplyr::collect() %>%
      dplyr::summarise(dplyr::across(tidyselect::everything(),
                                     class)) %>%
      tidyr::pivot_longer(cols = tidyselect::everything(),
                          names_to = ".colname",
                          values_to = ".class") %>%
      dplyr::mutate(.src = .src)
  }

  .lgl <- function(x) {
    as.numeric(!is.na(x))
  }

  if (!is.null(.x)) {
    .x <-
      summarise_classes(x = .x,
                        .src = dplyr::row_number()) %>%
      dplyr::rename(.x = .src)
  }

  if (!is.null(.y)) {
    .y <-
      summarise_classes(x = .y,
                        .src = dplyr::row_number()) %>%
      dplyr::rename(.y = .src)
  }

  if (!is.null(.z)) {
    .z <-
      summarise_classes(x = .z,
                        .src = dplyr::row_number()) %>%
      dplyr::rename(.z = .src)
  }

  if (!is.null(.x) & !is.null(.y) & !is.null(.z)) {
    output =
      .x %>%
      dplyr::full_join(.y,
                       by = c(".colname", ".class")) %>%
      dplyr::full_join(.z,
                       by = c(".colname", ".class")) %>%
      dplyr::distinct() %>%
      dplyr::mutate(.src_n = (.lgl(.x) + .lgl(.y) + .lgl(.z)))
  } else if (!is.null(.x) & !is.null(.y)) {
    output =
      .x %>%
      dplyr::full_join(.y,
                       by = c(".colname", ".class")) %>%
      dplyr::distinct() %>%
      dplyr::mutate(.src_n = (.lgl(.x) + .lgl(.y)))
  } else if (!is.null(.x) & !is.null(.z)) {
    output =
      .x %>%
      dplyr::full_join(.z,
                       by = c(".colname", ".class")) %>%
      dplyr::distinct() %>%
      dplyr::mutate(.src_n = (.lgl(.x) + .lgl(.z)))
  } else if (!is.null(.y) & !is.null(.z)) {
    output =
      .y %>%
      dplyr::full_join(.z,
                       by = c(".colname", ".class")) %>%
      dplyr::distinct() %>%
      dplyr::mutate(.src_n = (.lgl(.y) + .lgl(.z)))
  } else if (!is.null(.x)) {
    output =
      .x
  } else if (!is.null(.y)) {
    output =
      .y
  } else if (!is.null(.z)) {
    output =
      .z
  } else {
    stop("Please provide at least one dataset or EDW connection.")
  }

  if (ncol(output) >= 4) {
    output =
      output %>%
      dplyr::filter(.class != 'POSIXt') %>%
      dplyr::group_by(.colname) %>%
      dplyr::mutate(.class_n = dplyr::n_distinct(.class)) %>%
      dplyr::ungroup()
  }

  if (view) {
    return(View(output))
  } else {
    return(output)
  }
}
