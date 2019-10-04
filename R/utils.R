#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

clean_date <- function(x) {
  dplyr::mutate(x, Date = as.Date(...1), ...1 = NULL) %>%
    dplyr::select(Date, dplyr::everything()) %>%
    mutate_if(Negate(lubridate::is.Date), as.double)
}

clean_date_yq <- function(x) {
  dplyr::mutate(x, Date = lubridate::yq(...1), ...1 = NULL) %>%
    dplyr::select(Date, dplyr::everything()) %>%
    mutate_if(Negate(lubridate::is.Date), as.double)
}

qy <- function(x) {
  split <- unlist(strsplit(x, " "))
  odd <- seq(1, length(split), 2)
  unsplit <- paste(split[-odd], split[odd])
  lubridate::yq(unsplit)
}

clean_date_qy <- function(x) {
  dplyr::mutate(x, Date = qy(...1), ...1 = NULL) %>%
    dplyr::select(Date, dplyr::everything()) %>%
    mutate_if(Negate(lubridate::is.Date), as.double)
}

trunc_na <- function(x) {
  na_idx <- rowSums(is.na(x))
  idx <- which(na_idx == ncol(x))[1]
  slice(x, -idx:-n())
}

char_na <- function(x) {
  paste("", x) %>% gsub("NA", "", .)
}

char_na_colon <- function(x) {
  paste("", x) %>% gsub("NA", "", .)
}

set_metadata <- function(x, ...) {
  attrs <- list(...)
  attributes(x) <- c(attributes(x), attrs)
  x
}

`%||%` <- function(x, y) {
  if (is.null(x))
    y
  else x
}


globalVariables(c(".", "Date", "type", "region", "key","type","value", "n",
                  "...1"))
