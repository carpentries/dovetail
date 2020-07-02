# Tags in this particular file
these_tags <- character(0)
r_chunks   <- 0

test_that("engines work with absolute dirs", {
  tct <- example_file("uses-include.Rmd")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, envir = new.env(), encoding = "UTF-8")
    },
    chunk_output("callout")
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, these_tags, n = r_chunks + 1)
  # ADD EXPECTATIONS
})

test_that("engines work with absolute dirs and parent env", {
  tct <- example_file("uses-include.Rmd")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, encoding = "UTF-8")
    },
    chunk_output("callout")
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, these_tags, n = r_chunks + 1)
  # ADD EXPECTATIONS
})

KRESET()

test_that("engines work with relative dirs", {
  tcf <- provision_jekyll("uses-include.Rmd")
  expect_output(tct <- knit_jekyll(tcf), chunk_output("callout"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = r_chunks + 1)
  # ADD EXPECTATIONS
})

test_that("engines work with relative dirs and parent env", {
  tcf <- provision_jekyll("uses-include.Rmd")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame()), chunk_output("callout"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = r_chunks + 1)
  # ADD EXPECTATIONS
})

KRESET()

test_that("engines work with rmarkdown and  relative dirs", {
  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("uses-include.Rmd")
  expect_output(tct <- knit_jekyll(tcf, eng = eng), chunk_output("callout"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = r_chunks + 1)
  # ADD EXPECTATIONS
})

test_that("engines work with relative dirs and parent env", {
  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("uses-include.Rmd")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame(), eng = eng), chunk_output("callout"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = r_chunks + 1)
  # ADD EXPECTATIONS
})

KRESET()
