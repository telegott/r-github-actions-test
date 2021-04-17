expect_lint_free <- function(directory) {
  lints <- lintr::lint_dir(here::here(directory))
  has_lints <- length(lints) > 0

  lint_output <- NULL
  if (has_lints) {
    lint_output <- paste(collapse = "\n", capture.output(print(lints)))
  }
  testthat::expect(!has_lints, paste(sep = "\n", "lintr frailed", lint_output))
}

test_that("R/ is lint free", {
  expect_lint_free("R")
})


test_that("tests/ is lint free", {
  expect_lint_free("tests")
})
