
test_that("engines have been registered", {

  # We are not in a knitr document
  expect_output(print(knitr::knit_global()), "R_GlobalEnv")
  UNC <- knitr::opts_knit$get("unnamed.chunk.label")
  l <- list.files(tempdir())

  # Testing that the function works without assigning something to to global
  # namespace.
  kenv <- getFromNamespace(".knitEnv", asNamespace("knitr"))
  e <- new.env()
  assign("h", list(ello = "hello", ere = "there"), envir = e)
  assign("knit_global", e, kenv)
  withr::defer((rm("knit_global", envir = kenv)))

  txt <- "
#' Hello Challenge
#' Say hello
#'
#' @solution olleH Solution
#'
#' ```{r}
#' h$ello
#' h$ere
#' ```
"

  for (i in OUR_TAGS) {
    ENG <- engine_generic_carp(i)
    KNG <- knitr::knit_engines$get(i)
    expect_type(ENG, "closure")
    # The chunk labels are the time with a random number
    expect_output(res <- ENG(list(engine = i, code = txt)), paste("label:", Sys.Date()), fixed = TRUE)
    expect_output(kes <- KNG(list(engine = i, code = txt)), paste("label:", Sys.Date()), fixed = TRUE)
    expect_identical(res, kes)
    # Output is produced
    expect_match(res, '[1] "hello"', fixed = TRUE)
    expect_match(res, '[1] "there"', fixed = TRUE)
    # Div tags are applied
    div_expected <- paste0("<div class='", i, "' markdown='1'>")
    expect_match(res, div_expected, fixed = TRUE)
    # No files are leftover
    expect_identical(l, list.files(tempdir()))
    # Unnamed chunk label stays the same
    expect_identical(knitr::opts_knit$get("unnamed.chunk.label"), UNC)
  }
})


test_that("engines work with calls to knitr", {

  # We are not in a knitr document
  expect_output(print(knitr::knit_global()), "R_GlobalEnv")
  tmp <- make_tmp()
  f <- example_file("test-engine.Rmd")

  n_words <- 9
  n_char <- 42
  expect_output(
    {
      knitr::knit(f, output = tmp, envir = new.env(), encoding = "UTF-8")
    },
    'engine: chr "challenge"',
    fixed = TRUE
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_match(txt, "Now that we know that there are 6 words and 19 characters", fixed = TRUE)

  expect_output(
    {
      knitr::knit(f, output = tmp, encoding = "UTF-8")
    },
    'engine: chr "challenge"',
    fixed = TRUE
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_match(txt, "Now that we know that there are 6 words and 19 characters", fixed = TRUE)

  p <- provision_jekyll("produces-plot.Rmd")
  expect_output(tmp <- knit_jekyll(p), 'engine: chr "callout"', fixed = TRUE)

  txt <- readLines(tmp)
  # The output directories are the same
  dirs <- grep("OUT DIR:", txt, value = TRUE)
  expect_length(dirs, 2)
  expect_identical(dirs[[1]], dirs[[2]])
  expect_true(grepl(p, gsub("OUT DIR: ?", "", dirs[[1]]), fixed = TRUE))

  # There are is Jekyll-style formatting
  expect_true(sum(grepl("~~~", txt, fixed = TRUE)) > 0)
})

test_that("engines work with calls to rmarkdown", {

  # Note: RMarkdown behaves a bit differently than knitr in that it's a bit more
  # opinionated with its output.
  #
  # We are not in a knitr document
  expect_output(print(knitr::knit_global()), "R_GlobalEnv")
  tmp <- make_tmp()
  f <- example_file("test-engine.Rmd")

  n_words <- 9
  n_char <- 42
  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  expect_output(
    {
      rmarkdown::render(f, output_file = tmp, envir = new.env(), encoding = "UTF-8", output_format = eng)
    },
    'engine: chr "challenge"',
    fixed = TRUE
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_match(txt, "Now that we know that there are 6 words and 19 characters", fixed = TRUE)

  expect_output(
    {
      rmarkdown::render(f, output_file = tmp, encoding = "UTF-8", output_format = eng)
    },
    'engine: chr "challenge"',
    fixed = TRUE
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_match(txt, "Now that we know that there are 6 words and 19 characters", fixed = TRUE)

  p <- example_file("produces-plot.Rmd")
  tmp <- make_tmp()

  withr::with_dir(system.file("extdata", package = "dovetail"), {
    ok <- knitr::opts_knit$get()
    expect_output(
      {
        rmarkdown::render(p, output_file = tmp, envir = new.env(), encoding = "UTF-8", output_format = eng)
      },
      'engine: chr "callout"',
      fixed = TRUE
    )

    txt <- readLines(tmp)
    # The output directories are the same
    dirs <- grep("OUT DIR:", txt, value = TRUE)
    expect_length(dirs, 2)
    expect_identical(dirs[[1]], dirs[[2]])

    # There are is Jekyll-style formatting
    expect_true(sum(grepl("{: .output}", txt, fixed = TRUE)) > 0)
  })
})
