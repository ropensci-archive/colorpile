## These are tests of the schema.  We'll use the jsonvalidate package
## to run this, but it could be run happily from node if I spoke js :)
library(testthat)
v <- jsonvalidate::json_validator("../schema.json")

read_lines <- function(x) paste(readLines(x), collapse="\n")
to_json <- function(x, exclude=NULL, include=NULL) {
  unbox <- c(setdiff(c("name", "github_user", "description", "date", "type"),
                     exclude), include)
  i <- names(x) %in% unbox
  x[i] <- lapply(x[i], jsonlite::unbox)
  jsonlite::toJSON(x)
}

expect_true(v("minimal.json"))
palette_files <- list.files("../palettes")
purrr::walk(palette_files, function(palette_file) {
  expect_true(v(file.path("../palettes", palette_file), verbose = TRUE))
})
