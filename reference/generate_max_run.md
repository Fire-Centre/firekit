# Precalculate max fire run distance

Precalculate max fire run distance

## Usage

``` r
generate_max_run(
  locations,
  veg,
  urb_types = c("Other natural environments",
    "Agricultural, urban and exotic vegetation"),
  urb_set = "Agricultural, urban and exotic vegetation",
  id_field = "RespondentID"
)
```

## Arguments

- locations:

  sf point object containing an ID field

- veg:

  Vegetation polygon layer with vegetation type in VEG_GROUP field

- urb_types:

  List of vegetation types to treat as urban/no fire risk

- urb_set:

  Vegetation type string to associate with urban in output

- id_field:

  Name of field contianing ID

## Value

sf point object with landscape fields added, ready for risk calculation

## Examples

``` r
if (FALSE) { # \dontrun{
output <- generate_max_run(data_points,veg,id_field="ID")
} # }
```
