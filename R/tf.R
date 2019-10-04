#' @importFrom httr GET write_disk
#' @importFrom rvest html_nodes html_attrs
#' @importFrom xml2 read_html
ntwd_tf <- function(file = NULL) {

  urls <-
    xml2::read_html(
      "https://www.nationwide.co.uk/about/house-price-index/download-data") %>%
    rvest::html_nodes(".concertina") %>%
    rvest::html_nodes("a") %>%
    rvest::html_attr("href") %>%
    grep(".xls", ., value = TRUE) %>%
    paste0("https://www.nationwide.co.uk", .)
  if (is.null(file)) {
    return(urls)
  }
  url <- magrittr::extract(urls, file)
  tf <- tempfile(fileext = ".xls")
  httr::GET(url, write_disk(tf))

  structure(tf, source = url)
}
