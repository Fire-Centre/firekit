# fhi_curve

Calculate a fire heterogeneity index curve for a raster layer with
showing fires.

## Usage

``` r
fhi_curve(raster, step = 10, filter_severity = TRUE)
```

## Arguments

- raster:

  terra SpatRaster reflecting fires (either binary 1/0 or FESM severity
  data).

- step:

  Step to use for internal buffers. User larger values on larger fires,
  smaller values on smaller fires.

- filter_severity:

  Flag to filter fire severity to high and extreme fires *if* the raster
  input layer is FESM.

## Value

Dataframe prepared for fhi_nls(...)

## Examples

``` r
if (FALSE) { # \dontrun{

} # }
```
