#' Parse A roxygen-formatted block to into a block to be rendered as markdown
#'
#' @param txt a character vector of length 1 that represents a block of text
#'
#' @return the modified block with div tags assigned in the appropriate places
#' @export
#' @examples
#' # Simple example showing that the block can be parsed with knitr in its own
#' # environment
#' e <- new.env()
#' assign("h", list(ello = "hello", ere = "there"), env = e)
#' txt <- parse_block("
#' #' @challenge Hello Challenge
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
#' knitr::knit(output = tmp, text = txt, env = e)
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
parse_block <- function(txt) {
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
    return(paste(vapply(parsed$tags, print_tag, character(1)), collapse = "\n"))
  }


  res <- character(length(parsed$tags) + 1L)
  previous <- NULL
  parent <- NULL
  for (i in seq(parsed$tags)) {
    res[[i]] <- print_tag(parsed$tags[[i]], previous, parent)
    if (i == 1) {
      parent <- parsed$tags[[i]]$tag
    }
    previous <- parsed$tags[[i]]$tag
  }
  # There will always be a hanging div tag, so we need to close it.
  res[length(res)] <- if (previous == "solution") "\n</div></div>" else "\n</div>"
  paste(res, collapse = "\n")
}


#' Print the div tag and text
#'
#' @param block a roxygen2 tag
#' @param previous the value of the previous roxygen tag
#' @param parent the value of the overall parent tag
#'
#' @return a character vector
#' @keywords internal
#'
#' @examples
print_tag <- function(block, previous = NULL, parent = NULL) {
  if (block$tag %nin% OUR_TAGS) {
    return(block$raw)
  }

  if (!is.null(previous) && previous == "solution" && block$tag != previous) {
    start <- "\n</div>\n"
  } else {
    start <- "\n"
  }
  if (is.null(parent) || parent != block$tag) {
    div <- paste0("<div class='", block$tag, "'>\n\n")
  } else {
    div <- "\n"
  }
  paste0(start, div, format(block$val))
}
