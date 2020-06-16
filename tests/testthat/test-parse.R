test_that("parse_block works with simple cases", {
  expect_identical(parse_block("what"), "what")
  expect_error(parse_block(letters), "there is more than one text block here")

  txt <- "#' this is a test\n#' ```{r}1 + 1\n#' ```"
  expect_identical(parse_block(txt), gsub("#' ", "", txt, fixed = TRUE))

  txt <- "#' @solution this is a test\n#' ```{r}1 + 1\n#' ```"
  expected <- "<div class='challenge'>\n\n\n<div class='solution'>\n\n## this is a test\n ```{r}1 + 1\n```\n\n</div>\n\n</div>"
  expect_identical(parse_block(txt), expected)
  expect_identical(parse_block(txt, type = "callout"), gsub("challenge", "callout", expected))

  txt <- parse_block("
#' Hello Challenge
#' Say hello
#'
#' @solution olleH Solution
#'
#' ```{r}
#' h$ello
#' h$ere
#' ```
")

  expect_match(txt, "<div class='challenge'>\n\n", fixed = TRUE)
  expect_match(txt, "\n<div class='solution'>\n\n", fixed = TRUE)
  expect_match(txt, "\n## olleH Solution", fixed = TRUE)
  expect_match(txt, "\n\n</div>\n\n</div>", fixed = TRUE)
})

test_that("parse_block works with the examples we have", {

  # code blocks with numbers that echo
  f <- system.file("extdata", "example-number-echo.R", package = "roxyblox")
  txt <- paste(readLines(f, encoding = "UTF-8"), collapse = "\n")
  ptxt <- parse_block(txt)

  expect_match(ptxt, "<div class='challenge'>\n\n", fixed = TRUE)
  expect_match(ptxt, "\n<div class='solution'>\n\n", fixed = TRUE)
  expect_match(ptxt, "\n## Exponentiation", fixed = TRUE)
  expect_match(ptxt, "\n## Solution", fixed = TRUE)
  expect_match(ptxt, "\n\n</div>\n\n</div>", fixed = TRUE)

  # multiple solution blocks
  f <- system.file("extdata", "example-multi-solution.txt", package = "roxyblox")
  txt <- paste(readLines(f, encoding = "UTF-8"), collapse = "\n")
  ptxt <- parse_block(txt)

  expect_match(ptxt, "<div class='challenge'>\n\n", fixed = TRUE)
  expect_match(ptxt, "\n<div class='solution'>\n\n", fixed = TRUE)
  expect_length(strsplit(ptxt, "class='solution'")[[1]], 4L)
  expect_match(ptxt, "\n##  A Simple Command-Line Program", fixed = TRUE)
  expect_match(ptxt, "\n## Solution", fixed = TRUE)
  expect_match(ptxt, "\n\n</div>\n\n</div>", fixed = TRUE)
  expect_match(ptxt, "\n\n\n</div>\n\n\n", fixed = TRUE)
})
