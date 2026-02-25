# fc_index

Manage indices in the `firecentre` PostgreSQL database. N.B. May be
better (and faster) to manage these from within pgAdmin.

## Usage

``` r
fc_index(
  idx_name,
  idx_cols = NULL,
  tbl = NULL,
  unique = FALSE,
  drop = FALSE,
  db = "firecentre"
)
```

## Arguments

- tbl:

  Database schema and table name used when creating indices: Must be in
  `schema.table` syntax.

- db:

  Database name or path/to/database/object.

## Value

Data exported to database.

## Examples

``` r
if (FALSE) { # \dontrun{


} # }
```
