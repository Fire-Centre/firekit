# Construct 8 line vectors in cardinal directions from a point over a distance

Construct 8 line vectors in cardinal directions from a point over a
distance

## Usage

``` r
compass_vectors(point, distance)
```

## Arguments

- point:

  sf object with a point

- distance:

  Distance in metres

## Value

sf object with line vectors

## Examples

``` r
 compass_vectors(sf::st_as_sf(data.frame(x=521310,y=5244614),coords=c("x","y"),crs=28355),50)
#> Geometry set for 8 features 
#> Geometry type: LINESTRING
#> Dimension:     XY
#> Bounding box:  xmin: 521260 ymin: 5244564 xmax: 521360 ymax: 5244664
#> Projected CRS: GDA94 / MGA zone 55
#> First 5 geometries:
#> LINESTRING (521310 5244614, 521310.9 5244664)
#> LINESTRING (521310 5244614, 521346 5244649)
#> LINESTRING (521310 5244614, 521360 5244613)
#> LINESTRING (521310 5244614, 521344.7 5244578)
#> LINESTRING (521310 5244614, 521309.1 5244564)
```
