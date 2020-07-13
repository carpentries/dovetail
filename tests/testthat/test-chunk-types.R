test_that("engines work with absolute dirs", {
  tct <- example_file("test-chunk-types.Rmd")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, envir = new.env(), encoding = "UTF-8")
    },
    chunk_output()
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, OUR_TAGS[OUR_TAGS != "end"])
})


test_that("engines work with absolute dirs and parent env", {
  tct <- example_file("test-chunk-types.Rmd")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, envir = parent.frame(), encoding = "UTF-8")
    },
    chunk_output()
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, OUR_TAGS[OUR_TAGS != "end"])
})


test_that("engines work with relative dirs", {
  tcf <- provision_jekyll("test-chunk-types.Rmd", "data")
  expect_output(tct <- knit_jekyll(tcf), chunk_output())

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, OUR_TAGS[OUR_TAGS != "end"])
})

test_that("engines work with relative dirs and parent env", {
  tcf <- provision_jekyll("test-chunk-types.Rmd", "data")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame()), chunk_output())

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, OUR_TAGS[OUR_TAGS != "end"])
})


test_that("engines work with relative dirs and rmarkdown", {
  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("test-chunk-types.Rmd", "data")
  expect_output(tct <- knit_jekyll(tcf, eng = eng), chunk_output())

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  # All the tags exist
  expect_tags_match(txt, OUR_TAGS[OUR_TAGS != "end"])
})


test_that("engines work with relative dirs and rmarkdown and parent env", {
  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("test-chunk-types.Rmd", "data")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame(), eng = eng), chunk_output())

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, OUR_TAGS[OUR_TAGS != "end"])
})


# Reset knitr environment
KRESET()
