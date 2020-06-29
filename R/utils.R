OUR_TAGS <- c(
  "callout",
  "challenge",
  "checklist",
  "discussion",
  "keypoints",
  "objectives",
  "prereq",
  "solution",
  "testimonial",
  "end"
)

# Not in function
`%nin%` <- Negate("%in%")

# grab the header and make it the tag header
tag_section <- function(x) {
  xx <- strsplit(x$raw, "\n")
  body <- paste0(xx[[1]][-1], collapse = "\n")
  x$val <- c(head = trimws(xx[[1]][1]), body = body)
  x
}


rxyfmt <- function(x) {
  head <- if (x$val["head"] == "") "" else paste0("## ", x$val["head"], "\n")
  paste(head, x$val["body"])
}

# Internal counter function
cp_counter <- function(N = 0, prefix = "dovetail-chunk-") {
  n <- N
  prefix <- prefix
  function(reset = FALSE) {
    n <<- if (reset) N else n + 1L
    return(paste0(prefix, n))
  }
}

dove_chunk_label <- cp_counter()
