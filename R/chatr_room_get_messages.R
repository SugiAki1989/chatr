#' Function to get specified chat room messages
#' @description This function is used to get specified chat room messages
#' @param api_token your full ChatWork API token
#' @param roomid which room to get chat room informations.
#' @param force default is 0. If 1 is specified, the latest 100 items will be acquired regardless of whether they have not been acquired.
#' @examples
#' chatr_room_get_messages(force = 0)
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#GET-rooms-room_id-messages
# Method: GET
# Endpoint: /rooms/{room_id}/messages
# Description: チャットのメンバー一覧を取得。
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/messages?force=0"
# Response:
# [
#   {
#     "message_id": "5",
#     "account": {
#       "account_id": 123,
#       "name": "Bob",
#       "avatar_image_url": "https://example.com/ico_avatar.png"
#     },
#     "body": "Hello Chatwork!",
#     "send_time": 1384242850,
#     "update_time": 0
#   }
# ]
# ------------------------------------------------------------------------------------------/

chatr_room_get_messages <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                    roomid = Sys.getenv("CHATWORK_ROOMID"),
                                    force = 0){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (roomid == "") {
    stop("`roomid` not found. Did you forget to call chatr_setup()?")
  }

  if (force %nin% c(0, 1)) {
    stop("`force` must be 0 or 1.")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", roomid, "/messages")

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token),
                        query = list(force = force)
                        )
  httr::warn_for_status(response)

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(result)
}

