parse_block <- function(txt) {
  # Note: this is the regex to find lines that don't start with #'
  doc <- "\n(?!#+['][ ]?)"
  TXT <- gsub(doc, "\n#' \\1", txt, perl = TRUE)
  parsed <- roxygen2::parse_text(paste0(TXT, "\nNULL"), env = NULL)[[1]]
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
  res[length(res)] <- if (previous == "solution") "\n</div></div>" else "\n</div></div>"
  res
}


print_tag <- function(block, previous = NULL, parent = NULL) {
  if (!is.null(previous) && previous == "solution" && block$tag != previous) {
    start <- "\n</div>\n"
  } else {
    start <- "\n"
  }
  if (is.null(parent) || parent != block$tag) {
    div <- paste0("<div class='", block$tag, "'>\n")
  } else {
    div <- "\n"
  }
  head <- if (block$val["head"] != "") paste("##", block$val["head"]) else "\n"
  paste0(start, div, head, block$val["body"], "\n")
}
