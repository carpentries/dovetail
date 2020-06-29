test_that("engines work with absolute dirs", {
  tct <- example_file("test-chunk-types.Rmd")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, envir = new.env(), encoding = "UTF-8")
    },
    all_chunk_regex
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
    all_chunk_regex
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, OUR_TAGS[OUR_TAGS != "end"])
})


test_that("engines work with relative dirs", {
  skip_if_not_installed("reticulate")

  tcf <- provision_jekyll("test-chunk-types.Rmd", "data")
  expect_output(tct <- knit_jekyll(tcf), all_chunk_regex)

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, OUR_TAGS[OUR_TAGS != "end"])
})

test_that("engines work with relative dirs and parent env", {
  skip_if_not_installed("reticulate")

  tcf <- provision_jekyll("test-chunk-types.Rmd", "data")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame()), all_chunk_regex)

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, OUR_TAGS[OUR_TAGS != "end"])
})


test_that("engines work with relative dirs and rmarkdown", {
  skip_if_not_installed("reticulate")

  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("test-chunk-types.Rmd", "data")
  expect_output(tct <- knit_jekyll(tcf, eng = eng), all_chunk_regex)

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  # All the tags exist
  expect_tags_match(txt, OUR_TAGS[OUR_TAGS != "end"])
})


test_that("engines work with relative dirs and rmarkdown and parent env", {
  skip_if_not_installed("reticulate")

  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("test-chunk-types.Rmd", "data")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame(), eng = eng), all_chunk_regex)

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, OUR_TAGS[OUR_TAGS != "end"])
})


# Reset knitr environment
KRESET()
