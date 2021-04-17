test_that("the test passes", {
  expect_equal(3, 3)
})

test_that("the test does not pass", {
  expect_equal(3, 4)
})