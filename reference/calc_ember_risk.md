# Calculate ember risk

Calculate ember risk

## Usage

``` r
calc_ember_risk(prop_table, fuels, FFDI)
```

## Arguments

- prop_table:

  Table of properties with ancillary fields added, output from
  generate_property_fields()

- fuels:

  Fuels table

- FFDI:

  Forest Fire Danger Index for calculation

## Value

Table with ember distance and risk index added

## Examples

``` r
if (FALSE) { # \dontrun{

calc_ember_risk(houses,fuels,50)
} # }
```
