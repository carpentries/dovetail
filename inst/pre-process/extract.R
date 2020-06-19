extract_blocks <- function(file, out = NULL) {

  lines <- readLines(file)

  pos_begin_blocks <- grep(
    "^[\t >]*```+\\s*\\{([a-zA-Z0-9_]+( *[ ,].*)?)\\}\\s*$",
    lines
  )

  pos_end_blocks <- grep(
    "^[\t >]*```+\\s*$",
    lines
  )

  all_chunks <- purrr::map2(
    pos_begin_blocks,
    pos_end_blocks,
    function(.x, .y) {
      lines[.x:.y]
    })

  is_carp_chunk <- purrr::map_lgl(
    all_chunks,
    function(.x) {
      grepl("\\{carp", .x[1])
    }
  )

  parsed_carp_chunks <- purrr::map(
    all_chunks[is_carp_chunk],
    function(.x) {
      parse_block(paste(.x[2:(length(.x)-1)], collapse = "\n"))
    }
  )

  i <- 1
  res <- purrr::imap(
    pos_begin_blocks[is_carp_chunk],
    function(pos_block, block_n) {
      ret <- c(
        lines[i:(pos_block - 1)],
        parsed_carp_chunks[[block_n]]
      )
      i <<- i + pos_end_blocks[is_carp_chunk][block_n]
      ret
    }
  )
  res <- unlist(res)

  if (is.null(out)) {
    return(res)
  }

  writeLines(res, con = out)
}
