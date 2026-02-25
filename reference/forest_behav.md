# Forest fire behaviour parameters from FFDI and Fuel Load

Forest fire behaviour parameters from FFDI and Fuel Load

## Usage

``` r
forest_behav(FFDI, FL, GS = 0)
```

## Arguments

- FFDI:

  McArthur Forest Fire Danger Index

- FL:

  Fuel Load in t/ha

- GS:

  Ground slope in degrees

## Value

Data frame containing columns for flame height (m), spotting distance
(km), rate of spread (km/h) and fireline intensity (kW/m)

## Examples

``` r
forest_behav(56,12.5,5)
#>   flame_height spotting      ros fireline
#> 1         6.96   2.7963 1.186072 7660.045
```
