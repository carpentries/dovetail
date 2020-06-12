OUR_TAGS <- c(
  "callout",
  "challenge",
  "checklist",
  "discussion",
  "keypoints",
  "objectives",
  "prereq",
  "solution",
  "testimonial"
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
  head <- if (x$val['head'] == '') '' else paste0("## ", x$val['head'], "\n")
  paste(head, x$val['body'])
}
