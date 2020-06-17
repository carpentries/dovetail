#' ## Challenge 1
#'
#' Write a function called `kelvin_to_celsius()` that takes a temperature in
#' Kelvin and returns that temperature in Celsius.
#'
#' Hint: To convert from Kelvin to Celsius you subtract 273.15
#'
#' @solution Solution to challenge 1
#'
#' Write a function called `kelvin_to_celsius` that takes a temperature in Kelvin
#' and returns that temperature in Celsius
#'
#' ```{r}
kelvin_to_celsius <- function(temp) {
  celsius <- temp - 273.15
  return(celsius)
}
#' ```
