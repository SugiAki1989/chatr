#' Function to get my account information
#' @param api_token your full ChatWork API token
#' @description This function is used to send a text or an R code to the specified roomid.
#' @examples
#' chatr_me()
#' @import httr


chatr_me <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN")){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  end_point_url <- "https://api.chatwork.com/v2/me"

  res_tmp <- httr::GET(
    url = end_point_url,
    config = httr::add_headers(`X-ChatWorkToken` = api_token)
  )

  res <- httr::content(res_tmp)
  return(res)
}

# tmp <- chatr_me()
#
# tmp



