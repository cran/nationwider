
# TODO problems with Dates ... there are duplicates (no spread available)

# silent excel ------------------------------------------------------------

#' @importFrom readxl read_excel
read_excel_silently <- function(...) {
  suppressMessages({
    readxl::read_excel(..., na = c("", "N/A"))
  })
}

read_excel_silently_ <- function(...) {
  suppressMessages({
    readxl::read_excel(...)
  })
}


set_source <- function(tbl, url) {
  attr(tbl, "source") <- attr(url, "source")
  tbl
}

# get ---------------------------------------------------------------------


#' @importFrom zoo na.locf
#' @importFrom dplyr mutate transmute_all mutate_if slice rename_all full_join n
#' @importFrom dplyr select pull
#' @importFrom tidyr gather separate
#' @importFrom magrittr set_names
#' @importFrom lubridate is.Date yq
ntwd_get_generic <- function(id, .access_info) {
  num <- grep(gsub("_", "-", id), ntwd_tf(NULL))
  xfile <- ntwd_tf(num[1], access_info = .access_info)
  on.exit(file.remove(xfile))
  x <- read_excel_silently(xfile, skip = 0, n_max = 3, col_names = FALSE)
  x[1,] <- zoo::na.locf(unlist(x[1,])) %>% char_na() %>% as.list()
  x[2,] <- char_na(x[2,]) %>% as.list()
  x[3,] <- gsub("\u00A3", " :Price", x[3,]) %>%
    gsub("INDEX", " : Index", .) %>% char_na() %>% as.list()
  nms <- transmute_all(x, paste, collapse = " ") %>%
    slice(2) %>%  unlist(use.names = FALSE) %>% gsub("^: ", "", .) %>%
    trimws() %>% gsub("\\s+"," ",.)
  read_excel_silently(xfile, skip = 3, col_names = FALSE) %>%
    clean_date_qy() %>%
    set_names(c("Date", nms[-1])) %>%
    mutate_if(Negate(lubridate::is.Date), as.double) %>%
    gather(type, value, -Date) %>%
    separate(type, into = c("region", "type"),  sep = "[^[:alnum:]]:") %>%
    # mutate(type = recode(type, "\u00A3" = "Price", "INDEX" = "Index")) %>%
    mutate(region = stringr::str_to_title(region)) %>%
    set_source(xfile)
}

ntwd_get_monthly <- function(.access_info) {
  xfile <- ntwd_tf(1, access_info = .access_info)
  xfile %||% return(invisible(NULL))
  on.exit(file.remove(xfile))
  xfile %>%
    read_excel_silently(.) %>%
    clean_date() %>%
    gather(type, value, -Date) %>%
    set_source(xfile)
}

ntwd_get_quarterly <- function(.access_info) {
  xfile <- ntwd_tf(2, access_info = .access_info)
  xfile %||% return(invisible(NULL))
  on.exit(file.remove(xfile))
  xfile %>%
    read_excel_silently(.) %>%
    clean_date_qy() %>%
    dplyr::rename_all(~ gsub(":", "", .)) %>%
    gather(type, value, -Date) %>%
    set_source(xfile)
}

ntwd_get_since_1952 <- function(.access_info) {
  xfile <- ntwd_tf(3, access_info = .access_info)
  xfile %||% return(invisible(NULL))
  on.exit(file.remove(xfile))
  x <- read_excel_silently(xfile, skip = 3, n_max = 3, col_names = FALSE)
  x[1,] <- c("", zoo::na.locf(unlist(x[1,]))) %>% as.list()
  x[2,] <- paste0(": ", x[2,]) %>% as.list()
  x <- x[-3,]
  # x[3,] <- paste0(" (", x[3,], ")")

  nms <- transmute_all(x, paste, collapse = "") %>%
    slice(2) %>%  unlist(use.names = FALSE) %>%
    gsub("^: ", "", .) %>%
    gsub("(NA)", "", ., fixed = TRUE) %>%
    gsub("(UK)", "", ., fixed = TRUE) %>%
    trimws()
  index_year <- nms[1]
  nms[1] <- "Date"
  read_excel_silently_(
    xfile, skip = 6, col_names = FALSE,
    na = c("", "Series discontinued")) %>%
    clean_date_qy() %>%
    set_names(nms) %>%
    mutate_if(Negate(lubridate::is.Date), as.double) %>%
    gather(type, value, -Date) %>%
    tidyr::separate(type, into = c("house_type", "type"), sep = "[^[:alnum:]]:") %>%
    mutate(type = trimws(type)) %>%
    set_metadata(metadata = index_year) %>%
    set_source(xfile)
}

