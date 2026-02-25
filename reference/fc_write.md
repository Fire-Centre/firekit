# fc_write

Write to the firecentre PostgreSQL database. Creates a new table or
either overwrites or appends to an existing table.

## Usage

``` r
fc_write(x, tbl, chunk_size = NULL, db = "firecentre", create = FALSE)
```

## Arguments

- x:

  Dataset to push to database.

- tbl:

  Database schema and table name: Must be in `schema.table` syntax.

- chunk_size:

  Number of rows to insert into the database at a time.

- db:

  Database name or path/to/database/object.

- create:

  Logical denoting whether to create a new table or overwrite an
  existing one.

## Value

Data exported to database.

## Examples

``` r
if (FALSE) { # \dontrun{


} # }
```
