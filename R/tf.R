
try_GET <- function(x, ...) {
  tryCatch(
    GET(url = x, timeout(10), ...),
    error = function(err) conditionMessage(err),
    warning = function(warn) conditionMessage(warn)
  )
}
is_response <- function(x) {
  class(x) == "response"
}

#' @importFrom httr GET write_disk timeout
#' @importFrom rvest html_nodes html_attrs
#' @importFrom xml2 read_html
ntwd_tf <- function(filenum = NULL, access_info = FALSE) {

  if (!curl::has_internet()) {
    message("No internet connection.")
    return(invisible(NULL))
  }
  remote <- "https://www.nationwide.co.uk/about/house-price-index/download-data"
  resp <- try_GET(remote)
  if (!is_response(resp)) {
    message(resp)
    return(invisible(NULL))
  }
  if (httr::http_error(resp)) { # network is down = message (not an error anymore)
    httr::message_for_status(resp)
    return(invisible(NULL))
  }
  urls <-
    xml2::read_html(resp) %>%
    rvest::html_nodes(".concertina") %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href") %>%
    grep(".xls", ., value = TRUE) %>%
    paste0("https://www.nationwide.co.uk", .)

  if (is.null(filenum)) { #&& is.null(regexp)
    return(urls)
  } else{
    url <- magrittr::extract(urls, filenum)
  }
  # if (!is.null(regexp)) {
  #   url <- grep(regexp, urls, value = TRUE)
  #   return(url)
  #   if (url == character(0)) stop("no pattern found")
  # }
  if (length(url) > 1) {
    stop("trying to access multiple files", call. = FALSE)
  }
  if (interactive() && access_info) {
    message("Accessing ", url)
  }
  tf <- tempfile(fileext = ".xls")
  resp_file <- try_GET(url, write_disk(tf))
  if (!is_response(resp_file)) {
    message(resp_file)
    return(invisible(NULL))
  }
  structure(tf, source = url, class = "access_url")
}

enclose <- function(x) {
  paste0("[", x, "]")
}

print.access_url <- function(x) {
  cat(enclose("Local file"), "\n\t", x, "\n")
  cat(enclose("Remote file:"), "\n\t", attr(x, "source"))
}
