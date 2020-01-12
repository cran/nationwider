#' Quickly browse to Nationwide's webpage
#'
#' This function take you to the Nationwide's House Price Index webpage and
#' return the URL invisibly.
#'
#' @export
#' @examples
#' ntwd_browse()
ntwd_browse <- function() {
  view_url("https://www.nationwide.co.uk/about/house-price-index/headlines")
}

view_url <- function(url, open = interactive()) {
  if (open) {
    utils::browseURL(url)
  }
  invisible(url)
}

