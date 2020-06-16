test_that("engines have been registered", {

  for (i in OUR_TAGS) {
    expect_type(knitr::knit_engines$get(i), "closure")
  }

})


test_that("engines work with calls to knitr", {

  f <- system.file('extdata', 'test-engine.Rmd', package = "roxyblox")
  tmp <- tempfile(fileext = ".md")
  on.exit(file.remove(tmp))

  expect_output({
    knitr::knit(f, output = tmp, envir = new.env(), encoding = "UTF-8")
  }, 'engine: chr "challenge"', fixed = TRUE)

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_match(txt, "Now that we know that there are 6 words and 19 characters", fixed = TRUE)

})
