
# 5,7-16 same format ------------------------------------------------------

ntwd_get_id <- function(id) {
  if (missing(id)) {
    stop("You must specify a `id`, see ?nwtd_dataset", call. = FALSE)
  }
  id_categories <-
    c("monthly", "quarterly", "since_1952", "inflation_adjusted",
      "regional", "seasonal_regional",
      "new_prop", "mod_prop", "old_prop", "not_new_prop",
      "first","fowner",
      "terraced", "flats", "detached",
      "aftb_ind", "aftb_hper")

  if (!(id %in% id_categories)) {
    stop("`id` is not valid, see ?ntwd_dataset.", call. = FALSE)
  }
  switch(id,
     monthly = ntwd_get_monthly(),
     quarterly = ntwd_get_quarterly(),
     since_1952 = ntwd_get_since_1952(),
     inflation_adjusted = ntwd_get_inflation_adjusted(),
     regional = ntwd_get_generic("all_prop"),
     seasonal_regional = ntwd_get_seasonal_regional(),
     not_new_prop = ntwd_get_not_new_prop(),
     aftb_ind = ntwd_get_aftb_ind(),
     aftb_hper = ntwd_get_aftb_hper(),
     ntwd_get_generic(id)
  )
}

#' Access object's metadata
#'
#' Some datasets in nationwide contain metadata that cannot be displayed in
#' a dataframe. All metadata are stored as attributes to the dataframe, where it
#' can be displayed with \code{ntwd_meta}.
#'
#' @param x The object that is returned from \code{\link{ntwd_get}}.
#'
#' @details Not all objects contain metadata
#'
#' @export
#'
#' @examples
#' \donttest{
#' x <- ntwd_get("since_1952")
#' ntwd_meta(x)
#' }
ntwd_meta <- function(x) {
  attr(x, "metadata") %||%
    message("the objects does not contain metadata")
}


#' Download House Price Data from Nationwide
#'
#' This function scrapes Nationwide's House Price Index webpage and
#' downloads data in tidy format. Available datasets are given an `id`. All
#' available `id` and short descriptions  can be viewed via `?datasets`.
#' For more information the user can browse the source webpage through
#' \code{\link{ntwd_browse}}.
#'
#' @param id which dataset `id`to fetch.
#'
#' @export
#'
#' @examples
#'\donttest{
#' ntwd_get("monthly")
#'
#' ntwd_get("terraced")
#'
#' # For a list of datasets
#' ?ntwd_datasets
#' }
ntwd_get <- function(id) {
  ntwd_get_id(id)
}

