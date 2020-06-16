roxy_render <- function(path, output_file = NULL, ...) {
  ## use same directory as the orignal file to not mess the paths
  ## during the knitting
  path <- normalizePath(path)
  tmp <- tempfile(tmpdir = dirname(path), fileext = ".Rmd")
  on.exit(unlink(tmp))

  first_pass <- extract_blocks(path, out = tmp)

  if (is.null(output_file)) {
    ## FIXME: we may want to support other formats there.
    output_file <- gsub("\\.[Rr]md$", ".html", path)
  }

  rmarkdown::render(input = tmp, output_file = output_file, ...)
}
