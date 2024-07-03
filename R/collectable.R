#' collectable
#'
#' Wraps a timer around functions that pulls a lazy database query into memory. Note: This function is re-purposed from `toddellis/miao`.
#'
#' @param x : dataset
#' @param qid chr: optional query identifier to assign to query
#' @param format chr: output format type, either via `data.table`, `dtplyr`, or `tibble`
#'
#' @return A queried database connection stored in local memory and the time it took to pull into memory.
#' @export
#'
#'

collectable <- function(x,
                        qid = 'query',
                        format = 'tibble') {

  if (is.null(qid) || is.na(qid)) {
    qid = 'query'
  }

  tictoc::tic(paste0('Time to collect ', qid))

  output <- if (format %in% c('data.table', 'dt')) {
    x %>%
      data.table::as.data.table()
  } else if (format == 'lazy') {
    x %>%
      dtplyr::lazy_dt()
  } else if (format %in% c('tbl', 'tibble', 'tidy')) {
    x %>%
      dplyr::collect() %>%
      tibble::as_tibble()
  } else {
    stop('ERROR             : Please choose either a `data.table` (default), `lazy`, or `tibble` format for the output.')
  }

  tictoc::toc()

  return(output)
}

