# Calculate Mount's Soil Dryness Index (SDI)

Calculate Mount's Soil Dryness Index (SDI)

## Usage

``` r
calc_SDI(rain, temperature)
```

## Arguments

- rain:

  Daily precipitation in mm

- temperature:

  Daily maximum temperature in degrees C

## Value

Mount's SDI in mm

## Examples

``` r
calc_SDI(c(2,5,0,0),c(26,17,18,20))
#> [1] 0.254 1.190 0.101 2.895
```
