# Calculate radiant-heat risk index for properties

Calculate radiant-heat risk index for properties

## Usage

``` r
calc_rad_risk(prop_table, fuels)
```

## Arguments

- prop_table:

  The supplemented property table from gen_property_fields

- fuels:

  Data frame containing fuels data (type, loads)

## Value

tibble data frame with fields for fuel break width (FBW), fireline
intensity (FL) and distance risk index (DRisk)

## Examples

``` r
if (FALSE) { # \dontrun{
output <- calc_rad_risk(houses,fuel)
} # }
```
