box::use(testthat[...])

{
  function() {
    reporter <- SummaryReporter

    the_dir <- box::file()
    patterns <-  "test_|test-"

    fp <- list.files(
      path = the_dir,
      pattern = patterns,
      recursive = TRUE,
      full.names = TRUE
    )
    test_files <- sort(fp)

    test_functions <- purrr::map(
      test_files,
      ~purrr::partial(
        test_file,
        path = .,
        reporter = reporter,
        stop_on_failure = TRUE
      )
    )
    safe <- purrr::map(test_functions, purrr::safely)
    results <- purrr::map(safe, ~.())
    errors <- purrr::map(results, "error")
    has_passed <- purrr::map(errors, is.null)
    all_passed <- purrr::reduce(has_passed, `&`)
    if (all_passed) {
      quit(status = 0)
    }
    quit(status = 1)
  }
}()
