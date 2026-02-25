# Calculate Moorland Fire Danger Index

Calculate Moorland Fire Danger Index

## Usage

``` r
calc_MFDI(rain, temp, RH, wind, age, time, daily = FALSE)
```

## Arguments

- rain:

  Rainfall amount (mm)

- temp:

  Temperature (degrees C)

- RH:

  Relative humidity (RH)

- wind:

  Wind speed

- age:

  Age of fuel (time since fire)

- time:

  Vector of time values in minutes or days

- daily:

  If time data is daily set to TRUE, otherwise if it is in minutes set
  to FALSE

## Value

Moorland FDI

## Examples

``` r
calc_MFDI(rain=c(0,20,10,4),
temp=c(12,13,8,9),
RH=c(55,87,90,67),
wind=c(5,8,9,9),
age=c(25,25,25,25),
time=c(1,2,3,4),
daily=TRUE)
#> [1] 2.0108218 0.3181124 0.3468034 0.5548097
```
