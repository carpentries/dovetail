#' Parse A roxygen-formatted block to into a block to be rendered as markdown
#'
#' @param txt a character vector of length 1 that represents a block of text
#' @param type the type of block any other blocks will be nested in
#'
#' @return the modified block with div tags assigned in the appropriate places
#' @export
#' @examples
#' # Simple example showing that the block can be parsed with knitr in its own
#' # environment
#' e <- new.env()
#' assign("h", list(ello = "hello", ere = "there"), env = e)
#' txt <- parse_block("
#' #' ## Hello Challenge
#' #'
#' #' Say hello
#' #'
#' #' @solution olleH Solution
#' #'
#' #' ```{r}
#' h$ello  # variables in the current environment are evaluated
#' h$ere
#' getwd() # working directory is the current directory
#' #' ```
#' ")
#' tmp <- tempfile(fileext = ".md")
#' knitr::knit(output = tmp, text = txt, envir = e)
#' file.edit(tmp)
#'
#' # Example of a more typical block
#' f <- system.file("extdata", "example-number-echo.R", package = "roxyblox")
#' txt <- paste(readLines(f, encoding = "UTF-8"), collapse = "\n")
#' cat(txt)
#' ptxt <- parse_block(txt)
#' tmp <- tempfile(fileext = ".md")
#' knitr::knit(output = tmp, text = ptxt, encoding = "UTF-8", envir = parent.frame())
#' file.edit(tmp)
#'
#' # Example of a block with multiple solutions
#' f <- system.file("extdata", "example-multi-solution.txt", package = "roxyblox")
#' txt <- paste(readLines(f, encoding = "UTF-8"), collapse = "\n")
#' cat(txt)
#' ptxt <- parse_block(txt)
#' tmp <- tempfile(fileext = ".md")
#' knitr::knit(output = tmp, text = ptxt, encoding = "UTF-8", envir = parent.frame())
#' file.edit(tmp)
parse_block <- function(txt, type = "challenge", opts="markdown='1'") {
  if (length(txt) != 1) {
    stop("there is more than one text block here")
  }
  # Negative look-ahead to identify code lines
  #
  code_pattern <- "\n(?!#+['][ ]?)"
  TXT <- gsub(code_pattern, "\n#' \\1", txt, perl = TRUE)
  parsed <- roxygen2::parse_text(paste0(TXT, "\nNULL"), env = NULL)
  if (length(parsed) == 0) {
    return(txt)
  }

  parsed <- parsed[[1]]
  tags <- vapply(parsed$tags, function(i) i$tag, character(1))

  if (all(tags %nin% OUR_TAGS)) {
    return(paste(vapply(parsed$tags, function(i) i$raw, character(1)), collapse = "\n"))
  }


  res <-
  res <- character(length(parsed$tags) + 2L)
  res[[1]] <- paste0("<div class='", type, "' ", opts, ">\n")
  n <- 1L
  previous <- NULL
  parent <- NULL
  for (i in seq(parsed$tags)) {
    block <- parsed$tags[[i]]
    if (block$tag %nin% OUR_TAGS) {
      res[[i + 1L]] <- block$raw
    } else if (block$tag == "end") {
      res[[i + 1L]] <- paste0("\n</div>\n", block$raw)
      n <- n - 1L
    } else {
      res[[i + 1L]] <- paste0("\n<div class='", block$tag, "' ", opts, ">\n\n", format(block))
      n <- n + 1L
    }
  }
  # There will always be a hanging div tag, so we need to close it.
  res[length(res)] <- paste(rep("\n</div>", n), collapse = "\n")
  paste(res, collapse = "\n")
}
