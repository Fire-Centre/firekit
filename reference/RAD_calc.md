# Radiant Heat Calculator

Radiant Heat Calculator

## Usage

``` r
RAD_calc(
  FFDI = 24,
  GFDI = 24,
  V = 26,
  Ta = 31,
  Ws = 20,
  Wo = 30,
  HGT = -1,
  fuel_type = "Forest",
  slope_type = "upslope",
  effective_slope = 5,
  max_fire_run_distance = "< 300m",
  dist = 50
)
```

## Arguments

- FFDI:

  Forest Fire Danger Index

- GFDI:

  Grassland Fire Danger Index

- V:

  10m Wind Speed (kmh)

- Ta:

  Ambient Temperature (C)

- Ws:

  Surface Fuel Load (t/ha)

- Wo:

  Overall Fuel load (t/ha)

- HGT:

  Understory height (m, for heathland, grassland or shrub, all others
  set to -1)

- fuel_type:

  (string, Forest/Shrub/Grass/Moorland)

- slope_type:

  Position of property; string upslope, downslope or none

- effective_slope:

  Slope in degrees

- max_fire_run_distance:

  Maximum fire run distance in metres

- dist:

  Distance of house from fireline (m)

## Value

Radiant heat flux in kW/m2

## Examples

``` r
if (FALSE) { # \dontrun{

RAD_calc()
} # }
```
