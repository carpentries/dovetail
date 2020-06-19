test_that("parse_block works with simple cases", {
  expect_identical(parse_block("what"), "what")
  expect_error(parse_block(letters), "there is more than one text block here")

  txt <- "#' this is a test\n#' ```{r}1 + 1\n#' ```"
  expect_identical(parse_block(txt), gsub("#' ", "", txt, fixed = TRUE))

  txt <- "#' @solution this is a test\n#' ```{r}1 + 1\n#' ```"
  expected <- "<div class='challenge' markdown='1'>\n\n\n<div class='solution' markdown='1'>\n\n## this is a test\n ```{r}1 + 1\n```\n\n</div>\n\n</div>"
  expect_identical(parse_block(txt), expected)
  expect_identical(parse_block(txt, type = "callout"), gsub("challenge", "callout", expected))
  expect_identical(parse_block(txt, opts = "smile=':)'"), gsub("markdown='1'", "smile=':)'", expected, fixed = TRUE))

  txt <- "\n#' Hello Challenge\n#' Say hello\n#'\n#' THING olleH Solution\n#'\n#' ```{r}\n#' h$ello\n#' h$ere\n#' ```\n"

  for (i in OUR_TAGS[OUR_TAGS != "end"]) {
    tg <- parse_block(gsub("THING", paste0("@", i), txt))
    expect_match(tg, "<div class='challenge' markdown='1'>\n\n", fixed = TRUE)
    expect_match(tg, paste0("\n<div class='", i, "' markdown='1'>\n\n"), fixed = TRUE)
    expect_match(tg, "\n## olleH Solution", fixed = TRUE)
    expect_match(tg, "\n\n</div>\n\n</div>", fixed = TRUE)
  }

})

test_that("parse_block works with the examples we have", {

  # code blocks with numbers that echo
  f <- system.file("extdata", "example-number-echo.R", package = "dovetail")
  txt <- paste(readLines(f, encoding = "UTF-8"), collapse = "\n")
  ptxt <- parse_block(txt)

  expect_match(ptxt, "<div class='challenge' markdown='1'>\n\n", fixed = TRUE)
  expect_match(ptxt, "\n<div class='solution' markdown='1'>\n\n", fixed = TRUE)
  expect_match(ptxt, "\n## Exponentiation", fixed = TRUE)
  expect_match(ptxt, "\n## Solution", fixed = TRUE)
  expect_match(ptxt, "\n\n</div>\n\n</div>", fixed = TRUE)

  # multiple solution blocks
  f <- system.file("extdata", "example-multi-solution.txt", package = "dovetail")
  txt <- paste(readLines(f, encoding = "UTF-8"), collapse = "\n")
  ptxt <- parse_block(txt)

  expect_match(ptxt, "<div class='challenge' markdown='1'>\n\n", fixed = TRUE)
  expect_match(ptxt, "\n<div class='solution' markdown='1'>\n\n", fixed = TRUE)
  expect_length(strsplit(ptxt, "class='solution'")[[1]], 4L)
  expect_match(ptxt, "\n##  A Simple Command-Line Program", fixed = TRUE)
  expect_match(ptxt, "\n## Solution", fixed = TRUE)
  expect_match(ptxt, "\n\n</div>\n\n</div>", fixed = TRUE)
  expect_match(ptxt, "\n\n\n</div>\n\n\n", fixed = TRUE)
})
