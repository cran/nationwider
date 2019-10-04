
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

# get ---------------------------------------------------------------------


#' @importFrom zoo na.locf
#' @importFrom dplyr mutate transmute_all mutate_if slice rename_all full_join n
#' @importFrom dplyr select pull
#' @importFrom tidyr gather separate
#' @importFrom magrittr set_names
#' @importFrom lubridate is.Date yq
ntwd_get_generic <- function(id) {
  num <- grep(gsub("_", "-", id), ntwd_tf(NULL))
  xfile <- ntwd_tf(num[1])
  on.exit(file.remove(xfile))
  x <- read_excel_silently(xfile, skip = 0, n_max = 3, col_names = FALSE)
  x[1,] <- zoo::na.locf(unlist(x[1,])) %>% char_na()
  x[2,] <- char_na(x[2,])
  x[3,] <- gsub("\u00A3", " :Price", x[3,]) %>%
    gsub("INDEX", " : Index", .) %>% char_na()
  nms <- transmute_all(x, paste, collapse = " ") %>%
    slice(2) %>%  unlist(use.names = FALSE) %>% gsub("^: ", "", .) %>%
    trimws() %>% gsub("\\s+"," ",.)
  read_excel_silently(xfile, skip = 3, col_names = FALSE) %>%
    clean_date_qy() %>%
    set_names(c("Date", nms[-1])) %>%
    mutate_if(Negate(lubridate::is.Date), as.double) %>%
    gather(key, value, -Date) %>%
    separate(key, into = c("region", "type"),  sep = "[^[:alnum:]]:") %>%
    # mutate(type = recode(type, "\u00A3" = "Price", "INDEX" = "Index")) %>%
    mutate(region = stringr::str_to_title(region))
}

ntwd_get_monthly <- function() {
  xfile <- ntwd_tf(1)
  on.exit(file.remove(xfile))
  xfile %>%
    read_excel_silently(.) %>%
    clean_date() %>%
    gather(key, value, -Date)
}

ntwd_get_quarterly <- function() {
  xfile <- ntwd_tf(2)
  on.exit(file.remove(xfile))
  xfile %>%
    read_excel_silently(.) %>%
    clean_date_qy() %>%
    dplyr::rename_all(~ gsub(":", "", .)) %>%
    gather(key, value, -Date)
}

ntwd_get_since_1952 <- function() {
  xfile <- ntwd_tf(3)
  on.exit(file.remove(xfile))
  x <- read_excel_silently(xfile, skip = 3, n_max = 3, col_names = FALSE)
  x[1,] <- c("", zoo::na.locf(unlist(x[1,])))
  x[2,] <- paste0(": ", x[2,])
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
    gather(key, value, -Date) %>%
    tidyr::separate(key, into = c("key", "type"), sep = "[^[:alnum:]]:") %>%
    mutate(type = trimws(type)) %>%
    set_metadata(metadata = index_year)
}

ntwd_get_inflation_adjusted <- function() {
  xfile <- ntwd_tf(4)
  on.exit(file.remove(xfile))
  skip_after <- read_excel_silently(xfile) %>% trunc_na() %>% nrow()
  read_excel_silently(xfile, n_max = skip_after) %>%
    clean_date_yq() %>%
    rename_all(list(~ gsub("\\s*\\([^\\)]+\\)","",.))) %>%
    gather(key, value, -Date)
}

ntwd_get_seasonal_regional <- function() {
  xfile <- ntwd_tf(6)
  on.exit(file.remove(xfile))
  x <- read_excel_silently(xfile, skip = 0, n_max = 3, col_names = FALSE)
  x <- x[-2,]
  x[1,] <- c(NA, zoo::na.locf(unlist(x[1,]))) %>% char_na()
  nms <- transmute_all(x, paste, collapse = " ") %>%
    slice(2) %>%  unlist(use.names = FALSE) %>%
    gsub("^: ", "", .) %>%
    gsub("Seasonally Adjusted Index", "Index :", .) %>%
    gsub("Quarter on Quarter Change - Seasonally Adjusted", "QoQ Change :", .) %>%
    trimws()
  index_year <- nms[1]
  nms[1] <- "Date"

  read_excel_silently(xfile, skip = 3, col_names = FALSE) %>%
    clean_date_qy() %>%
    set_names(nms) %>%
    gather(key, value, -Date) %>%
    tidyr::separate(key, into = c("type", "region"), sep = "[^[:alnum:]]:") %>%
    mutate(region = trimws(region)) %>%
    mutate(region = stringr::str_to_title(region)) %>%
    select(Date, region, type, value)
}

ntwd_get_not_new_prop <- function() {
  xfile <- ntwd_tf(10)
  on.exit(file.remove(xfile))
  nms <- c("Date", "UK Not new") #(\u00A3)
  read_excel_silently(
    xfile, skip = 3, col_types = c("text", "text", "skip"),
    col_names = FALSE) %>%
    clean_date_qy() %>%
    set_names(nms) %>%
    mutate_if(Negate(lubridate::is.Date), as.double) %>%
    tidyr::drop_na()
}

ntwd_get_aftb_ind <- function() {
  xfile <- ntwd_tf(17)
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
    select(Date, region, type, value)
}

ntwd_get_aftb_hper <- function() {
  xfile <- ntwd_tf(18)
  on.exit(file.remove(xfile))
  xfile %>%
    read_excel_silently(.) %>%
    clean_date_yq() %>%
    gather(region, value, -Date, factor_key = TRUE)
}
