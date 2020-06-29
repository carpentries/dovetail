test_that("knitr options are changed", {
  ok <- knitr::opts_knit$get()
  oc <- knitr::opts_chunk$get()
  oh <- knitr::knit_hooks$get()
  wd <- getwd()
  withr::defer({
    setwd(wd)
    knitr::opts_knit$set(ok)
    knitr::opts_chunk$set(oc)
    knitr::knit_hooks$set(oh)
  })
  setwd(system.file("extdata", package = "dovetail"))
  source(dvt_opts())
  # The default error is just to print
  derr <- c("this is a dramatic...", "", "error")
  expect_identical(oh$error(derr), derr)
  jekerr <- knitr::knit_hooks$get("error")
  # The dovetail error is formulated for jekyll with a kramdown tag
  expect_match(jekerr(derr), "~~~\n{: .error}", fixed = TRUE)

  # The output directory has been updated to the top of the project. This is
  # To account for the fact that Jekyll sites store their assets in the top
  # level directory
  expect_identical(knitr::opts_knit$get("base.dir"), system.file(package = "dovetail"))
  # The figure paths have been updated
  expect_identical(oc$fig.path, "figure/")
  expect_identical(knitr::opts_chunk$get("fig.path"), "fig/rmd-")
  # Use a loaded function to update this:
  knitr_fig_path(prefix = "01-")
  expect_identical(knitr::opts_chunk$get("fig.path"), "fig/rmd-01-")
})
