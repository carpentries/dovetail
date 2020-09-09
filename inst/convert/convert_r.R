if (!requireNamespace("remotes")) {
  install.packages("remotes")
}

remotes::install_github("carpentries/pegboard")
library("pegboard")
library("purrr")

l <- Lesson$new(".", rmd = TRUE)

message("1/7: Using the dovetail package")
purrr::walk(l$episodes, ~.x$use_dovetail())
message("2/7: Using the sandpaper package")
purrr::walk(l$episodes, ~.x$use_sandpaper(rmd = TRUE))
message("3/7: Converting block quotes to dovetail chunks")
purrr::walk(l$episodes, ~.x$unblock())
message("4/7: Moving questions from yaml to body")
purrr::walk(l$episodes, ~.x$move_questions())
message("5/7: Moving objectives from yaml to body")
purrr::walk(l$episodes, ~.x$move_objectives())
message("6/7: Moving keypoints from yaml to body")
purrr::walk(l$episodes, ~.x$move_keypoints())
message("7/7: Writing files to disk")
purrr::walk(l$episodes, ~.x$write(path = dirname(.x$path), format = "Rmd"))
message("Done.")
message("\nTo keep these changes, add and commit them to git.\nTo discard these changes, use\n\n  git checkout -- _episodes_rmd/")
