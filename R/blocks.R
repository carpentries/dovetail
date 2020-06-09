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
  roxygen2::tag_markdown(x)
}

#' @export
roxy_tag_parse.roxy_tag_block <- function(x) {
  roxygen2::tag_value(x)
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
  roxygen2::tag_markdown(x)
}
