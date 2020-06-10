#' Roxy solution
#' @param x a tag
#' @return somethng
#' @export
#' @importFrom roxygen2 roxy_tag_parse
#' @examples
#' soln <- system.file("inst", "extdata", "example-solution-only.R",
#'   package = "roxyblox"
#' )
#' roxygen2::parse_file(soln, env = NULL)
roxy_tag_parse.roxy_tag_solution <- function(x) {
  tag_section(x)
}


#' Roxy challenge
#' @param x a tag
#' @return somethng
#' @export
#' @importFrom roxygen2 roxy_tag_parse
#' @examples
#' soln <- system.file("inst", "extdata", "example-number-echo.R",
#'   package = "roxyblox"
#' )
#' roxygen2::parse_file(soln, env = NULL)
roxy_tag_parse.roxy_tag_challenge <- function(x) {
  tag_section(x)
}

tag_section <- function(x) {
  xx <- strsplit(x$raw, "\n")
  body <- paste(xx[[1]][-1], collapse = "\n")
  x$val <- c(head = trimws(xx[[1]][1]), body = body)
  x
}
