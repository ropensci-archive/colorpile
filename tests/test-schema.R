library(testthat)
v <- jsonvalidate::json_validator("../schema.json")

read_lines <- function(x) paste(readLines(x), collapse = "\n")
to_json <- function(x, exclude=NULL, include=NULL) {
  unbox <- c(setdiff(c("name", "github_user", "description", "date", "type"),
                     exclude), include)
  i <- names(x) %in% unbox
  x[i] <- lapply(x[i], jsonlite::unbox)
  jsonlite::toJSON(x)
}

expect_silent(v("minimal.json"))
palette_files <- list.files("../palettes")
purrr::walk(palette_files, function(palette_file) {
  cat(palette_file, "\n")
  expect_silent(v(file.path("../palettes", palette_file), verbose = TRUE, error = TRUE))
})

## Let's start messing with this and check that things do break.  But
## first, generate valid json:
d <- jsonlite::fromJSON(read_lines("minimal.json"))
expect_true(v(to_json(d)))

## authors must be a vector
expect_false(v(to_json(d, NULL, "authors")))
## authors must be at least one item
expect_false(v(to_json(modifyList(d, list(authors = character(0))))))
