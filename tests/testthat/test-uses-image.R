# Tags in this particular file
these_tags <- c("challenge", "solution")

test_that("engines work with absolute dirs", {
  tct <- example_file("uses-image.Rmd")#, "images")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, envir = new.env(), encoding = "UTF-8")
    },
    chunk_output("challenge")
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 3)
  # Our markdown image is preserved
  expect_match(txt, "!\\[megaman\\sis\\sawesome\\]\\(images/mm.png")
  # chunks are echoed
  expect_match(txt, "knitr::include_graphics", fixed = TRUE)
  # The image titles are named after the chunk
  expect_match(txt, "plot of chunk unnamed-chunk-1", fixed = TRUE)
  expect_match(txt, "plot of chunk dovetail-chunk-1", fixed = TRUE)
  # The widths are respected
  expect_match(txt, "width=['\"]296px['\"] height=['\"]250px['\"]")
  expect_match(txt, "width=['\"]740px['\"] height=['\"]625px['\"]")
  # The imported style is respected
  expect_match(txt, "display: block; margin: auto;")
})

test_that("engines work with absolute dirs and parent env", {
  tct <- example_file("uses-image.Rmd")#, "images")
  tmp <- make_tmp()

  expect_output(
    {
      knitr::knit(tct, output = tmp, encoding = "UTF-8")
    },
    chunk_output("challenge")
  )

  txt <- paste(readLines(tmp), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 3)
  # Our markdown image is preserved
  expect_match(txt, "!\\[megaman\\sis\\sawesome\\]\\(images/mm.png")
  # chunks are echoed
  expect_match(txt, "knitr::include_graphics", fixed = TRUE)
  # The image titles are named after the chunk
  expect_match(txt, "plot of chunk unnamed-chunk-1", fixed = TRUE)
  expect_match(txt, "plot of chunk dovetail-chunk-1", fixed = TRUE)
  # The widths are respected
  expect_match(txt, "width=['\"]296px['\"] height=['\"]250px['\"]")
  expect_match(txt, "width=['\"]740px['\"] height=['\"]625px['\"]")
  # The imported style is respected
  expect_match(txt, "display: block; margin: auto;")
})

KRESET()

test_that("engines work with relative dirs", {
  tcf <- provision_jekyll("uses-image.Rmd", "images")
  expect_output(tct <- knit_jekyll(tcf), chunk_output("challenge"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 3)
  # Our markdown image is preserved
  expect_match(txt, "!\\[megaman\\sis\\sawesome\\]\\(images/mm.png")
  # chunks are echoed
  expect_match(txt, "knitr::include_graphics", fixed = TRUE)
  # The image titles are named after the chunk
  expect_match(txt, "plot of chunk unnamed-chunk-1", fixed = TRUE)
  expect_match(txt, "plot of chunk dovetail-chunk-1", fixed = TRUE)
  # The widths are respected
  expect_match(txt, "width=['\"]296px['\"] height=['\"]250px['\"]")
  expect_match(txt, "width=['\"]740px['\"] height=['\"]625px['\"]")
  # The imported style is respected
  expect_match(txt, "display: block; margin: auto;")
})

test_that("engines work with relative dirs and parent env", {
  tcf <- provision_jekyll("uses-image.Rmd", "images")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame()), chunk_output("challenge"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 3)
  # Our markdown image is preserved
  expect_match(txt, "!\\[megaman\\sis\\sawesome\\]\\(images/mm.png")
  # chunks are echoed
  expect_match(txt, "knitr::include_graphics", fixed = TRUE)
  # The image titles are named after the chunk
  expect_match(txt, "plot of chunk unnamed-chunk-1", fixed = TRUE)
  expect_match(txt, "plot of chunk dovetail-chunk-1", fixed = TRUE)
  # The widths are respected
  expect_match(txt, "width=['\"]296px['\"] height=['\"]250px['\"]")
  expect_match(txt, "width=['\"]740px['\"] height=['\"]625px['\"]")
  # The imported style is respected
  expect_match(txt, "display: block; margin: auto;")
})

KRESET()

test_that("engines work with rmarkdown and relative dirs", {
  eng <- rmarkdown::md_document(variant = "commonmark")
  tcf <- provision_jekyll("uses-image.Rmd", "images")
  expect_output(tct <- knit_jekyll(tcf, eng = eng), chunk_output("challenge"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 3)
  # Our markdown image is preserved
  expect_match(txt, "!\\[megaman\\sis\\sawesome\\]\\(images/mm.png")
  # chunks are echoed
  expect_match(txt, "knitr::include_graphics", fixed = TRUE)
  # NOTE: in RMarkdown, images are not titled with their chunk title
  # The widths are respected
  expect_match(txt, "width=['\"]296px['\"] height=['\"]250px['\"]")
  expect_match(txt, "width=['\"]740px['\"] height=['\"]625px['\"]")
  # The imported style is respected
  expect_match(txt, "display: block; margin: auto;")
})

test_that("engines work with rmarkdown relative dirs and parent env", {
  eng <- rmarkdown::md_document(variant = "commonmark")
  tcf <- provision_jekyll("uses-image.Rmd", "images")
  expect_output(tct <- knit_jekyll(tcf, env = parent.frame(), eng = eng), chunk_output("challenge"))

  expect_true(file.exists(tct))
  txt <- paste(readLines(tct), collapse = "\n")
  expect_tags_match(txt, these_tags, n = 3)
  # Our markdown image is preserved
  expect_match(txt, "!\\[megaman\\sis\\sawesome\\]\\(images/mm.png")
  # chunks are echoed
  expect_match(txt, "knitr::include_graphics", fixed = TRUE)
  # The image titles are named after the chunk
  # NOTE: in RMarkdown, images are not titled with their chunk title
  # The widths are respected
  expect_match(txt, "width=['\"]296px['\"] height=['\"]250px['\"]")
  expect_match(txt, "width=['\"]740px['\"] height=['\"]625px['\"]")
  # The imported style is respected
  expect_match(txt, "display: block; margin: auto;")
})

KRESET()
