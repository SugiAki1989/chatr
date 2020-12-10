#' Function to get my status
#' @description This function is used to get my unread count, unread TO count, and unfinished task count
#' @param api_token your full ChatWork API token
#' @examples
#' chatr_status()
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_my.html#GET-my-status
# Method: GET
# Endpoint: /my/status
# Description: 自分の未読数、未読To数、未完了タスク数を返す
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" "https://api.chatwork.com/v2/my/status"
# Response:
# {
#   "unread_room_num": 2,
#   "mention_room_num": 1,
#   "mytask_room_num": 3,
#   "unread_num": 12,
#   "mention_num": 1,
#   "mytask_num": 8
# }
# ------------------------------------------------------------------------------------------/

chatr_status <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN")){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "my/status")

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token))

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = 'utf-8')

  return(result)
}


