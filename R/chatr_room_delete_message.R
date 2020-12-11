#' Function to delete specified chat room message
#' @description This function is used to delete specified chat room message
#' @param api_token your full ChatWork API token
#' @param roomid which room to get
#' @param message_id which message to update
#' @examples
#' chatr_room_delete_message(message_id = "111111111111111")
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#DELETE-rooms-room_id-messages-message_id
# Method: DELETE
# Endpoint: /rooms/{room_id}/messages/{message_id}
# Description: チャットのメッセージを削除。
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/messages/{message_id}"
# Response:
# {
# "message_id": "1234"
# }
# ------------------------------------------------------------------------------------------/

chatr_room_delete_message <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                      roomid = Sys.getenv("CHATWORK_ROOMID"),
                                      message_id = NULL){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (roomid == "") {
    stop("`roomid` not found. Did you forget to call chatr_setup()?")
  }

  if (is.null(message_id) == TRUE){
    stop("`message_id` not found. specify the message id.")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", roomid, "/messages/", message_id)

  response <- httr::DELETE(url = end_point_url,
                           config = httr::add_headers(`X-ChatWorkToken` = api_token)
  )
  httr::warn_for_status(response)

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(result)
}


