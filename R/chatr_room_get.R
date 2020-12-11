#' Function to get specified chat room informations
#' @description This function is used to get specified chat room informations.
#' @param api_token your full ChatWork API token
#' @param roomid which room to get
#' @examples
#' chatr_room_get()
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#GET-rooms-room_id
# Method: GET
# Endpoint: /rooms/{room_id}
# Description: チャットの名前、アイコン、種類(my/direct/group)を取得。
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" "https://api.chatwork.com/v2/rooms/{room_id}"
# Response:
# {
#   "room_id": 123,
#   "name": "Group Chat Name",
#   "type": "group",
#   "role": "admin",
#   "sticky": false,
#   "unread_num": 10,
#   "mention_num": 1,
#   "mytask_num": 0,
#   "message_num": 122,
#   "file_num": 10,
#   "task_num": 17,
#   "icon_path": "https://example.com/ico_group.png",
#   "last_update_time": 1298905200,
#   "description": "room description text"
# }
# ------------------------------------------------------------------------------------------/

chatr_room_get <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                           roomid = Sys.getenv("CHATWORK_ROOMID")){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (roomid == "") {
    stop("`roomid` not found. Did you forget to call chatr_setup()?")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", roomid)

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token))
  httr::warn_for_status(response)

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(result)
}
