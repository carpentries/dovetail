OUR_TAGS <- c("challenge", "solution")

get_tags_from_block <- function(b) {
  vapply(b$tags, function(i) i$tag, character(1))
}

block_has_our_tags <- function(b, ours = OUR_TAGS) {
  res <- ours %in% get_tags_from_block(b)
  names(res) <- ours
  res
}
