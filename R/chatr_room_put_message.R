#' Function to update specified chat room message
#' @description This function is used to update specified chat room message
#' @param api_token your full ChatWork API token
#' @param roomid which room to get
#' @param message_id which message to update
#' @param body text you want to update
#' @examples
#' chatr_room_put_message(message_id = "111111111111111", body = "This is an updated text")
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#PUT-rooms-room_id-messages-message_id
# Method: PUT
# Endpoint: /rooms/{room_id}/messages/{message_id}
# Description: チャットのメッセージを更新する。
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" \
#        -d "body=Hello+Chatwork%21" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/messages/{message_id}"
# Response:
# {
# "message_id": "1234"
# }
# ------------------------------------------------------------------------------------------/

chatr_room_put_message <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                   roomid = Sys.getenv("CHATWORK_ROOMID"),
                                   message_id = NULL,
                                   body = NULL){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (roomid == "") {
    stop("`roomid` not found. Did you forget to call chatr_setup()?")
  }

  if (is.null(message_id) == TRUE){
    stop("`message_id` not found. specify the message id.")
  }

  if (is.null(body) == TRUE){
    stop("`body` not found. set text you want to update.")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", roomid, "/messages/", message_id)

  response <- httr::PUT(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token),
                        query = list(body = body)
                        )
  httr::warn_for_status(response)

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(result)
}
