# Calculate 95th percentile ember distance from FDI, slope and fuel load

Calculate 95th percentile ember distance from FDI, slope and fuel load

## Usage

``` r
predict_ember(FDI, slope, fuel)
```

## Arguments

- FDI:

  Forest Fire Danger Index value

- slope:

  Slope type, options are "Flat" and "Hilly"

- fuel:

  Surface fuel load in t/ha

## Value

Distance in m

## Examples

``` r
if (FALSE) { # \dontrun{

predict_ember(40,"Flat",15)
} # }
```
