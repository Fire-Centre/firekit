# Extend and shift a polygon by a given angle and distance

Extend and shift a polygon by a given angle and distance

## Usage

``` r
shift_poly(poly, dis = 50, base_ang = 135, var_ang = 6.5)
```

## Arguments

- poly:

  A polygon sf object

- dis:

  Distance to extend in metres

- base_ang:

  Angle in which to extend polygon

- var_ang:

  Lateral angle range in which to shuffle polygon

## Value

A sf polygon object

## Examples

``` r
if (FALSE) { # \dontrun{

shift_poly(vegetation,50,135,6.5)
} # }
```
