## Useful references:
## - https://github.com/yihui/knitr/blob/master/R/engine.R
##   Especially:
##   * https://github.com/yihui/knitr/blob/master/R/engine.R#L472
##   * https://github.com/yihui/knitr/blob/master/R/engine.R#L486
## - https://github.com/rstudio/reticulate/blob/master/R/knitr-engine.R
## - https://github.com/yonicd/details/blob/master/R/engine.R


engine_generic_carp <- function(class) {
  function(options) {
    # Avoid errors where there are multiple unnamed chunk labels by changing the
    # unnamed chunk labels to use our own counter.
    unc <- knitr::opts_knit$get("unnamed.chunk.label")
    on.exit(knitr::opts_knit$set(unnamed.chunk.label = unc))
    knitr::opts_knit$set(unnamed.chunk.label = dove_chunk_label())

    # Handling user-specified parameters
    chunks <- knitr::opts_chunk$get()
    on.exit(knitr::opts_chunk$set(chunks), add = TRUE)
    options_no_engine <- options[!names(options) %in% c("code", "engine")]
    # The cache is an interesting one. Because we are evaluating these chunks
    # inside of the knitr environment, they will absolutely try to load the
    # cache before it's done. We have to turn on cache.rebuild temporarily.
    options_no_engine$cache <- FALSE
    # the_cache <- list.files(
    #   options$cache.path,
    #   pattern = paste0(options$label, "_.*RData")
    # )
    # options_no_engine$cache.rebuild <- options$cache &&
    #   (options$cache.rebuild || length(the_cache) == 0)
    # this_hash <- options$hash
    # options_no_engine$hash <- NULL
    knitr::opts_chunk$set(options_no_engine)

    res <- parse_block(paste(options$code, collapse = "\n"), type = options$engine)

    # This is to prevent an issue with knitting using relative paths. If this
    # happens, then knitr sets the working directory to be something other than
    # where we should be.
    if (is.null(knitr::opts_knit$get("root.dir"))) {
      on.exit(knitr::opts_knit$set(root.dir = NULL), add = TRUE)
      knitr::opts_knit$set(root.dir = getwd())
    }

    out <- knitr::knit(
      text = res,
      encoding = "UTF-8",
      # https://stackoverflow.com/a/62417329/2752888
      envir = knitr::knit_global()
    )
    return(out)
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
