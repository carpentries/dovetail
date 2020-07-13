# Reset the knitr environment
KRESET <- function() {
  knitr::opts_knit$set(knitr::opts_knit$get(default = TRUE))
  knitr::opts_chunk$set(knitr::opts_chunk$get(default = TRUE))
  knitr::knit_hooks$set(knitr::knit_hooks$get(default = TRUE))
}

mock_block <- function(txt) {
  paste0(
    "<div class='challenge' markdown='1'>\n\n",
    gsub("#' ", "", txt, fixed = TRUE),
    "\n\n</div>"
  )
}

# Load an example file
example_file <- function(...) {
  # We are not in a knitr document
  system.file("extdata", ..., package = "dovetail")
}

# Make temp file and clean up afterwards
make_tmp <- function(...) {
  tmp <- tempfile(fileext = ".md")
  withr::defer_parent(fs::file_delete(tmp))
  tmp
}

# Provision a temporary directory to be like the jekyll setup and symlink
# the rmd file and any other files/directories needed in the _episodes_rmd
# folder
provision_jekyll <- function(rmd, ...) {
  if (grepl("^/tmp", rmd)) {
    DIR <- fs::path_dir(rmd)
    example_file <- function(x) fs::path(DIR, x)
    rmd <- fs::path_file(rmd)
    dots <- c(...)
    dots <- if (length(dots)) fs::path_dir(dots) else dots
  } else {
    dots <- c(...)
  }
  # Create a temporary directory
  tmpdir <- fs::file_temp(pattern = "DIR")
  fs::dir_create(tmpdir)
  withr::defer_parent(fs::dir_delete(tmpdir))

  # Add the jekyll structure
  fs::dir_create(fs::path(tmpdir, "_episodes"))
  fs::dir_create(fs::path(tmpdir, "_episodes_rmd"))
  f <- fs::file_create(fs::path(tmpdir, "_episodes", sub("\\.R", ".", rmd)))

  # Link all of the input files
  for (f in c(rmd, dots)) {
    to <- fs::path(tmpdir, "_episodes_rmd", f)
    from <- example_file(f)
    if (fs::is_file(from)) {
      fs::file_copy(from, to)
    } else {
      fs::dir_copy(from, to)
    }
  }
  normalizePath(tmpdir)
}

# Take a jekyll-like directory and knit it to the output
#
# Note that this assumes only one markdown file per directory
knit_jekyll <- function(path, env = new.env(), eng = NULL) {
  episode_out <- withr::with_dir(path, fs::dir_ls("_episodes"))
  episode_in <- sub("\\.md", ".Rmd", episode_out)
  episode_in <- sub("_episodes", "_episodes_rmd", episode_in)
  if (is.null(eng)) {
    # knitr has an input and output and returns the relative path
    withr::with_dir(path, {
      out <- knitr::knit(
        input = episode_in,
        output = episode_out,
        encoding = "UTF-8",
        envir = env
      )
    })
    normalizePath(fs::path(path, out))
  } else {
    # RMarkdown requires a much different syntax and outputs the full path
    withr::with_dir(path, {
      out <- rmarkdown::render(
        input = episode_in,
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
  paste0("engine *?[:] chr \"", TAGS, "\"", collapse = ".+?")
}

expect_tags_match <- function(object, TAGS, n = 2 * length(TAGS) + 2 + 1) {
  # 1. Capture object and label
  act <- quasi_label(rlang::enquo(object), arg = "object")

  # 2. Call expect()
  if (length(TAGS)) {
    dtags <- paste0("div class=['\"]", TAGS, "['\"]")
    act$matched <- vapply(dtags, grepl, logical(1), act$val)
    expect(
      all(act$matched),
      sprintf("The following tags are missing from %s: %s", act$lab, paste(TAGS[!act$matched], collapse = ", "))
    )
  }
  act$n_closed <- length(strsplit(act$val, "[<][/]div")[[1]])
  act$n_open <- length(strsplit(act$val, "[<]div class")[[1]])
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
