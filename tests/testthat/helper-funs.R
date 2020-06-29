# Reset the knitr environment
KRESET <- function() {
  knitr::opts_knit$set(knitr::opts_knit$get(default = TRUE))
  knitr::opts_chunk$set(knitr::opts_chunk$get(default = TRUE))
  knitr::knit_hooks$set(knitr::knit_hooks$get(default = TRUE))
}

# Load an example file
example_file <- function(...) {
  # We are not in a knitr document
  system.file("extdata", ..., package = "dovetail")
}

# Make temp file and clean up afterwards
make_tmp <- function(...) {
  tmp <- tempfile(fileext = ".md")
  withr::defer_parent(file.remove(tmp))
  tmp
}

# Provision a temporary directory to be like the jekyll setup and symlink
# the rmd file and any other files/directories needed in the _episodes_rmd
# folder
provision_jekyll <- function(rmd, ...) {
  if (grepl("^/tmp", rmd)) {
    DIR <- dirname(rmd)
    example_file <- function(x) file.path(DIR, x)
    rmd <- basename(rmd)
    dots <- c(...)
    dots <- if (length(dots)) basename(dots) else dots
  } else {
    dots <- c(...)
  }
  # Create a temporary directory
  tmpdir <- tempfile(pattern = "DIR")
  dir.create(tmpdir)
  withr::defer_parent(dir.remove(tmpdir))

  # Add the jekyll structure
  dir.create(file.path(tmpdir, "_episodes"))
  dir.create(file.path(tmpdir, "_episodes_rmd"))
  f <- file.create(file.path(tmpdir, "_episodes", sub("\\.R", ".", rmd)))

  # Link all of the input files
  for (f in c(rmd, dots)) {
    file.symlink(example_file(f), file.path(tmpdir, "_episodes_rmd", f))
  }
  normalizePath(tmpdir)
}

# Take a jekyll-like directory and knit it to the output
#
# Note that this assumes only one markdown file per directory
knit_jekyll <- function(path, env = new.env(), eng = NULL) {
  a_file_in <- function(d) file.path(d, list.files(d, pattern = "*md"))
  if (is.null(eng)) {
    # knitr has an input and output and returns the relative path
    withr::with_dir(path, {
      out <- knitr::knit(
        input = a_file_in("_episodes_rmd"),
        output = a_file_in("_episodes"),
        encoding = "UTF-8",
        envir = env
      )
    })
    normalizePath(file.path(path, out))
  } else {
    # RMarkdown requires a much different syntax and outputs the full path
    withr::with_dir(path, {
      print(dir())
      fin <- a_file_in("_episodes_rmd")
      out <- rmarkdown::render(
        input = fin,
        output_dir = "_episodes",
        output_format = eng,
        encoding = "UTF-8",
        envir = env
      )
    })
    normalizePath(out)
  }
}

chunk_output <- function(TAGS = OUR_TAGS[OUR_TAGS != "end"]) {
  paste0("engine[:] chr \"", TAGS, "\"", collapse = ".+?")
}

expect_tags_match <- function(object, TAGS, n = 2 * length(TAGS) + 2 + 1) {
  # 1. Capture object and label
  act <- quasi_label(rlang::enquo(object), arg = "object")

  # 2. Call expect()
  dtags <- paste0("div class=['\"]", TAGS, "['\"]")
  act$matched <- vapply(dtags, grepl, logical(1), act$val)
  act$n_closed <- length(strsplit(act$val, "[<][/]div")[[1]])
  act$n_open <- length(strsplit(act$val, "[<]div class")[[1]])
  expect(
    all(act$matched),
    sprintf("The following tags are missing from %s: %s", act$lab, paste(TAGS[!act$matched], collapse = ", "))
  )
  expect(
    act$n_closed == act$n_open,
    sprintf(
      "The number of closing div tags are unmatched. Expected %s, got %s",
      format(act$n_open), format(act$n_closed)
    )
  )
  #  (2*length) for each non-end tag
  # + 2 for first and last chunk
  # + 1 fencepost
  act$n <- length(strsplit(act$val, "\\{: .language-")[[1]])
  expect(
    act$n == n,
    sprintf("%s has length %i, not length %i.", act$lab, act$n, n)
  )

  # 3. Invisibly return the value
  invisible(act$val)
}
