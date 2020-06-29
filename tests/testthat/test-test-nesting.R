# Tags in this particular file
these_tags <- c("challenge", "solution", "callout")

test_that("engines work with absolute dirs", {
  tct <- example_file("test-nesting.Rmd")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, envir = new.env(), encoding = "UTF-8")
    },
    chunk_output(c("challenge", "challenge"))
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 5)
})

test_that("engines work with absolute dirs and parent env", {
  tct <- example_file("test-nesting.Rmd")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, encoding = "UTF-8")
    },
    chunk_output(c("challenge", "challenge"))
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 5)
})

KRESET()

test_that("engines work with relative dirs", {
  tcf <- provision_jekyll("test-nesting.Rmd")
  expect_output(tct <- knit_jekyll(tcf), chunk_output(c("challenge", "challenge")))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 5)
})

test_that("engines work with relative dirs and parent env", {
  tcf <- provision_jekyll("test-nesting.Rmd")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame()), chunk_output(c("challenge", "challenge")))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 5)
})

KRESET()

test_that("engines work with rmarkdown and  relative dirs", {
  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("test-nesting.Rmd")
  expect_output(tct <- knit_jekyll(tcf, eng = eng), chunk_output(c("challenge", "challenge")))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 5)
})

test_that("engines work with relative dirs and parent env", {
  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("test-nesting.Rmd")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame(), eng = eng), chunk_output(c("challenge", "challenge")))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 5)
})

KRESET()
