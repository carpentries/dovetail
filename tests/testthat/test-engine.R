test_that("engines have been registered", {

  # We are not in a knitr document
  expect_output(print(knitr::knit_global()), "R_GlobalEnv")
  UNC <- knitr::opts_knit$get("unnamed.chunk.label")
  l   <- list.files(tempdir())

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
  f <- system.file('extdata', 'test-engine.Rmd', package = "dovetail")
  tmp <- tempfile(fileext = ".md")
  on.exit(file.remove(tmp))

  n_words <- 9
  n_char <- 42
  expect_output({
    knitr::knit(f, output = tmp, envir = new.env(), encoding = "UTF-8")
  }, 'engine: chr "challenge"', fixed = TRUE)

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_match(txt, "Now that we know that there are 6 words and 19 characters", fixed = TRUE)

  expect_output({
    knitr::knit(f, output = tmp, encoding = "UTF-8")
  }, 'engine: chr "challenge"', fixed = TRUE)

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_match(txt, "Now that we know that there are 6 words and 19 characters", fixed = TRUE)


})

test_that("engines work with calls to rmarkdown", {

  # We are not in a knitr document
  expect_output(print(knitr::knit_global()), "R_GlobalEnv")
  f <- system.file('extdata', 'test-engine.Rmd', package = "dovetail")
  tmp <- tempfile(fileext = ".md")
  on.exit(file.remove(tmp))

  n_words <- 9
  n_char <- 42
  expect_output({
    rmarkdown::render(f, output_file = tmp, envir = new.env(), encoding = "UTF-8")
  }, 'engine: chr "challenge"', fixed = TRUE)

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_match(txt, "Now that we know that there are 6 words and 19 characters", fixed = TRUE)

  expect_output({
    rmarkdown::render(f, output_file = tmp, encoding = "UTF-8")
  }, 'engine: chr "challenge"', fixed = TRUE)

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_match(txt, "Now that we know that there are 6 words and 19 characters", fixed = TRUE)


})
