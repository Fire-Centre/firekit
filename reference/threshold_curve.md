# threshold_curve

Reframe data for extracting a threshold or exploring causal
relationships.

## Usage

``` r
threshold_curve(
  df,
  x,
  y,
  n_range = 100,
  dir = c(">", "<"),
  extend = NULL,
  rescale = FALSE
)
```

## Arguments

- df:

  Dataframe

- x:

  Variable from which a threshold is identified (x axis)

- y:

  Variable used to identify a constraining threshold (y axis)

- n_range:

  Number of values to use to blow out the x axis and identify a
  threshold.

- dir:

  Direction along x axis constraining the threshold.

- extend:

  Value between 0 and 1 to blow out the x axis (sometimes important if
  threshold is near the upper or lower limits; this can crash the model)

- rescale:

  Whether to rescale the y axis to between 0 and 1.

## Value

Dataframe prepared for threshold_nls(...)

## Examples

``` r
if (FALSE) { # \dontrun{
  threshold_curve(mtcars, mpg, cyl, n_range = 25, dir = ">", extend = 0.1, rescale = F)
} # }
```
