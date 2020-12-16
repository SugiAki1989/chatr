#' Function to get my user contacts
#' @description This function is used to access the list of users you are in contact with.
#' @param api_token your full ChatWork API token
#' @examples
#' chatr_contacts()
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_contacts.html
# Method: GET
# Endpoint: /contacts
# Description: 自分のコンタクト一覧を取得。
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" "https://api.chatwork.com/v2/contacts"
# Response:
# [
#  {
#   "account_id": 123,
#   "room_id": 322,
#   "name": "John Smith",
#   "chatwork_id": "tarochatworkid",
#   "organization_id": 101,
#   "organization_name": "Hello Company",
#   "department": "Marketing",
#   "avatar_image_url": "https://example.com/abc.png"
#  }
# ]
# ------------------------------------------------------------------------------------------/

chatr_contacts <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN")){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "contacts")

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token))

  if (httr::http_error(response) == TRUE) {
    stop(throw_error(response))
  }

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(result)
}
