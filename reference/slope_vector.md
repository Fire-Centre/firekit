# Calculate slope based on regression over a given distance and angle across a DEM

Calculate slope based on regression over a given distance and angle
across a DEM

## Usage

``` r
slope_vector(point, distance, angle, dem)
```

## Arguments

- point:

  sf object with a point

- distance:

  Distance in metres

- angle:

  Compass vector angle

- dem:

  RASTER dem object

## Value

Slope

## Examples

``` r
 data("COH_DEM")
#> Warning: data set ‘COH_DEM’ not found
 slope_vector(sf::st_as_sf(data.frame(x=526000,y=5248614),coords=c("x","y"),crs=28355),150,37,COH_DEM)
#> Error in h(simpleError(msg, call)): error in evaluating the argument 'x' in selecting a method for function 'extract': object 'COH_DEM' not found
```
