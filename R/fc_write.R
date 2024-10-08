#' fc_write
#'
#' Write to the firecentre PostgreSQL database. Creates a new table or overwrites an existing one. Separate from append and remove options to ensure their use is explicit at all times.
#'
#' @param x Dataset to push to database.
#' @param tbl Database schema and table name: Must be in `schema.table` syntax.
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

fc_write <- function(x,
                     tbl,
                     db = "firecentre") {

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

  DBI::dbWriteTableArrow(.con,
                         DBI::Id(schema = .schema,
                                 table = .table),
                         x,
                         append = FALSE)

}
