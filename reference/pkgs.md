# pkgs

Install and/or load any necessary libraries, or skip if they are already
loaded. Note: This function is re-purposed from `toddellis/miao`.

## Usage

``` r
pkgs(packages, quiet = FALSE, repos = c("https://cloud.r-project.org"))
```

## Arguments

- packages:

  Single character or character vector with package/library names

- quiet:

  Logical whether to show which packages were installed, loaded, or
  skipped, as well as their version numbers.

- repos:

  Specified repo web address to attempt to pull uninstalled libraries
  from.

## Value

Environmental conditions: Installs and/or loads libraries where
necessary.

## Examples

``` r
if (FALSE) { # \dontrun{
utastoolkit::pkgs(c('dplyr', 'tidyr', 'utas-analytics/utastoolkit'),
                  quiet = FALSE)
} # }
```
