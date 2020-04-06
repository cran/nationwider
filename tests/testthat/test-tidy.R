context("tidy")

test_that("tidy objects", {
  skip_if_offline()
  skip_if_http_error()

  expect_tidy(ntwd_get("monthly"))
  expect_tidy(ntwd_get("quarterly"))
  expect_tidy(ntwd_get("since_1952"))
  expect_tidy(ntwd_get("inflation_adjusted"))
  expect_tidy(ntwd_get("regional"))
  expect_tidy(ntwd_get("seasonal_regional"))
  expect_tidy(ntwd_get("new_prop"))
  expect_tidy(ntwd_get("mod_prop"))
  expect_tidy(ntwd_get("old_prop"))
  # ntwd_get("not_new_prop") # except this one which has long format
  expect_tidy(ntwd_get("first"))
  expect_tidy(ntwd_get("fowner"))
  expect_tidy(ntwd_get("terraced"))
  expect_tidy(ntwd_get("flats"))
  expect_tidy(ntwd_get("detached"))
  expect_tidy(ntwd_get("aftb_ind"))
  expect_tidy(ntwd_get("aftb_hper"))
})



