# theme_fire

Use Fire Centre-preferred ggplot2 theme. Default sizing tends to work
well for Quarto publications.

## Usage

``` r
theme_fire(
  axis.title = 14,
  axis.text = 10,
  strip.text = 10.5,
  legend.text = 10.25,
  strip.bg = "white",
  plot.bg = "white",
  line.col = "#838383"
)
```

## Arguments

- axis.title:

  Text size for axis title.

- axis.text:

  Text size for axis text.

- strip.text:

  Text size for facet strips.

- legend.text:

  Text size for legend.

- line_col:

  Color for axis lines and ticks; defaults to dark grey.

## Value

Theme ready for adding to ggplot2 object.

## Examples

``` r
tibble::tibble(x = 1:10,
               y = 10:1) |>
 ggplot2::ggplot(ggplot2::aes(x = x, y = y)) +
 ggplot2::geom_point() +
 theme_fire()

```
