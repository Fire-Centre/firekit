# calc_lsm

Calculate landscape metrics using a circular moving window.

## Usage

``` r
calc_lsm(
  raster_list,
  category = c("hts", "tsf", "tsfc", "fesm", "other"),
  folder_out,
  year = NULL,
  window_n = 3,
  lsm = NULL,
  mask = NULL,
  overwrite = FALSE,
  plot = FALSE
)
```

## Arguments

- raster_list:

  List of raster files to or a single raster file path to calculate lsm
  against.

- category:

  Type of categorical data to assess. N.B. Designed for these listed
  categories – use 'other' to test against different data, but ensure it
  is pre-processed to satisfaction.

- folder_out:

  Output folder to save processed rasters.

- year:

  Optional year to calculate, only used as a filter against the
  raster_list. Assumes year is in the file name.

- window_n:

  Window size to use for a moving window.

- lsm:

  Vector list of landscape metrics to calculate. If NULL, it calculates
  every available option from the landscapemetrics package.

- mask:

  Optional mask to apply after calculating landscape metrics.

- overwrite:

  Flag to overwrite existing file or not.

- plot:

  Flag to print a plot of the output before writing data to file.

## Value

Raster layer with time since fire classes.

## Examples

``` r
if (FALSE) { # \dontrun{

} # }
```
