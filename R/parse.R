add_divs <- function(txt) {
  tmp <- tempfile()
  on.exit(file.remove(tmp))
  cat(txt, file = tmp)
  blocks <- roxygen2::parse_file(tmp, env = NULL)
  previous_div <- block_has_our_tags(blocks[[1]])
  for (block in blocks) {
    this_div <- block_has_our_tags(block)
    # When there are no matching tags, move on to the next block
    if (sum(this_div) == 0) {
      next
    }
    div <- paste0("<div class='", names(this_div)[this_div], "'>")
    # When the div tags don't match up, it's time to close
    if (sum(previous_div & this_div) == 0) {
      div <- paste0("</div>", div)
    }
  }
}
