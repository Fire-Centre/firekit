# Calculator for single Forest Fire Danger Index calculation

Calculator for single Forest Fire Danger Index calculation

## Usage

``` r
ffdi(Temperature, Humid, Wind, DF)
```

## Arguments

- Temperature:

  Temperature in C

- Humid:

  Relative Humidity in %

- Wind:

  Wind Speed in km/h

- DF:

  Drought factor (1-10)

## Value

McArthur FFDI value

## Examples

``` r
ffdi(18,28,28,5.4)
#> [1] 9.073932
```
