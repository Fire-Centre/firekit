
.onLoad <- function(libname, pkgname) {
  ember_model_path <- system.file("extdata", "ember_model_95.Rds", package = pkgname)
  ember_gam <- readRDS(ember_model_path)
  ns <- asNamespace(pkgname)
  assign("ember_gam", ember_gam, envir = ns)
}

