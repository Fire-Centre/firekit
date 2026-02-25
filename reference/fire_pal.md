# fire_pal

Create custom-length vector of color hex codes that fall within one of
the many Fire Centre-themed colour palettes.

## Usage

``` r
fire_pal(n = 5, pal = "rfs")
```

## Arguments

- n:

  int : Number of unique color values to use.

- pal:

  chr : Internal palette choice, including 'bw', 'climate', 'climcyc',
  'fire', 'grey', 'red', 'rfs', 'sinebow', 'utas', 'utas2'

## Value

Vector of color hex codes using shades of UTAS-themed colours.

## Examples

``` r
if (FALSE) { # \dontrun{
  fire_pal(n = 5, pal = "fire")
} # }
```
