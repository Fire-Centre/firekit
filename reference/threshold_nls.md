# threshold_nls

Identify and extract potential threshold by comparing two variables.

## Usage

``` r
threshold_nls(df, x, y, dir = ">", plot = FALSE)
```

## Arguments

- df:

  Dataframe output by threshold_curve.

- x:

  Variable from which a threshold is identified (x axis)

- y:

  Variable used to identify a constraining threshold (y axis)

- plot:

  Binary determining whether to automatically plot the relationships to
  assess the ouput.

## Value

Output of broom::tidy() on nls models.

## Examples

``` r
if (FALSE) { # \dontrun{
  threshold_curve(mtcars, mpg, cyl, n_range = 25, dir = ">", extend = 0.1, rescale = F) |>
    threshold_nls(mpg, cyl, dir = ">", plot = TRUE)
} # }
```
