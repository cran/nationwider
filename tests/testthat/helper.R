
has_date <- function(x) {
  first <- x[, 1, drop = TRUE]
  lubridate::is.Date(first) && names(x)[1] == "Date"
}

has_proper_names <- function(x) {
  all(names(x)[-1] %in% c("region", "type", "key", "value"))
}

is_tidy <- function(x) {
  has_date(x) && has_proper_names(x)
}

expect_tidy <- function(x) {
  expect(is_tidy(x), "object is not tidy")
}
