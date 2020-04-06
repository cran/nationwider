
has_date <- function(x) {
  first <- x[, 1, drop = TRUE]
  lubridate::is.Date(first) && names(x)[1] == "Date"
}

has_proper_names <- function(x) {
  all(names(x)[-1] %in% c("region", "type", "house_type", "value"))
}

is_tidy <- function(x) {
  has_date(x) && has_proper_names(x)
}

expect_tidy <- function(x) {
  expect(is_tidy(x), "object is not tidy")
}

skip_if_http_error <- function() {
  remote_file <- "https://www.nationwide.co.uk/about/house-price-index/download-data"
  skip_if(httr::http_error(remote_file))
}

# catch_message <- function(url) {
#   msg <- tryCatch(
#     url,
#     message = function(m) m
#   )
#   conditionMessage(msg)
# }
