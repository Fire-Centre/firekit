#' fire_tbl
#'
#' Connect to a specified database/table.
#'
#' @param query SQL SELECT query or SCHEMA.TABLE EDW reference.
#' @param db Database name or path/to/database/object.
#' @param writable Logical re: making the connection writeable. Warning: Only one individual can be connected to a database with a writable connection at a time.
#' @param proj_str Logical re: if the firekit::fire_project folder structure is used for the location of the database. Temporary measure until databsae storage is (potentially) standardised.
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
                     db = "FIRE_CENTRE_DB",
                     writable = FALSE,
                     proj_str = FALSE,
                     ...) {

  ## CHECK IF A CONNECTION OBJECT NAMED `CON` EXISTS IN THE GLOBAL ENVIRONMENT...
  if ("con" %in% ls(envir = .GlobalEnv)) {
    .con <- get("con",
                envir = .GlobalEnv)
    } else {
      ## ...OR CREATE THE DATABASE CONNECTION AND SAVE IT TO THE GLOBAL ENVIRONMENT

      if (proj_str) {
        .db <-
          here::here(glue::glue("01 Analysis/DB/{db}"))
      } else {
        .db <-
          db
      }

      if (!stringr::str_detect(.db, ".duckdb")) {
        .db <-
          glue::glue("{.db}.duckdb")
      }

      .con <-
        .db |>
        duckdb::duckdb(read_only = !writable) |>
        DBI::dbConnect()

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
      if (startsWith(tolower(stringr::str_trim(query)), "select ") |
          startsWith(tolower(stringr::str_trim(query)), "with ") |
          startsWith(tolower(stringr::str_trim(query)), "show ")) {

        .query_flag <- TRUE
        .output <- tryCatch({
          DBI::dbGetQuery(.con,
                          query) |>
            janitor::clean_names(case = "all_caps")
        },
        warning = function(cond) {
          DBI::dbGetQuery(.con,
                          query |>
                            readr::read_lines() |>
                            paste(collapse = "\n")) |>
            janitor::clean_names(case = "all_caps")
        },
        error = function(cond) {
          DBI::dbGetQuery(.con,
                          query |>
                            readr::read_lines() |>
                            paste(collapse = "\n")) |>
            janitor::clean_names(case = "all_caps")
        })


        if (startsWith(tolower(stringr::str_trim(query)), "show ")) {
          .output <-
            tibble::as_tibble(.output)
        }

      } else {

        ## TRANSFORM INPUT TABLE INFORMATION TO UPPERCASE
        .query <-
          toupper(query)

        #### CHECK IF TABLE FORMAT INCLUDES EXTERNAL SCHEMA
        if (stringr::str_count(.query, '[.]') == 1) {
          #### PARSE SCHEMA.TABLE NAMES
          .schema <-
            stringr::str_split(.query, pattern = '[.]')[[1]][1]
          .table <-
            stringr::str_split(.query, pattern = '[.]')[[1]][2]

          #### CONNECT TO TABLE
          tryCatch({
            .output <- dplyr::tbl(.con,
                                  DBI::Id(schema = .schema,
                                          table = .table)) |>
              janitor::clean_names(case = "all_caps")
          },
          warning = function(cond) {},
          error = function(cond) {
            stop(paste0("ERROR             : Denied access to `", .query, "`. Check spelling or contact an administrator for access."))
          })

          #### CONNECT TO USER-SPECIFIC TABLE IF NO SCHEMA EXISTS
        } else {

          .query <-
            paste0("main.",
                   .query)

          tryCatch({
            .output <- dplyr::tbl(.con,
                                  .query) |>
              janitor::clean_names(case = "all_caps")
          },
          warning = function(cond) {},
          error = function(cond) {
            stop(paste0("ERROR             : ", .query, " doesn't exist in personal schema. Check spelling or ensure correct schema is included."))
          })

        }
      }

    }

    # ## The "MAIN.ORIGIN" object is the one outlier where the geometry column is named something else. Sigh.
    # if ("geometry" %in% (tolower(colnames(.output)))) {
    #   .output <-
    #     dplyr::rename(.output,
    #                   shape = geometry)
    # }
    #
    # .output <-
    #   dplyr::select(.output,
    #                 !tidyselect::matches("geom"))

    #### RETURN TABLE
    return(.output)

  }
