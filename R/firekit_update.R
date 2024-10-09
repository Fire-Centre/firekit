#' firekit_update
#'
#' Sets or pulls stored GitHub credentials and initiates updates of firekit package.
#'
#' @param dependencies Option to list dependencies to install.
#' @param force Option to force install even if currently running.
#'
#' @return Installed packages
#' @export
#'
#' @examples
#' \dontrun{
#' firekit_update(force = TRUE)
#' }

firekit_update <- function(dependencies = NA,
                           force = FALSE) {

  print("WARNING : If GitHub credentials aren't already in memory, check for a prompt to...:")
  print("        : 01. Log into GitHub through your browser, or,")
  print("        : 02. Enter a personal access token (PAT).")

  suppressMessages(credentials::set_github_pat())

  devtools::install_github('fire-centre/firekit',
                           dependencies = dependencies,
                           force = force)

  library(firekit)

}
