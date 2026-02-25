# Calculate radiation in W/m2 for a given latitude, hour of day and day of year

Calculate radiation in W/m2 for a given latitude, hour of day and day of
year

## Usage

``` r
hourwatt(dayofyear, latitude, hour)
```

## Arguments

- dayofyear:

  Julian Day of year

- latitude:

  Latitude of location

- hour:

  Hour after midnight

## Value

Radiation (W/m2)

## Examples

``` r
hourwatt(20,-43,17)
#> [1] 732.2447
```
