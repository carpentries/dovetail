# Tags in this particular file
these_tags <- c("solution", "callout", "solution")
plot_lines <- length(readLines(example_file("produces-plot.Rmd")))
the_line <- paste("there are", plot_lines, "lines in produces-plot.Rmd")

test_that("engines work with absolute dirs", {
  tct <- example_file("uses-external-file.Rmd")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, envir = new.env(), encoding = "UTF-8")
    },
    chunk_output("solution")
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 2)
  expect_match(txt, the_line)
  expect_match(txt, sub("are", "were", the_line))
})

test_that("engines work with absolute dirs and parent env", {
  tct <- example_file("uses-external-file.Rmd")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, encoding = "UTF-8")
    },
    chunk_output("solution")
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 2)
  expect_match(txt, the_line)
  expect_match(txt, sub("are", "were", the_line))
})

KRESET()

test_that("engines work with relative dirs", {
  tcf <- provision_jekyll("uses-external-file.Rmd", "produces-plot.Rmd")
  expect_output(tct <- knit_jekyll(tcf), chunk_output("solution"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 2)
  expect_match(txt, the_line)
  expect_match(txt, sub("are", "were", the_line))
})

test_that("engines work with relative dirs and parent env", {
  tcf <- provision_jekyll("uses-external-file.Rmd", "produces-plot.Rmd")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame()), chunk_output("solution"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 2)
  expect_match(txt, the_line)
  expect_match(txt, sub("are", "were", the_line))
})

KRESET()

test_that("engines work with rmarkdown and  relative dirs", {
  skip("need to rework changing directory in engine")

  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("uses-external-file.Rmd", "produces-plot.Rmd")
  expect_output(tct <- knit_jekyll(tcf, eng = eng), chunk_output("solution"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 2)
  expect_match(txt, the_line)
  expect_match(txt, sub("are", "were", the_line))
})

test_that("engines work with relative dirs and parent env", {
  skip("need to rework changing directory in engine")

  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("uses-external-file.Rmd", "produces-plot.Rmd")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame(), eng = eng), chunk_output("solution"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 2)
  expect_match(txt, the_line)
  expect_match(txt, sub("are", "were", the_line))
})

KRESET()
