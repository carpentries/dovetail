# The file to test
the_file     <- "example-solution-in-list.Rmd"
# Tags in this particular file
these_tags   <- c("challenge", rep("solution", 3L))
# Number of expected language chunks to show up
lang_chunks  <- 3L
# One of the top-level chunks processed through our engines
output_chunk <- "challenge"

test_that("engines work with absolute dirs", {
  tct <- example_file(the_file)
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, envir = new.env(), encoding = "UTF-8")
    },
    chunk_output(output_chunk)
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, these_tags, n = lang_chunks + 1)
  expect_match(txt, "[1] 2", fixed = TRUE)
  expect_match(txt, "[1] 3", fixed = TRUE)
  expect_match(txt, "[1] 5", fixed = TRUE)
  expect_match(txt, "8", fixed = TRUE)
})

test_that("engines work with absolute dirs and parent env", {
  tct <- example_file(the_file)
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, encoding = "UTF-8")
    },
    chunk_output(output_chunk)
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, these_tags, n = lang_chunks + 1)
  expect_match(txt, "[1] 2", fixed = TRUE)
  expect_match(txt, "[1] 3", fixed = TRUE)
  expect_match(txt, "[1] 5", fixed = TRUE)
  expect_match(txt, "8", fixed = TRUE)
})

KRESET()

test_that("engines work with relative dirs", {
  tcf <- provision_jekyll(the_file)
  expect_output(tct <- knit_jekyll(tcf), chunk_output(output_chunk))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = lang_chunks + 1)
  # ADD EXPECTATIONS
  expect_match(txt, "[1] 2", fixed = TRUE)
  expect_match(txt, "[1] 3", fixed = TRUE)
  expect_match(txt, "[1] 5", fixed = TRUE)
  expect_match(txt, "8", fixed = TRUE)
})

test_that("engines work with relative dirs and parent env", {
  tcf <- provision_jekyll(the_file)
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame()), chunk_output(output_chunk))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = lang_chunks + 1)
  # ADD EXPECTATIONS
  expect_match(txt, "[1] 2", fixed = TRUE)
  expect_match(txt, "[1] 3", fixed = TRUE)
  expect_match(txt, "[1] 5", fixed = TRUE)
  expect_match(txt, "8", fixed = TRUE)
})

KRESET()

test_that("engines work with rmarkdown and  relative dirs", {
  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll(the_file)
  expect_output(tct <- knit_jekyll(tcf, eng = eng), chunk_output(output_chunk))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = lang_chunks + 1)
  # ADD EXPECTATIONS
  expect_match(txt, "[1] 2", fixed = TRUE)
  expect_match(txt, "[1] 3", fixed = TRUE)
  expect_match(txt, "[1] 5", fixed = TRUE)
  expect_match(txt, "8", fixed = TRUE)
})

test_that("engines work with relative dirs and parent env", {
  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll(the_file)
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame(), eng = eng), chunk_output(output_chunk))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = lang_chunks + 1)
  # ADD EXPECTATIONS
  expect_match(txt, "[1] 2", fixed = TRUE)
  expect_match(txt, "[1] 3", fixed = TRUE)
  expect_match(txt, "[1] 5", fixed = TRUE)
  expect_match(txt, "8", fixed = TRUE)
})

KRESET()
