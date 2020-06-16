test_that("engines have been registered", {

  for (i in OUR_TAGS) {
    expect_type(knitr::knit_engines$get(i), "closure")
  }

})


test_that("engines work with calls to knitr", {

  f <- system.file('extdata', 'test-engine.Rmd', package = "roxyblox")
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

  f <- system.file('extdata', 'test-engine.Rmd', package = "roxyblox")
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
