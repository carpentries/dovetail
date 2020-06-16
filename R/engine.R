## Useful references:
## - https://github.com/yihui/knitr/blob/master/R/engine.R
##   Especially:
##   * https://github.com/yihui/knitr/blob/master/R/engine.R#L472
##   * https://github.com/yihui/knitr/blob/master/R/engine.R#L486
## - https://github.com/rstudio/reticulate/blob/master/R/knitr-engine.R
## - https://github.com/yonicd/details/blob/master/R/engine.R


## Currently not in use
engine_generic_carp <- function(class) {
  function(options) {
    res <- parse_block(paste(options$code, collapse = "\n"))
    tmp <- tempfile(fileext = ".md")
    on.exit(unlink(tmp))
    knitr::knit(
      output = tmp,
      text = res,
      encoding = "UTF-8",
      # https://stackoverflow.com/a/62417329/2752888
      envir = knitr::knit_global()
    )
    out <- readLines(tmp)
    paste(out, collapse = "\n")
  }
}


.onLoad <- function(lib, pkg) {
  for (i in OUR_TAGS) {
    knitr::knit_engines$set(setNames(list(engine_generic_carp(i)), i))
  }
}
