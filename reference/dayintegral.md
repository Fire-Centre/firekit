# Calculate number of hours of sunlight for a given day

Calculate number of hours of sunlight for a given day

## Usage

``` r
dayintegral(dayofyear, latitude, precision = 64)
```

## Arguments

- dayofyear:

  Julian day of year

- latitude:

  Latitude of location

- precision:

  Precision of integral calculation (default 64)

## Value

Hours of sunlight

## Examples

``` r
dayintegral(20,-43)
#> [1] 14.70312
```
