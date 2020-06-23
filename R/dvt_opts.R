#' Set options for a knitr document
#'
#' This will set the document options, chunk options, and hooks to comply with
#'
#' @return a file path
#' @export
#'
#' @examples
#' # Make sure we reset the original options when we exit this.
#' ok <- knitr::opts_knit$get()
#' oc <- knitr::opts_chunk$get()
#' oh <- knitr::knit_hooks$get()
#'
#' on.exit({
#'   knitr::opts_knit$set(ok)
#'   knitr::opts_chunk$set(oc)
#'   knitr::knit_hooks$set(oh)
#' })
#' if (requireNamespace("withr", quietly = TRUE)) { withAutoprint({
#' withr::with_dir(system.file("extdata", package = "dovetail")){
#' 
#' source(dvt_opts())
#' # The default error is just to print
#' cat(oh$error(c("this is a dramatic...", "", "error")))
#' jekerr <- knitr::knit_hooks$get("error")
#' # The dovetail error is formulated for jekyll with a kramdown tag
#' cat(jekerr(c("this is a dramatic...", "", "error")))
#'
#' # The output directory has been updated to the top of the project. This is
#' # To account for the fact that Jekyll sites store their assets in the top
#' # level directory
#' ok$base.dir
#' knitr::opts_knit$get("base.dir")
#'
#' # The figure paths have been updated
#' oc$fig.path
#' knitr::opts_chunk$get("fig.path")
#'
#' # Use a loaded function to update this:
#' knitr_fig_path(prefix = "01-")
#' knitr::opts_chunk$get("fig.path")
#' 
#' })}
dvt_opts <- function() {
  system.file("chunk-options.R", package = "dovetail")
}
