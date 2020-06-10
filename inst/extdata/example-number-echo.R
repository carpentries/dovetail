#' @challenge Exponentiation
#'
#' Exponentiation is built into R:
#' ```{r}
2^4
#' ```
#'
#' Write a function called `expo` that uses a loop to calculate the same result.
#' ```{r, echo=-1}
expo <- function(base, power) {
  result <- 1
  for (i in seq(power)) {
    result <- result * base
  }
  return(result)
}
expo(2, 4)
#' ```
#'
#' @solution Solution
#'
#' ```{r}
expo <- function(base, power) {
  result <- 1
  for (i in seq(power)) {
    result <- result * base
  }
  return(result)
}
#' ```
