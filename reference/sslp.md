# Regress slope from vector of elevations

Regress slope from vector of elevations

## Usage

``` r
sslp(y, dist = 150)
```

## Arguments

- y:

  Vector of elevations spread over the distance

- dist:

  Distance in meters

## Value

Data frame with slope, r2 value and angle in degrees

## Examples

``` r
sslp(c(20,30,45,40,80,91))
#>       slope         r    slang
#> x 0.4761905 0.8928571 29.55192
```
