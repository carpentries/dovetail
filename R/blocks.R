#' Roxy solution
#' @param x a tag
#' @return somethng
#' @export
#' @importFrom roxygen2 roxy_tag_parse
roxy_tag_parse.roxy_tag_solution <- function(x) {
  tag_markdown(x)
}

#' Roxy challenge
#' @param x a tag
#' @return somethng
#' @export
#' @importFrom roxygen2 roxy_tag_parse
roxy_tag_parse.roxy_tag_challenge <- function(x) {
  tag_markdown(x)
}
