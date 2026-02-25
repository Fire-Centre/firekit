# Calculate radiant-heat risk index for properties for defined FFDI

Calculate radiant-heat risk index for properties for defined FFDI

## Usage

``` r
calc_rad_risk_FFDI(prop_table, fuels, FFDI)
```

## Arguments

- prop_table:

  The supplemented property table from gen_property_fields

- fuels:

  Data frame containing fuels data (type, loads)

- FFDI:

  FFDI value to calculate risk at

## Value

tibble data frame with fields for fuel break width (FBW), fireline
intensity (FL) and distance risk index (DRisk)

## Examples

``` r
if (FALSE) { # \dontrun{
output <- calc_rad_risk_FFDI(houses,fuel,50)
} # }
```
