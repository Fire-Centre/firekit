# Fuel Break Width Calculator

Fuel Break Width Calculator

## Usage

``` r
FBW_calc(
  fb_class,
  vegetation_community,
  slope_type,
  effective_slope,
  max_fire_run_distance,
  datdf,
  id,
  dist
)
```

## Arguments

- fb_class:

  Fuel break class; string class1 = Managed fuel, class2 = Protective
  break only, class3 = high FFDI

- vegetation_community:

  Vegetation community from the Vegetation_Community field of fuel load
  data frame

- slope_type:

  Position of property; string upslope, downslope or none

- effective_slope:

  Slope in degrees

- max_fire_run_distance:

  Maximum fire run distance in metres

- datdf:

  Data frame with Vegetation_Community, SFFL (surface) and OFFL
  (overall) fine fuel loads, understory height in HGT, and
  Vegetation_Category ("Forest, Rainforest and Woodland", "Shrub, Scrub
  and Heath","Grassland" or "Tussock Moorland") to select fire model

- id:

  Point ID number

- dist:

  Distance field, unsure purpose

## Value

Maximum fuel break width in m

## Examples

``` r
if (FALSE) { # \dontrun{

FBW_calc("class1","DOB","downslope",5,340,fuel_data)
} # }
```
