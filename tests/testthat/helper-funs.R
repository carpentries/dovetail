
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
  tmpdir
}

# Take a jekyll-like directory and knit it to the output
#
# Note that this assumes only one markdown file per directory
knit_jekyll <- function(path, env = new.env()) {
  a_file_in <- function(d) file.path(d, list.files(d, pattern = "*md"))
  withr::with_dir(path, {
    out <- knitr::knit(
      input = a_file_in("_episodes_rmd"),
      output = a_file_in("_episodes"),
      encoding = "UTF-8",
      envir = env
    )
  })
  file.path(path, out)
}
