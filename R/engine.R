## Useful references:
## - https://github.com/yihui/knitr/blob/master/R/engine.R
##   Especially:
##   * https://github.com/yihui/knitr/blob/master/R/engine.R#L472
##   * https://github.com/yihui/knitr/blob/master/R/engine.R#L486
## - https://github.com/rstudio/reticulate/blob/master/R/knitr-engine.R
## - https://github.com/yonicd/details/blob/master/R/engine.R


engine_generic_carp <- function(class) {
  function(options) {
    # Avoid errors where there are multiple unnamed chunk labels
    unc <- knitr::opts_knit$get("unnamed.chunk.label")
    on.exit(knitr::opts_knit$set(unnamed.chunk.label = unc))
    # # Change unnamed chunk labels to the time and a random 10-char string
    knitr::opts_knit$set(unnamed.chunk.label = dove_chunk_label())
    # randos <- function() {
    #   paste(sample(c(letters, 0:9), 10, replace = TRUE), collapse = "")
    # }
    # knitr::opts_knit$set(unnamed.chunk.label = paste(as.character(Sys.time()), randos()))

    res <- parse_block(paste(options$code, collapse = "\n"), type = options$engine)
    tmp <- tempfile(fileext = ".md")
    on.exit(unlink(tmp), add = TRUE)

    # This part happens because I noticed that even if I set a base.dir option
    # to be one path above this, knitr would for some reason place the figures
    # in the wd of the original document or worse, try to access the output
    # directory from inside the original directory.
    #
    # Note: this appears not to work with reading in external files when rendered
    # with RMarkdown, which means that this soluiton is not sustainable
    bd <- knitr::opts_knit$get("base.dir")
    if (!is.null(bd)) {
      wd <- getwd()
      on.exit(setwd(wd), add = TRUE)
      setwd(bd)
    }

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

# nocov start
# Load the engine
.onLoad <- function(lib, pkg) {
  for (i in OUR_TAGS) {
    ENG <- list(engine_generic_carp(i))
    names(ENG) <- i
    knitr::knit_engines$set(ENG)
  }
}
# nocov end
