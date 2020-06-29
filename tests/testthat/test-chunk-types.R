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
  # All the tags exist
  for (tag in OUR_TAGS[OUR_TAGS != "end"]) {
    expect_match(txt, paste0("div class='", tag, "'"))
  }
  n <- (2 * length(OUR_TAGS)) + 1
  #  (2*9) for each non-end tag
  # + 2 for first and last chunk
  # + 1 fencepost
  expect_length(strsplit(txt, "\\{: .language-r\\}")[[1]], n)
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
  # All the tags exist
  for (tag in OUR_TAGS[OUR_TAGS != "end"]) {
    expect_match(txt, paste0("div class='", tag, "'"))
  }
  n <- (2 * length(OUR_TAGS)) + 1
  #  (2*9) for each non-end tag
  # + 2 for first and last chunk
  # + 1 fencepost
  expect_length(strsplit(txt, "\\{: .language-r\\}")[[1]], n)
})


test_that("engines work with relative dirs", {
  skip_if_not_installed("reticulate")

  tcf <- provision_jekyll("test-chunk-types.Rmd", "data")
  expect_output(tct <- knit_jekyll(tcf), all_chunk_regex)

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  # All the tags exist
  for (tag in OUR_TAGS[OUR_TAGS != "end"]) {
    expect_match(txt, paste0("div class='", tag, "'"))
  }
  n <- (2 * length(OUR_TAGS)) + 1
  #  (2*9) for each non-end tag
  # + 2 for first and last chunk
  # + 1 fencepost
  expect_length(strsplit(txt, "\\{: .language-r\\}")[[1]], n)
})

test_that("engines work with relative dirs and parent env", {
  skip_if_not_installed("reticulate")

  tcf <- provision_jekyll("test-chunk-types.Rmd", "data")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame()), all_chunk_regex)

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  # All the tags exist
  for (tag in OUR_TAGS[OUR_TAGS != "end"]) {
    expect_match(txt, paste0("div class='", tag, "'"))
  }
  n <- (2 * length(OUR_TAGS)) + 1
  #  (2*9) for each non-end tag
  # + 2 for first and last chunk
  # + 1 fencepost
  expect_length(strsplit(txt, "\\{: .language-r\\}")[[1]], n)
})


test_that("engines work with relative dirs and rmarkdown", {
  skip_if_not_installed("reticulate")

  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("test-chunk-types.Rmd", "data")
  expect_output(tct <- knit_jekyll(tcf, eng = eng), all_chunk_regex)

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  # All the tags exist
  for (tag in OUR_TAGS[OUR_TAGS != "end"]) {
    expect_match(txt, paste0("div class=['\"]", tag, "['\"]"))
  }
  n <- (2 * length(OUR_TAGS)) + 1
  #  (2*9) for each non-end tag
  # + 2 for first and last chunk
  # + 1 fencepost
  expect_length(strsplit(txt, "\\{: .language-r\\}")[[1]], n)
})


test_that("engines work with relative dirs and rmarkdown and parent env", {
  skip_if_not_installed("reticulate")

  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  tcf <- provision_jekyll("test-chunk-types.Rmd", "data")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame(), eng = eng), all_chunk_regex)

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  # All the tags exist
  for (tag in OUR_TAGS[OUR_TAGS != "end"]) {
    expect_match(txt, paste0("div class=['\"]", tag, "['\"]"))
  }
  n <- (2 * length(OUR_TAGS)) + 1
  #  (2*9) for each non-end tag
  # + 2 for first and last chunk
  # + 1 fencepost
  expect_length(strsplit(txt, "\\{: .language-r\\}")[[1]], n)
})
