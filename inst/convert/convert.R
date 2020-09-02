if (!requireNamespace("remotes")) {
  install.packages("remotes")
}

remotes::install_github("carpentries/pegboard")
library("pegboard")
library("purrr")
library("xml2")

if (!exists("jekyll")) {
  message("\n\nAssuming a jekyll setup. To use a {sandpaper} setup, use:\n\n  jekyll <- FALSE\n-----------------\n")
  jekyll <- TRUE
}
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

use_dovetail <- function(ep) {
  body  <- ep$body
  setup <- xml2::xml_find_first(body, ".//d1:code_block[contains(text(), '../bin/chunk-options.R')]")
  dvtl <- "library('dovetail')"
  dvtl <- if (jekyll) paste0(dvtl, "\nsource(dvt_opts())") else dvtl
  txt  <- xml2::xml_text(setup)
  txt  <- sub("source\\(.../bin/chunk-options.R.\\)", dvtl, txt)
  if (!jekyll) txt  <- sub("knitr_fig_path\\(.+?\\)", "", txt)
  xml2::xml_text(setup) <- txt
  ep$move_questions()
  ep$move_objectives()
  ep$move_keypoints()
}

# Fix setup
message("1/3: Converting block quotes to dovetail chunks...")
walk(l$episodes, use_dovetail)
# Transform the blocks to chunks
message("2/3: Transforming blank code blocks to R chunks...")
walk(l$episodes, ~.x$unblock()$code %>% make_r_chunks())
message("3/3: Overwriting the files...")
# Overwrite the files
walk(l$episodes, ~.x$write(path = dirname(.x$path), format = "Rmd"))
message("Done.")
message("\nTo keep these changes, add and commit them to git.\nTo discard these changes, use\n\n  git checkout -- _episodes_rmd/")
