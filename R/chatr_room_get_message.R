#' Function to get specified chat room message
#' @description This function is used to get specified chat room message
#' @param api_token your full ChatWork API token
#' @param room_id which room to get
#' @param message_id which message to get
#' @examples
#' chatr_room_get_message(message_id = "111111111111111")
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#GET-rooms-room_id-members
# Method: GET
# Endpoint: /rooms/{room_id}/messages/{message_id}
# Description: メッセージ情報を取得。
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/messages/{message_id}"
# Response:
# {
#   "message_id": "5",
#   "account": {
#     "account_id": 123,
#     "name": "Bob",
#     "avatar_image_url": "https://example.com/ico_avatar.png"
#   },
#   "body": "Hello Chatwork!",
#   "send_time": 1384242850,
#   "update_time": 0
# }
# ------------------------------------------------------------------------------------------/

chatr_room_get_message <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                   room_id = Sys.getenv("CHATWORK_ROOMID"),
                                   message_id = NULL){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (room_id == "") {
    stop("`room_id` not found. Did you forget to call chatr_setup()?")
  }

  if (is.null(message_id) == TRUE){
    stop("`message_id` not found. specify the message id.")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", room_id, "/messages/", message_id)

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
