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
#' @export
#' @rdname roxy_tag_parse
roxy_tag_parse.roxy_tag_solution <- function(x) {
  tag_section(x)
}
#' @export
#' @rdname roxy_tag_parse
roxy_tag_parse.roxy_tag_callout <- function(x) {
  tag_section(x)
}
#' @export
#' @rdname roxy_tag_parse
roxy_tag_parse.roxy_tag_challenge <- function(x) {
  tag_section(x)
}
#' @export
#' @rdname roxy_tag_parse
roxy_tag_parse.roxy_tag_checklist <- function(x) {
  tag_section(x)
}
#' @export
#' @rdname roxy_tag_parse
roxy_tag_parse.roxy_tag_discussion <- function(x) {
  tag_section(x)
}
#' @export
#' @rdname roxy_tag_parse
roxy_tag_parse.roxy_tag_keypoints <- function(x) {
  tag_section(x)
}
#' @export
#' @rdname roxy_tag_parse
roxy_tag_parse.roxy_tag_objectives <- function(x) {
  tag_section(x)
}
#' @export
#' @rdname roxy_tag_parse
roxy_tag_parse.roxy_tag_prereq <- function(x) {
  tag_section(x)
}
#' @export
#' @rdname roxy_tag_parse
roxy_tag_parse.roxy_tag_solution <- function(x) {
  tag_section(x)
}
#' @export
#' @rdname roxy_tag_parse
roxy_tag_parse.roxy_tag_testimonial <- function(x) {
  tag_section(x)
}
#' @export
#' @rdname roxy_tag_parse
roxy_tag_parse.roxy_tag_challenge <- function(x) {
  tag_section(x)
}
#' @export
#' @rdname roxy_tag_parse
roxy_tag_parse.roxy_tag_solution <- function(x) {
  tag_section(x)
}

#' @export
format.roxy_tag_callout <- function(x, ...) {
  rxyfmt(x)
}
#' @export
format.roxy_tag_challenge <- function(x, ...) {
  rxyfmt(x)
}
#' @export
format.roxy_tag_checklist <- function(x, ...) {
  rxyfmt(x)
}
#' @export
format.roxy_tag_discussion <- function(x, ...) {
  rxyfmt(x)
}
#' @export
format.roxy_tag_keypoints <- function(x, ...) {
  rxyfmt(x)
}
#' @export
format.roxy_tag_objectives <- function(x, ...) {
  rxyfmt(x)
}
#' @export
format.roxy_tag_prereq <- function(x, ...) {
  rxyfmt(x)
}
#' @export
format.roxy_tag_solution <- function(x, ...) {
  rxyfmt(x)
}
#' @export
format.roxy_tag_testimonial <- function(x, ...) {
  rxyfmt(x)
}
#' @export
format.roxy_tag_challenge <- function(x, ...) {
  rxyfmt(x)
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
