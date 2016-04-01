## These are tests of the schema.  We'll use the jsonvalidate package
## to run this, but it could be run happily from node if I spoke js :)
library(testthat)
v_palette <- jsonvalidate::json_validator("../schemas/palette.json")
v_group <- jsonvalidate::json_validator("../schemas/group.json")

read_lines <- function(x) paste(readLines(x), collapse="\n")
to_json <- function(x, exclude=NULL, include=NULL) {
  unbox <- c(setdiff(c("name", "github_user", "description", "date", "type"),
                     exclude), include)
  i <- names(x) %in% unbox
  x[i] <- lapply(x[i], jsonlite::unbox)
  jsonlite::toJSON(x)
}

palette_files <- list.files("../palettes")
purrr::walk(palette_files, function(palette_file) {
  message(palette_file)
  expect_silent(v_palette(file.path("../palettes", palette_file), error = TRUE))
})

group_files <- list.files("../groups")
purrr::walk(group_files, function(group_file) {
  message(group_file)
  expect_silent(v_group(file.path("../groups", group_file), error = TRUE))
})
