context("misc")

test_that("browse url", {
  skip_if(interactive()) # to avoid opening tabs
  expect_identical(
    ntwd_browse(),
    "https://www.nationwide.co.uk/about/house-price-index/headlines"
  )
})


test_that("access meta", {
  skip_if_offline()
  skip_if_http_error()

  tbl <- ntwd_get("since_1952")
  expect_identical(ntwd_meta(tbl), "1952 Q4 = 100")
  tbl2 <- ntwd_get("seasonal_regional")
  expect_message(ntwd_meta(tbl2), "the object does not contain metadata")
})
