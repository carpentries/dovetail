# Tags in this particular file
these_tags <- c("callout", "discussion")

test_that("engines work with absolute dirs", {
  tct <- example_file("options-echo-results.Rmd")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, envir = new.env(), encoding = "UTF-8")
    },
    chunk_output("callout")
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 2)
  # Inline output is still processed
  expect_match(txt, "NOW YOU SEE ME")
  # echoed chunks are echoed
  expect_match(txt, 'print("now you see me")', fixed = TRUE)
  # Suppressed output does not show
  expect_failure(expect_match(txt, 'now you see me" ?\n', perl = TRUE))
  # non-echoed chunks are not echoed
  expect_failure(expect_match(txt, "cat(x)", fixed = TRUE))
  # asis output is shown
  expect_match(txt, 'The cat purrrs on my lap.(?!")', perl = TRUE)
})

test_that("engines work with absolute dirs and parent env", {
  tct <- example_file("options-echo-results.Rmd")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, encoding = "UTF-8")
    },
    chunk_output("callout")
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 2)
  # Inline output is still processed
  expect_match(txt, "NOW YOU SEE ME")
  # echoed chunks are echoed
  expect_match(txt, 'print("now you see me")', fixed = TRUE)
  # Suppressed output does not show
  expect_failure(expect_match(txt, 'now you see me" ?\n', perl = TRUE))
  # non-echoed chunks are not echoed
  expect_failure(expect_match(txt, "cat(x)", fixed = TRUE))
  # asis output is shown
  expect_match(txt, 'The cat purrrs on my lap.(?!")', perl = TRUE)
})

KRESET()

test_that("engines work with relative dirs", {
  tcf <- provision_jekyll("options-echo-results.Rmd")
  expect_output(tct <- knit_jekyll(tcf), chunk_output("callout"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 2)
  # Inline output is still processed
  expect_match(txt, "NOW YOU SEE ME")
  # echoed chunks are echoed
  expect_match(txt, 'print("now you see me")', fixed = TRUE)
  # Suppressed output does not show
  expect_failure(expect_match(txt, 'now you see me" ?\n', perl = TRUE))
  # non-echoed chunks are not echoed
  expect_failure(expect_match(txt, "cat(x)", fixed = TRUE))
  # asis output is shown
  expect_match(txt, 'The cat purrrs on my lap.(?!")', perl = TRUE)
})

test_that("engines work with relative dirs and parent env", {
  tcf <- provision_jekyll("options-echo-results.Rmd")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame()), chunk_output("callout"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 2)
  # Inline output is still processed
  expect_match(txt, "NOW YOU SEE ME")
  # echoed chunks are echoed
  expect_match(txt, 'print("now you see me")', fixed = TRUE)
  # Suppressed output does not show
  expect_failure(expect_match(txt, 'now you see me" ?\n', perl = TRUE))
  # non-echoed chunks are not echoed
  expect_failure(expect_match(txt, "cat(x)", fixed = TRUE))
  # asis output is shown
  expect_match(txt, 'The cat purrrs on my lap.(?!")', perl = TRUE)
})

KRESET()

test_that("engines work with rmarkdown and  relative dirs", {
  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("options-echo-results.Rmd")
  expect_output(tct <- knit_jekyll(tcf, eng = eng), chunk_output("callout"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 2)
})

test_that("engines work with relative dirs and parent env", {
  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("options-echo-results.Rmd")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame(), eng = eng), chunk_output("callout"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 2)
})

KRESET()
