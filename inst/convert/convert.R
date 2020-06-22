if (!requireNamespace("remotes")) {
  install.packages("remotes")
}
remotes::install_github("zkamvar/pegboard")
library("pegboard")
library("purrr")
library("xml2")

# Grab the current lesson
# l <- get_lesson("swcarpentry/r-novice-inflammation", rmd = TRUE)
l <- Lesson$new(".", rmd = TRUE)

make_r_chunks <- function(cblocks) {
  # Regex to find the beginning of a code chunk that is possibly an R chunk
  r_chunk <- "```\n(?!(#'|$))"
  # Filtering on all code blocks that are in our valid tags
  blocks <- cblocks[xml2::xml_attr(cblocks, "language") %in% dovetail:::OUR_TAGS]
  # substituting all the blank chunks within the code for r tags
  new_text <- gsub(r_chunk, "```{r}\n\\1", xml2::xml_text(blocks), perl = TRUE)
  xml2::xml_text(blocks) <- new_text
}

use_dovetail <- function(body) {
  setup <- xml2::xml_find_first(body, ".//d1:code_block[contains(text(), '../bin/chunk-options.R')]")
  txt   <- xml2::xml_text(setup)
  txt   <- gsub(
    "source\\(.../bin/chunk-options.R.\\)", 
    "library('dovetail')\nsource(dvt_opts())",
    txt
  )
  xml2::xml_text(setup) <- txt
}

# Fix setup
walk(l$episodes, ~.x$body %>% use_dovetail())
# Transform the blocks to chunks
walk(l$episodes, ~.x$unblock()$code %>% make_r_chunks())
# Overwrite the files
walk(l$episodes, ~.x$write(path = dirname(.x$path), format = "Rmd"))
