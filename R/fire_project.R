#' fire_project
#'
#' Creates common folder structure for new projects for consistency.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' fire_project()
#'}

fire_project <- function(quiet = FALSE,
                         dir = c("db", "od"),
                         drive = NULL,
                         number = TRUE) {

  ## TODO: Add a custom directory setting or here::here reference.
  dir <-
    rlang::arg_match(dir)

  if (!dir %in% c("db", "od")) {
    stop("Choose a working directory (dir = ...) as either Dropbox ('db') or OneDrive ('od').")
  }

  if (dir == 'od') {

    .dir <-
      glue::glue("{Sys.getenv('OneDrive')}/Biological Sciences-Fire Centre - Documents/")

  } else if (dir == 'db') {

    if (is.null(drive)) {
      .drive <-
        "C:/Users/{Sys.getenv('USERNAME')}"
    } else {
      .drive <-
        drive
      if (nchar(.drive) == 1) {
        .drive <-
          glue::glue("{.drive}:")
      }
    }

    .dir <-
      fs::dir_info(glue::glue("{.drive}/UTAS Research Dropbox/"),
                   type = "directory",
                   recurse = TRUE) |>
      dplyr::filter(stringr::str_detect(path,
                                        "/Fire Centre$")) |>
      dplyr::pull(path)

    if (length(.dir) == 0) {
      stop(glue::glue("Provided Dropbox directory not found: {.drive}/UTAS Research Dropbox/"))
    }

  }

  .date <-
    stringr::str_remove_all(substr(Sys.Date(), 1, 7), "-")

  .ls_projects <- c(
    "Ad hocs",
    "Projects"#,
    # "Sandbox"
    )

  .subfolder <-
    .ls_projects[utils::menu(title = "Choose a directory to work from:",
                 .ls_projects)]

  .dir_subfolder <- paste0(.dir,
                           .subfolder,
                           "/")

  .name_project_raw <-
    paste0(rstudioapi::showPrompt(title = "Project Name",
                                  message = "Provide a name for this project"))

  .name_project <-
    .name_project_raw |>
    stringr::str_to_lower() |>
    stringr::str_replace_all("&", "and") |>
    stringr::str_replace_all("[,.?!']", "") |>
    stringr::str_replace_all("[^A-Za-z0-9]", "_") |>
    stringr::str_replace_all("[_]++", '_') |>
    stringr::str_replace_all("_$", "")


  if (.subfolder %in% c("Ad hocs")) {
    .name_stakeholder_raw <-
      rstudioapi::showPrompt(title = "Requesting Stakeholder",
                             message = "Optional: Who requested this report or analysis?",
                             default = "First Last")

    .name_stakeholder_short <-
      sapply(strsplit(.name_stakeholder_raw, " "),
             function(x) stringr::str_extract(x, "[A-z]{1}")[1:length(x)-1]) |>
      toupper() |>
      paste(x = _, collapse = ".")


    if (nchar(.name_stakeholder_short) >= 3) {
      .name_stakeholder_short <-
        .name_stakeholder_short |>
        paste0(x = _, ". ", stringr::str_extract(.name_stakeholder_raw,
                                                 "[A-z]++$"))
    } else {
      .name_stakeholder_short <-
        .name_stakeholder_short |>
        paste0(x = _, " ", stringr::str_extract(.name_stakeholder_raw,
                                                 "[A-z]++$"))
    }


    .name_stakeholder_folder <-
      .name_stakeholder_short |>
      stringr::str_to_lower() |>
      stringr::str_replace_all("&", "and") |>
      stringr::str_replace_all("[.]", "_") |>
      stringr::str_replace_all("[,.?!']", "") |>
      stringr::str_replace_all("[^A-Za-z0-9]", "_")

    if (!tolower(stringr::str_trim(.name_stakeholder_raw)) %in% c("first last", "")) {
      .dir_project <-
        paste0(.dir_subfolder,
               ifelse(.subfolder != 'Sandbox',
                      paste0(.date,
                             "__"),
                      ""),
               .name_project, "__",
               .name_stakeholder_folder, "/")
    } else {
      .dir_project <-
        paste0(.dir_subfolder,
               ifelse(.subfolder != 'Sandbox',
                      paste0(.date,
                             "__"),
                      ""),
               .name_project, "/")
    }
  } else {

    .name_stakeholder_raw <- .name_stakeholder_short <- .name_stakeholder <- "Not applicable"

    .dir_project <-
      paste0(.dir_subfolder,
             ifelse(.subfolder == 'Ad hocs',
                    paste0(.date,
                           "__"),
                    ""),
             .name_project, "/")
  }


  tryCatch({

    .dir_00 <-
      paste0(.dir_project,
             ifelse(number,
                    "00_Background/",
                    "Background/"))
    .dir_01 <-
      paste0(.dir_project,
             ifelse(number,
                    "01_Analysis/",
                    "Analysis/"))
    .dir_02 <-
      paste0(.dir_project,
             ifelse(number,
                    "02_Results/",
                    "Results/"))
    .dir_03 <-
      paste0(.dir_project,
             ifelse(number,
                    "03_Reports/",
                    "Reports/"))

    ## Primary directories
    suppressWarnings(dir.create(.dir_project))
    suppressWarnings(dir.create(.dir_00))
    suppressWarnings(dir.create(glue::glue("{.dir_00}Documents/")))
    suppressWarnings(dir.create(glue::glue("{.dir_00}Literature/")))
    suppressWarnings(dir.create(.dir_01))
    suppressWarnings(dir.create(glue::glue("{.dir_01}Data/")))
    suppressWarnings(dir.create(glue::glue("{.dir_01}Data/DB/")))
    suppressWarnings(dir.create(glue::glue("{.dir_01}Data/Scratch/")))
    suppressWarnings(dir.create(glue::glue("{.dir_01}Scratch/")))
    suppressWarnings(dir.create(.dir_02))
    suppressWarnings(dir.create(glue::glue("{.dir_02}Figures/")))
    suppressWarnings(dir.create(glue::glue("{.dir_02}Figures/Scratch/")))
    suppressWarnings(dir.create(glue::glue("{.dir_02}Models/")))
    suppressWarnings(dir.create(glue::glue("{.dir_02}Models/Scratch/")))
    suppressWarnings(dir.create(glue::glue("{.dir_02}Tables/")))
    suppressWarnings(dir.create(glue::glue("{.dir_02}Tables/Scratch/")))
    suppressWarnings(dir.create(.dir_03))

    usethis::create_project(path = .dir_project,
                            rstudio = TRUE,
                            open = TRUE)

    fs::dir_delete(paste0(.dir_project, "R/"))

    suppressWarnings(file.create(glue::glue("{.dir_01}00_Setup.R")))

    writeLines(glue::glue("################################################################################
# Project               : {.name_project_raw}
# Date                  : {Sys.Date()}
# Requested by          : {ifelse(.name_stakeholder_raw == 'First Last', 'N/A', .name_stakeholder_raw)}
# TODOs                 : ...
################################################################################
firekit::pkgs(c('tidyverse', 'fire-centre/firekit'))"),
               glue::glue("{.dir_01}00_Setup.R"))
  },
error = function(cond) {
  stop("Directory paths too long for OneDrive. Try shortening the project name and/or using initials for the stakeholder (if relevant).")
})

  if (!quiet) {
    print(paste0('Project directories created in \'', .dir_project, '.'))
  }

}
