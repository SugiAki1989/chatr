#' Function to leave or delete chat room
#' @description This function is used to leave from chat room or delete chat room.
#' @param api_token your full ChatWork API token
#' @param room_id which room to update
#' @param action_type leave or delete
#' @param confirm check if you really want to leave or delete
#' @examples
#' chatr_room_delete(action_type = "delete")
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#DELETE-rooms-room_id
# Method: DELETE
# Endpoint: /rooms/{room_id}
# Description: グループチャットを退席/削除する。
# How:
#   curl -X DELETE -H "X-ChatWorkToken: {my_api_token}" \
#        -d "action_type=leave"  \
#        "https://api.chatwork.com/v2/rooms/{room_id}"
# Response:
# レスポンスなし
# Params:
#   action_type:退席するか(leave)、削除するか(delete)
# ------------------------------------------------------------------------------------------/

chatr_room_delete <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                              room_id = Sys.getenv("CHATWORK_ROOMID"),
                              action_type = c("leave", "delete"),
                              confirm = FALSE
                           ){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (room_id == "") {
    stop("`room_id` not found. Did you forget to call chatr_setup()?")
  }

  if (confirm == FALSE){
    stop("if you really want to leave or delete, set TRUE to `confirm` argument.")
  }

  action_type <- match.arg(action_type)

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", room_id)

  response <- httr::DELETE(url = end_point_url,
                           config = httr::add_headers(`X-ChatWorkToken` = api_token),
                           query = list(action_type = action_type)
                           )
  httr::warn_for_status(response)

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(invisible(result))
}


