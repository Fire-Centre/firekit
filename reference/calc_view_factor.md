# Calculate View Factor

Calculate View Factor

## Usage

``` r
calc_view_factor(FlameAngle, dist, site_slope, Lf, h, Wf)
```

## Arguments

- FlameAngle:

  Distance (metres)

- dist:

  Distance (metres)

- site_slope:

  Slope of site (degrees)

- Lf:

  Flame length

- h:

  Elevation of receiver (m)

- Wf:

  Flame width

## Value

View Factor

## Examples

``` r
calc_view_factor(20,15,5,5,2,100)
#> [1] 0.04819081
```
