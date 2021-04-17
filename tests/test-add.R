options(box.path = here::here())
box::use(R / add[add])

test_that("adds 3", {
  expect_equal(add(3), 6)
})
