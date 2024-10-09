#' fc_write
#'
#' Write to the firecentre PostgreSQL database. Creates a new table or either overwrites or appends to an existing table.
#'
#' @param x Dataset to push to database.
#' @param tbl Database schema and table name: Must be in `schema.table` syntax.
#' @param chunk_size Number of rows to insert into the database at a time.
#' @param db Database name or path/to/database/object.
#' @param create Logical denoting whether to create a new table or overwrite an existing one.
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
                     chunk_size = NULL,
                     db = "firecentre",
                     create = FALSE) {

  .tbl <-
    tbl

  if (stringr::str_count(.tbl, '[.]') != 1) {
    stop("Please provide an explicit schema and table name (`tbl`) using schema.table syntax. Do not use periods within the table name.")
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
                       user = keyring::key_list(service = "firecentre")[1,2],
                       password = keyring::key_get(db, keyring::key_list(service = "firecentre")[1,2]))

    } else {

      stop("This function only supports the `firecentre` PostgreSQL database at this time.")

    }

    con <<-
      .con

  }

  if (create) {

    tryCatch({

      DBI::dbCreateTableArrow(.con,
                              DBI::Id(schema = .schema,
                                      table = .table),
                              nanoarrow::infer_nanoarrow_schema(x))

    },
    error = function(cond) {

      DBI::dbRemoveTable(.con,
                         DBI::Id(schema = .schema,
                                 table = .table))

      DBI::dbCreateTableArrow(.con,
                              DBI::Id(schema = .schema,
                                      table = .table),
                              nanoarrow::infer_nanoarrow_schema(x))
    })

  }

  if (!is.null(chunk_size) &
      is.numeric(chunk_size)) {

    ## This is heavily borrowed from https://github.com/mpio-be/sdb/
    split_data <-
      split(1:nrow(x),
            ceiling(seq_along(1:nrow(x)) / chunk_size))

    o <-
      vector(length = length(split_data))

    pb <-
      utils::txtProgressBar(max = length(split_data),
                            style = 3)

    for (i in 1:length(split_data)) {

      df <-
        x[ (split_data[[i]]), ]

      o[i] <-
        DBI::dbWriteTableArrow(.con,
                               DBI::Id(schema = .schema,
                                       table = .table),
                               df,
                               append = TRUE)

      utils::setTxtProgressBar(pb, i)
    }

    all(o)

  } else {

    DBI::dbWriteTableArrow(.con,
                           DBI::Id(schema = .schema,
                                   table = .table),
                           x,
                           append = TRUE)

  }

}
