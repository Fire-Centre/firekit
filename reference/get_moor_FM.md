# Calculates Moorland FDI Fuel Moisture

Calculates Moorland FDI Fuel Moisture

## Usage

``` r
get_moor_FM(temp, humid, rainHours, rainAmount)
```

## Arguments

- temp:

  Temperature in degrees C

- humid:

  Humidity percentage

- rainHours:

  Number of hours over which rainfall fell

- rainAmount:

  Amount of rainfall (mm)

## Value

Moorland Fuel Moisture

## Examples

``` r
get_moor_FM(12,87,24,22)
#> [1] 32.99687
```
