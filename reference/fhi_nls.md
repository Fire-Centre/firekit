# fhi_nls

Run a non-linear least squares algorithm on the output of the
`r_fhi_curve` function and extract the fire heterogeneity index.
Optionally plot the outcome.

## Usage

``` r
fhi_nls(x, start_fhi = 0.01, plot = FALSE)
```

## Arguments

- x:

  Output of `r_fhi_curve`.

- start_fhi:

  Start parameter for calculating the FHI from the NLS algorithm. Change
  if processing errors.

- plot:

  Flag to plot the outcome curve and the identified FHI.

## Value

Either a ggplot output or a single FHI value.

## Examples

``` r
if (FALSE) { # \dontrun{

} # }
```
