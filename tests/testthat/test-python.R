test_that("python engines work with absolute dirs", {
  skip_if_not_installed("reticulate")
  pyf <- example_file("example-python.Rmd")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(pyf, output = tmp, envir = new.env(), encoding = "UTF-8")
    },
    'engine: chr "challenge"',
    fixed = TRUE
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_match(txt, "There were 14 cases of good sleep", fixed = TRUE)
  expect_match(txt, "{: .language-python}", fixed = TRUE)
})


test_that("python engines work with absolute dirs and parent env", {
  skip_if_not_installed("reticulate")
  pyf <- example_file("example-python.Rmd")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(pyf, output = tmp, envir = parent.frame(), encoding = "UTF-8")
    },
    'engine: chr "challenge"',
    fixed = TRUE
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_match(txt, "There were 14 cases of good sleep", fixed = TRUE)
  expect_match(txt, "{: .language-python}", fixed = TRUE)
})


test_that("python engines work with relative dirs", {
  skip_if_not_installed("reticulate")

  py1 <- provision_jekyll("example-python.Rmd", "data")
  expect_output(pyf <- knit_jekyll(py1), 'engine: chr "challenge"', fixed = TRUE)

  expect_true(file.exists(pyf))
  txt <- paste(readLines(pyf), collapse = "\n")
  expect_match(txt, "There were 14 cases of good sleep", fixed = TRUE)
  expect_match(txt, "{: .language-python}", fixed = TRUE)
})


test_that("python engines work with relative dirs and parent env", {
  skip_if_not_installed("reticulate")

  py1 <- provision_jekyll("example-python.Rmd", "data")
  expect_output(pyf <- knit_jekyll(py1, env = parent.frame()), 'engine: chr "challenge"', fixed = TRUE)

  expect_true(file.exists(pyf))
  txt <- paste(readLines(pyf), collapse = "\n")
  expect_match(txt, "There were 14 cases of good sleep", fixed = TRUE)
  expect_match(txt, "{: .language-python}", fixed = TRUE)
})


test_that("python engines work with relative dirs and rmarkdown", {
  skip_if_not_installed("reticulate")

  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  py1 <- provision_jekyll("example-python.Rmd", "data")
  expect_output(pyf <- knit_jekyll(py1, eng = eng), 'engine: chr "challenge"', fixed = TRUE)

  expect_true(file.exists(pyf))
  txt <- paste(readLines(pyf), collapse = "\n")
  expect_match(txt, "There were 14 cases of good sleep", fixed = TRUE)
  expect_match(txt, "{: .language-python}", fixed = TRUE)
})


test_that("python engines work with relative dirs and rmarkdown and parent env", {
  skip_if_not_installed("reticulate")

  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  py1 <- provision_jekyll("example-python.Rmd", "data")
  expect_output(pyf <- knit_jekyll(py1, env = parent.frame(), eng = eng), 'engine: chr "challenge"', fixed = TRUE)

  expect_true(file.exists(pyf))
  txt <- paste(readLines(pyf), collapse = "\n")
  expect_match(txt, "There were 14 cases of good sleep", fixed = TRUE)
  expect_match(txt, "{: .language-python}", fixed = TRUE)
})
