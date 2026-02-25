# Precalculate landscape fields reqired for landscape risk calculations

Precalculate landscape fields reqired for landscape risk calculations

## Usage

``` r
generate_property_fields(
  locations,
  dem,
  veg,
  urb_types = c("Other natural environments",
    "Agricultural, urban and exotic vegetation", "Modified land"),
  urb_set = "Agricultural, urban and exotic vegetation",
  id_field = "RespondentID",
  fr_angle = 315
)
```

## Arguments

- locations:

  sf point object containing an ID field

- dem:

  Terra rast object with digtial elevation model of region

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
output <- generate_property_fields(data_points,dem,veg,id_field="ID")
} # }
```
