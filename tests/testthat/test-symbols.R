context("functionality")

ids <- c(
  "monthly", "quarterly", "since_1952", "inflation_adjusted",
  "regional", "seasonal_regional",
  "new_prop", "mod_prop", "old_prop", "not_new_prop",
  "first", "fowner",
  "terraced", "flats", "semi_det","detached",
  "aftb_ind", "aftb_hper"
)

test_that("id works", {
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

