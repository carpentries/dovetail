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
    # Find the position of the knitr call in the call stack
    cstack <- vapply(sys.calls(), function(i) paste(as.character(deparse(i)), collapse = "\n"), character(1))
    # The Frame stack gives the the parent frames of each call
    fstack <- sys.frames()
    # When I find which one is from knitr, I can get the "envir" variable
    # from that frame, which tells me what environment was used to knit the
    # initial document.
    knitting <- rev(grep("knit(", cstack, fixed = TRUE))[[1]]
    e <- get("envir", fstack[[knitting]])

    res <- parse_block(paste(options$code, collapse = "\n"))
    tmp <- tempfile(fileext = ".md")
    on.exit(unlink(tmp))
    knitr::knit(
      output = tmp,
      text = res,
      encoding = "UTF-8",
      envir = e #parent.frame(n = frame_number)
    )
    out <- readLines(tmp)
    paste(out, collapse = "\n")
  }
}

engine_challenge <- engine_generic_carp("challenge")

.onLoad <- function(lib, pkg) {
  knitr::knit_engines$set(carp = engine_challenge)
}
