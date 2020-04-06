context("fail-internals")

test_that("ntwd_tf", {
  skip_if_offline()
  skip_if_http_error()

  expect_identical(
    attr(ntwd_tf(1), "source"),
    "https://www.nationwide.co.uk/-/media/MainSite/documents/about/house-price-index/downloads/monthly.xls"
  )
  # expect_identical(
  #   catch_message(ntwd_tf(1, access_info = TRUE)),
  #   "Accessing https://www.nationwide.co.uk/-/media/MainSite/documents/about/house-price-index/downloads/monthly.xls\n"
  # )
  # expect_message(
  #   ntwd_tf(40),
  #   "Could not resolve host: NA"
  #   )
})
