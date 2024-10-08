#' fc_index
#'
#' Manage indices in the `firecentre` PostgreSQL database. N.B. May be better to manage these from withing pgAdmin.
#'
#' @param tbl Database schema and table name used when creating indices: Must be in `schema.table` syntax.
#' @param db Database name or path/to/database/object.
#'
#' @return Data exported to database.
#' @export
#'
#' @examples
#' \dontrun{
#'
#'
#' }
#'

fc_index <- function(idx_name,
                     idx_cols = NULL,
                     tbl = NULL,
                     unique = FALSE,
                     drop = FALSE,
                     db = "firecentre") {

  if ((is.null(tbl) | is.null(idx_cols)) &
      !drop) {

    stop("Provide arguments for `idx_cols` and `tbl` when creating indices.")

  }

  .tbl <-
    tbl

  if (stringr::str_count(.tbl, '[.]') != 1) {
    stop("Please provide table name (`tbl`) using schema.table syntax. Do not use periods within the table name.")
  } else {
    .schema <-
      stringr::str_split(.tbl, pattern = '[.]')[[1]][1]
    .table <-
      stringr::str_split(.tbl, pattern = '[.]')[[1]][2]
  }

  if ("con" %in% ls(envir = .GlobalEnv)) {

    .con <- get("con",
                envir = .GlobalEnv)

  } else {

    if (db == "firecentre") {

      .con <-
        DBI::dbConnect(RPostgres::Postgres(),
                       dbname = db,
                       host = "131.217.175.166",
                       user = .uid,
                       password = keyring::key_get(db, keyring::key_list(service = "firecentre")[1,2]))

    } else {

      stop("This function only supports the `firecentre` PostgreSQL database at this time.")

    }

    con <<-
      .con

  }

  if (!drop) {
    .query <-
      glue::glue("CREATE INDEX {idx_name} ON {.schema}.{.table} ({paste0(idx_cols, collapse = ', ')});")

    if (unique) {
      .query <-
        stringr::str_replace(.query,
                             "CREATE INDEX",
                             "CREATE UNIQUE INDEX")
    }

  } else {
    ## May need to consider CASCADE at some point.
    .query <-
      glue::glue("DROP INDEX IF EXISTS {idx_name};")

  }

  fire_tbl(.query)

}
