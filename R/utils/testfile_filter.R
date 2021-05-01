box::use(purrr[...], stringr[str_starts, str_ends, fixed])


is_test_file <- function(file_name) {
  (
    str_starts(file_name, pattern = fixed('test_')) ||
      str_starts(file_name, pattern = fixed('test-'))   
  ) & 
    str_ends(file_name, pattern = fixed('.R')) ||
    str_starts(file_name, pattern = fixed('.r'))
}


test_files <- fs::dir_ls("tests", recurse = TRUE, type ='file') %>% 
  set_names() %>% 
  map(fs::path_file) %>% 
  keep(is_test_file) %>% 
  names()

build_test_function <- function(path) { 
  partial(
    testthat::test_file,
    path = path,
    reporter = SummaryReporter,
    stop_on_failure = TRUE
  )
}

test_functions <- map(test_files, build_test_function) %>% map(safely)



test_functions <- purrr::map(
  test_files,
  ~purrr::partial(
    test_file,
    path = .,
    reporter = SummaryReporter,
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
