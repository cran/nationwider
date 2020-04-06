context("get")

test_that("id error messages", {
  expect_error(ntwd_get("wrong_id")) # probably backtickes or ? throws of an error about the msg
  expect_error(ntwd_get()) # same here
  expect_error(
    ntwd_get(c("monthly", "quarterly")),
    "trying to access multiple files"
  )
})

test_that("id works", {
  skip_if_offline()
  skip_if_http_error()

  expect_error(ntwd_get("monthly"), NA)
  expect_error(ntwd_get("quarterly"), NA)
  expect_error(ntwd_get("since_1952"), NA)
  expect_error(ntwd_get("inflation_adjusted"), NA)
  expect_error(ntwd_get("regional"), NA)
  expect_error(ntwd_get("seasonal_regional"), NA)
  expect_error(ntwd_get("new_prop"), NA)
  expect_error(ntwd_get("mod_prop"), NA)
  expect_error(ntwd_get("old_prop"), NA)
  expect_error(ntwd_get("not_new_prop"), NA)
  expect_error(ntwd_get("first"), NA)
  expect_error(ntwd_get("fowner"), NA)
  expect_error(ntwd_get("terraced"), NA)
  expect_error(ntwd_get("flats"), NA)
  expect_error(ntwd_get("semi_det"), NA)
  expect_error(ntwd_get("detached"), NA)
  expect_error(ntwd_get("aftb_ind"), NA)
  expect_error(ntwd_get("aftb_hper"), NA)
})

