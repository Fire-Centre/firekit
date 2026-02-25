# Calculate sun altitude for given latitude, day and time

Calculate sun altitude for given latitude, day and time

## Usage

``` r
sunaltitude(latitude, dayofyear, hour)
```

## Arguments

- latitude:

  Latitude of location

- dayofyear:

  Julian day of year

- hour:

  Time of day (hours from midnight)

## Value

Sunaltitude in degrees

## Examples

``` r
sunaltitude(-43,20,15)
#> [1] 46.30008
```