ntwd_get_inflation_adjusted <- function(.access_info) {
  xfile <- ntwd_tf(4, access_info = .access_info)
  xfile %||% return(invisible(NULL))
  on.exit(file.remove(xfile))
  skip_after <- read_excel_silently(xfile) %>% trunc_na() %>% nrow()
  read_excel_silently(xfile, n_max = skip_after) %>%
    clean_date_yq() %>%
    rename_all(list(~ gsub("\\s*\\([^\\)]+\\)","",.))) %>%
    gather(type, value, -Date) %>%
    set_source(xfile)
}

#' @importFrom dplyr recode
ntwd_get_seasonal_regional <- function(.access_info) {
  xfile <- ntwd_tf(6, access_info = .access_info)
  xfile %||% return(invisible(NULL))
  on.exit(file.remove(xfile))
  x <- read_excel_silently(xfile, skip = 0, n_max = 3, col_names = FALSE)
  x <- x[-2,]
  x[1,] <- c(NA, zoo::na.locf(unlist(x[1,]))) %>% char_na() %>% as.list()
  nms <- transmute_all(x, paste, collapse = " ") %>%
    slice(2) %>%
    unlist(use.names = FALSE) %>%
    gsub("^: ", "", .) %>%
    gsub("Seasonally Adjusted Index", "Index :", .) %>%
    gsub("Quarter on Quarter Change - Seasonally Adjusted", "QoQ Change :", .) %>%
    trimws()
  # index_year <- nms[1]
  nms[1] <- "Date"

  read_excel_silently(xfile, skip = 3, col_names = FALSE) %>%
    select(-ncol(.)) %>%
    clean_date_qy() %>%
    set_names(nms) %>%
    gather(type, value, -Date) %>%
    tidyr::separate(type, into = c("type", "region"), sep = "[^[:alnum:]]:") %>%
    mutate(region = trimws(region)) %>%
    mutate(region = stringr::str_to_title(region),
           region = recode(region, "Uk" = "UK")) %>%
    select(Date, region, type, value) %>%
    set_source(xfile)
}

ntwd_get_not_new_prop <- function(.access_info) {
  xfile <- ntwd_tf(10, access_info = .access_info)
  xfile %||% return(invisible(NULL))
  on.exit(file.remove(xfile))
  nms <- c("Date", "UK Not new") #(\u00A3)
  read_excel_silently(
    xfile, skip = 3, col_types = c("text", "text", "skip"),
    col_names = FALSE) %>%
    clean_date_qy() %>%
    set_names(nms) %>%
    mutate_if(Negate(lubridate::is.Date), as.double) %>%
    tidyr::drop_na() %>%
    set_source(xfile)
}

ntwd_get_aftb_ind <- function(.access_info) {
  xfile <- ntwd_tf(17, access_info = .access_info)
  xfile %||% return(invisible(NULL))
  on.exit(file.remove(xfile))
  percent <- read_excel_silently(xfile, skip = 3) %>%
    clean_date_yq() %>%
    mutate(type = "percentage") %>%
    gather(region, value, -Date, -type)
  index <- read_excel_silently(xfile, skip = 3, sheet = 2) %>%
    clean_date_yq() %>%
    mutate(type = "index") %>%
    gather(region, value, -Date, -type)
  full_join(percent, index, by = c("Date", "type", "region", "value")) %>%
    select(Date, region, type, value) %>%
    set_source(xfile)
}

ntwd_get_aftb_hper <- function(.access_info) {
  xfile <- ntwd_tf(18, access_info = .access_info)
  xfile %||% return(invisible(NULL))
  on.exit(file.remove(xfile))
  xfile %>%
    read_excel_silently(.) %>%
    clean_date_yq() %>%
    gather(region, value, -Date, factor_key = TRUE) %>%
    set_source(xfile)
}
