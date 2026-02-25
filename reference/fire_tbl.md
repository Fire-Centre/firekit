# fire_tbl

Connect to a specified database/table.

## Usage

``` r
fire_tbl(
  query = NULL,
  db = "firecentre",
  reset = FALSE,
  writable = FALSE,
  kid = 1,
  ...
)
```

## Arguments

- query:

  SQL SELECT query or SCHEMA.TABLE EDW reference.

- db:

  Database name or path/to/database/object.

- reset:

  Logical Denotes whether to reset the connection object (`con`). Useful
  if needing to turn writable on/off or change databases.

- writable:

  Logical re: making the connection writeable. Warning: Only one
  individual can be connected to a database with a writable connection
  at a time.

- kid:

  int : User ID number for accessing a list of stored credentials via
  `keyring`. Should typically be 1 unless multiple credentials are
  stored on one system.

## Value

Lazy connection or local database dataframe.

## Examples

``` r
if (FALSE) { # \dontrun{


} # }
```
