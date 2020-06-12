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
    extract_chunks(res)
    res
    paste(res, collapse = "\n")
  }
}

engine_challenge <- engine_generic_carp("challenge")

.onLoad <- function(lib, pkg) {
  knitr::knit_engines$set(carp = engine_challenge)
}
