test_that("engines work with calls to knitr", {

  # We are not in a knitr document
  expect_output(print(knitr::knit_global()), "R_GlobalEnv")
  # With a new environment -----------------------------------------------------
  p <- provision_jekyll("produces-plot.Rmd")
  expect_output(tmp <- knit_jekyll(p), 'engine: chr "callout"', fixed = TRUE)

  txt <- readLines(tmp)
  # The output directories are the same
  dirs <- grep("OUT DIR:", txt, value = TRUE)
  expect_length(dirs, 2)
  expect_identical(dirs[[1]], dirs[[2]])
  expect_identical(p, gsub("OUT DIR: ?", "", dirs[[1]]))

  # There are is Jekyll-style formatting
  expect_true(sum(grepl("~~~", txt, fixed = TRUE)) > 0)

  # With the default environment -----------------------------------------------
  p <- provision_jekyll("produces-plot.Rmd")
  expect_output(tmp <- knit_jekyll(p, env = parent.frame()), 'engine: chr "callout"', fixed = TRUE)

  txt <- readLines(tmp)
  # The output directories are the same
  dirs <- grep("OUT DIR:", txt, value = TRUE)
  expect_length(dirs, 2)
  expect_identical(dirs[[1]], dirs[[2]])
  expect_identical(p, gsub("OUT DIR: ?", "", dirs[[1]]))

  # There are is Jekyll-style formatting
  expect_true(sum(grepl("~~~", txt, fixed = TRUE)) > 0)
})


test_that("plotting works with RMarkdown", {
  eng <- rmarkdown::md_document(variant = "markdown_mmd")
  # With new environment -------------------------------------------------------
  p <- provision_jekyll("produces-plot.Rmd")
  expect_output(tmp <- knit_jekyll(p, eng = eng), 'engine: chr "callout"', fixed = TRUE)

  txt <- readLines(tmp)
  # The output directories are the same
  dirs <- grep("OUT DIR:", txt, value = TRUE)
  expect_length(dirs, 2)
  expect_identical(dirs[[1]], dirs[[2]])
  expect_identical(p, gsub(" *OUT DIR: ?", "", dirs[[1]]))

  # There are is Jekyll-style formatting
  expect_true(sum(grepl("{: .output}", txt, fixed = TRUE)) > 0)

  # With parent environment ----------------------------------------------------
  p <- provision_jekyll("produces-plot.Rmd")
  expect_output(tmp <- knit_jekyll(p, env = parent.frame(), eng = eng), 'engine: chr "callout"', fixed = TRUE)

  txt <- readLines(tmp)
  # The output directories are the same
  dirs <- grep("OUT DIR:", txt, value = TRUE)
  expect_length(dirs, 2)
  expect_identical(dirs[[1]], dirs[[2]])
  expect_identical(p, gsub(" *OUT DIR: ?", "", dirs[[1]]))

  # There are is Jekyll-style formatting
  expect_true(sum(grepl("{: .output}", txt, fixed = TRUE)) > 0)
})

# Reset knitr environment
KRESET()
