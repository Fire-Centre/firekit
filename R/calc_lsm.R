#' calc_lsm
#'
#' Calculate landscape metrics using a circular moving window.
#'
#' @param raster_list List of raster files to or a single raster file path to calculate lsm against.
#' @param category Type of categorical data to assess. N.B. Designed for these listed categories -- use 'other' to test against different data, but ensure it is pre-processed to satisfaction.
#' @param folder_out Output folder to save processed rasters.
#' @param year Optional year to calculate, only used as a filter against the raster_list. Assumes year is in the file name.
#' @param window_n Window size to use for a moving window.
#' @param lsm Vector list of landscape metrics to calculate. If NULL, it calculates every available option from the {landscapemetrics} package.
#' @param mask Optional mask to apply after calculating landscape metrics.
#' @param overwrite Flag to overwrite existing file or not.
#' @param plot Flag to print a plot of the output before writing data to file.
#'
#' @return Raster layer with time since fire classes.
#' @export
#'
#' @examples
#' \dontrun{
#'
#' }
#'
calc_lsm <- function(
  raster_list,
  category = c("hts", "tsf", "tsfc", "fesm", "other"),
  folder_out,
  year = NULL,
  window_n = 3,
  lsm = NULL,
  mask = NULL,
  overwrite = FALSE,
  plot = FALSE
) {
  ## Filter to selected year if provided --------------------------------
  if (!is.null(year)) {
    .yr <- as.character(year)
    raster_list <- raster_list[stringr::str_detect(raster_list, .yr)]
  }

  if (missing(raster_list) || length(raster_list) == 0) {
    stop("raster_list is missing or empty.")
  }
  if (
    missing(folder_out) || !is.character(folder_out) || nchar(folder_out) == 0
  ) {
    stop("folder_out is missing or invalid.")
  }
  if (missing(mask)) {
    warning(
      "No raster mask provided. Values calculated near edges may be skewed."
    )
  }

  ## Get list of relevant metrics we'll calculate
  ## landscapemetrics::list_lsm() |> dplyr::filter(function_name %in% c(...)) |> dplyr::arrange(name) |> dplyr::pull(function_name)
  if (is.null(lsm)) {
    warning("Running all potential landscape metrics.")
    .df_metrics <-
      landscapemetrics::list_lsm() |>
      dplyr::filter(level == "landscape") |>
      dplyr::filter(
        function_name %in%
          c(
            "lsm_l_ai",
            "lsm_l_condent",
            "lsm_l_contag",
            "lsm_l_contig_mn",
            "lsm_l_core_mn",
            "lsm_l_cai_mn",
            "lsm_l_dcore_mn",
            "lsm_l_dcad",
            "lsm_l_division",
            "lsm_l_ed",
            "lsm_l_mesh",
            "lsm_l_enn_mn",
            "lsm_l_frac_mn",
            "lsm_l_iji",
            "lsm_l_joinent",
            "lsm_l_lsi",
            "lsm_l_lpi",
            "lsm_l_msidi",
            "lsm_l_msiei",
            "lsm_l_mutinf",
            "lsm_l_ndca",
            "lsm_l_np",
            "lsm_l_area_mn",
            "lsm_l_cohesion",
            "lsm_l_pd",
            "lsm_l_pr",
            "lsm_l_prd",
            "lsm_l_pladj",
            "lsm_l_pafrac",
            "lsm_l_para_mn",
            "lsm_l_gyrate_mn",
            "lsm_l_circle_mn",
            "lsm_l_relmutinf",
            "lsm_l_rpr",
            "lsm_l_ent",
            "lsm_l_shdi",
            "lsm_l_shei",
            "lsm_l_shape_mn",
            "lsm_l_sidi",
            "lsm_l_siei",
            "lsm_l_split",
            "lsm_l_tca",
            "lsm_l_te"
          )
      ) |>
      dplyr::arrange(name)
  } else {
    .df_metrics <- lsm
  }

  purrr::walk(raster_list, function(raster_file) {
    .yr <- stringr::str_extract(raster_file, "[0-9]{4}")
    .r <- terra::rast(raster_file)

    .res <- terra::res(.r)[[1]]

    .window <-
      terra::rast(
        nrows = 100,
        ncols = 100,
        xmin = 0,
        xmax = 1000,
        ymin = 0,
        ymax = 1000,
        res = .res,
        crs = "EPSG:9001"
      ) |>
      ## Create a circular focal window. (window_n / 2) * .res keeps the dimensions of the window to window_n
      terra::focalMat(d = (window_n / 2) * .res, type = "circle", fillNA = TRUE)

    # Not sure if this is necessary.
    .window[!is.na(.window)] <- 1

    .window_area <- .res * window_n
    if (stringr::str_width(.window_area) <= 5) {
      .window_folder <-
        glue::glue(
          "{stringr::str_pad(.window_area, width = 5, side = 'left', pad = '0')}m"
        )
    } else {
      .window_folder <-
        glue::glue("{.window_area}m")
    }

    .arg_category = match.arg(category, choices = category)

    if (.arg_category == "tsf") {
      .r <- classify_tsf(.r)
      .arg_category = "tsfc"
    }

    if (.arg_category == "hts") {
      # Treat "No fire regime" (1) or NA values as "Within threshold" (5)
      .r[.r == 1 | is.na(.r)] <- 5
    } else if (.arg_category == "tsfc") {
      # Treat NA as > 30 years since fire
      .r[is.na(.r)] <- 6
    } else if (.arg_category == "other") {
      warning(
        "Accepting raster as is. Ensure input is categorical and pre-processed for calculating landscape metrics.\\nThis feature is in beta and may include bugs. The raster unit is assumed to be in meters."
      )
    } # else if (.arg_category == "fesm") {
    # Recode "grassland fires" as low severity fires
    ## N.B. Leaving this here as an idea -- do we want to recode these or just let it process and ignore them.
    #   .r[.r == 1] <- 2
    # }

    purrr::pwalk(.df_metrics, function(metric, name, function_name, ...) {
      .file <- glue::glue(
        "{folder_out}/{.arg_category}/{.window_folder}/{metric}/{metric}_{.yr}.tif"
      )

      if (file.exists(.file) & !overwrite) {
        print(glue::glue("File exists: {name} for {.yr} @ {.window_folder}"))
        if (plot) {
          plot(terra::rast(.file), main = name)
        }
        return()
      }

      print(glue::glue(
        "Calculating {name} for {.yr} @ {.window_folder}: {.file}"
      ))
      tictoc::tic()

      # Define arguments for window_lsm
      args <- list(
        landscape = .r,
        window = .window,
        what = function_name,
        directions = 8
      )
      # Add cellsize argument only if needed
      if (function_name == "lsm_l_enn_mn") {
        args$cellsize <- .res
      }
      if (function_name == "lsm_l_gyrate_mn") {
        args$cell_center = FALSE
      }
      ## Add maximum number of classes possible only if needed
      if (function_name %in% c("lsm_l_rpr")) {
        if (.arg_category == "hts") {
          args$classes_max = 4
        } else if (.arg_category %in% c("tsfc", "fesm")) {
          args$classes_max = 6
        }
      }

      # Calculate the metric
      .calc <- do.call(window_lsm, args)[[1]][[1]]

      ## N.B. Some complexity here -- does this come prior to calculating lsm or after? Originally put before but that doesn't make sense, does it, since it will affect the landscape metrics being calculated.
      if (!is.null(mask)) {
        .mask_class = class(mask)[[1]]

        if (!.mask_class %in% c("SpatVector", "SpatRaster")) {
          print(
            "Skipping applying a mask as it is not a valid format (SpatRaster, SpatVector)."
          )
        } else {
          .calc <- terra::mask(.calc, mask)
        }
      }

      if (plot) {
        plot(.calc, main = name)
      }

      # Create directory if it doesn't exist
      dir.create(dirname(.file), showWarnings = FALSE, recursive = TRUE)

      # Write the resulting raster to a file
      terra::writeRaster(
        .calc,
        filename = .file,
        overwrite = TRUE,
        wopt = list(datatype = "FLT4S", gdal = c("COMPRESS=LZW"))
      )
      tictoc::toc()
    })
  })
}
