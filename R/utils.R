OUR_TAGS <- c("challenge", "solution")

get_tags_from_block <- function(b) {
  vapply(b$tags, function(i) i$tag, character(1))
}

block_has_our_tags <- function(b, ours = OUR_TAGS) {
  res <- ours %in% get_tags_from_block(b)
  names(res) <- ours
  res
}

get_code_boundaries <- function(vec_is_doc) {
  code_start <- false_after_true(vec_is_doc)
  code_end <- false_before_true(vec_is_doc)
  matrix(c(code_start, code_end), ncol = 2)
}

false_after_true <- function(found_docs) {
  # Find TRUE/FALSE boundaries
  which(found_docs[-length(found_docs)] & !found_docs[-1]) + 1L
}

false_before_true <- function(found_docs) {
  # Find FALSE/TRUE boundaries
  which(!found_docs[-length(found_docs)] & found_docs[-1])
}