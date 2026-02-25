# Generate sf vector line in a given direction from point, default north-west

Generate sf vector line in a given direction from point, default
north-west

## Usage

``` r
nw_vector(point, dist = 350, ang = 315)
```

## Arguments

- point:

  sf point object

- dist:

  Distance in meters

- ang:

  Angle in degrees

## Value

Data frame with slope, r2 value and angle in degrees

## Examples

``` r
nw_vector(sf::st_as_sf(data.frame(x=521310,y=5244614),coords=c("x","y"),crs=28355),350)
#> Geometry set for 1 feature 
#> Geometry type: LINESTRING
#> Dimension:     XY
#> Bounding box:  xmin: 521062.5 ymin: 5244614 xmax: 521310 ymax: 5244861
#> Projected CRS: GDA94 / MGA zone 55
#> LINESTRING (521310 5244614, 521062.5 5244861)
```
