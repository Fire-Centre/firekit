#' fire_tbl
#'
#' Connect to a specified database/table.
#'
#' @param query SQL SELECT query or SCHEMA.TABLE EDW reference.
#' @param db Database name or path/to/database/object.
#' @param reset Logical Denotes whether to reset the connection object (`con`). Useful if needing to turn writable on/off or change databases.
#' @param writable Logical re: making the connection writeable. Warning: Only one individual can be connected to a database with a writable connection at a time.
#' @param kid int : User ID number for accessing a list of stored credentials via `keyring`. Should typically be 1 unless multiple credentials are stored on one system.
#'
#' @return Lazy connection or local database dataframe.
#' @export
#'
#' @examples
#' \dontrun{
#'
#'
#' }
#'
fire_tbl <- function(query = NULL,
                     db = "firecentre",
                     reset = FALSE,
                     writable = FALSE,
                     kid = 1,
                     ...) {

  if ("con" %in% ls(envir = .GlobalEnv) &
      reset) {
    DBI::dbDisconnect(con)
    rm(list = c("con"),
       envir = .GlobalEnv)
  }

  ## CHECK IF A CONNECTION OBJECT NAMED `CON` EXISTS IN THE GLOBAL ENVIRONMENT...
  if ("con" %in% ls(envir = .GlobalEnv) &
      !reset) {

    .con <- get("con",
                envir = .GlobalEnv)

    } else {

      ## Potential to add multiple databases as options.
      if (db %in% c("firecentre")) {

        if (db == "firecentre") {

          if (is.na(keyring::key_list(db)[kid,2])) {
            setup_flag = TRUE
          } else {
            setup_flag = FALSE
          }

          .uid = tryCatch(
            ## Check to see if username exists for the specified server name
            ## TODO: Clean this up -- it seems overly complicated(?)...
            ifelse(setup_flag,
                   warning(),
                   keyring::key_list(db)[kid,2]),
            warning = function(cond) {
              .uid = rstudioapi::askForPassword('Username')
              keyring::key_set(service = db,
                               username = .uid)
              return(.uid)
            },
            error = function(cond) {
              .uid = rstudioapi::askForPassword('Username')
              keyring::key_set(service = db,
                               username = .uid)
              return(.uid)
            }
          )

          .con <-
            DBI::dbConnect(RPostgres::Postgres(),
                           dbname = db,
                           host = "131.217.175.166",
                           user = .uid,
                           password = keyring::key_get(db, .uid))

          if (setup_flag) {

            ## TODO: Check if schema exists already.
            ##     : A schema doesn't show up this way if it doesn't have any tables written to it. Hmm.
            # .tables <-
            #   DBI::dbGetQuery(.con,
            #                   "SELECT *
            #                 FROM pg_catalog.pg_tables
            #                 WHERE schemaname != 'pg_catalog' AND
            #                 schemaname != 'information_schema';") |>
            #   dplyr::pull(schemaname) |>
            #   unique()

            .setup <-
              rstudioapi::askForPassword('Would you like to set up personal schema?')

            while (!.setup %in% c('y', 'n', 'yes', 'no')) {

              .setup <-
                rstudioapi::askForPassword("Would you like to set up personal schema? Please specify 'y', 'yes', 'n', 'no'.")

            }

            if (.setup %in% c('y', 'yes')) {

              DBI::dbGetQuery(.con,
                              glue::glue("CREATE SCHEMA AUTHORIZATION {.uid};"))
              DBI::dbGetQuery(.con,
                              glue::glue("ALTER USER '{.uid}' SET SEARCH_PATH = '{.uid}';"))
              DBI::dbGetQuery(.con,
                              glue::glue("SET SEARCH_PATH TO {.uid};"))

            }

          }

        } else {

          stop("Please provide a pre-set database connection (currently only: `firecentre`) or the direct path to a database object.")

        }

      } else {

        ## TODO: Need to allow for multiple database types here. Perhaps using `odbc()`?
        if (stringr::str_detect(db, ".duckdb")) {

          .con <-
            db |>
            duckdb::duckdb(read_only = !writable) |>
            DBI::dbConnect()

        } else {

          stop("Currently only custom {duckdb} databases are supported. Contact todd.ellis@utas.edu.au to addres.")

        }

      }

      con <<-
        .con

    }

    query_flag <-
      FALSE

    #### STOP IF NO TABLE IS SELECTED
    if (is.null(query)) {
      stop('ERROR             : Please choose a SCHEMA.TABLENAME or provide a valid SQL query.')
    } else {

      ## CHECK IF REQUESTED TABLE IS A SQL QUERY AND RUN IT!
      if (stringr::str_starts(tolower(stringr::str_trim(query)), "(alter|create|drop|select|set|update|show|with) ")) {

        .query_flag <- TRUE

        ## Check for unique PostgreSQL syntax for SHOW ALL TABLES;
        ## N.B. This is a hack-y workaround!
        if (startsWith(tolower(stringr::str_trim(query)), "show all tables") &
            class(.con)[1] == "PqConnection") {

          .output <-
            DBI::dbGetQuery(.con,
                            "SELECT *
                            FROM pg_catalog.pg_tables
                            WHERE schemaname != 'pg_catalog' AND
                            schemaname != 'information_schema';")


        } else {

          .output <- tryCatch({
            DBI::dbGetQuery(.con,
                            query)
          },
          warning = function(cond) {
            DBI::dbGetQuery(.con,
                            query |>
                              readr::read_lines() |>
                              paste(collapse = "\n"))
          },
          error = function(cond) {
            DBI::dbGetQuery(.con,
                            query |>
                              readr::read_lines() |>
                              paste(collapse = "\n"))
          })

        }

        if (startsWith(tolower(stringr::str_trim(query)), "show ")) {
          .output <-
            tibble::as_tibble(.output)
        }

      } else {

        ## Upper- or lower-case table information.
        if (class(.con) == "PqConnection") {
          .query <-
            tolower(query)
        } else {
          .query <-
            toupper(query)
        }

          tryCatch({
            .output <- dplyr::tbl(.con,
                                  I(.query))
          },
          warning = function(cond) {},
          error = function(cond) {
            stop(paste0("ERROR             : Denied access to `", .query, "`. Check spelling or contact an administrator for access."))
          })

      }

    }

    return(.output)

  }
