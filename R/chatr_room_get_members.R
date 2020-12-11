#' Function to get specified chat room members
#' @description This function is used to get specified chat room members.
#' @param api_token your full ChatWork API token
#' @param roomid which room to get chat room informations.
#' @examples
#' chatr_room_get_members()
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#GET-rooms-room_id-members
# Method: GET
# Endpoint: /rooms/{room_id}/members
# Description: チャットのメンバー一覧を取得。
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/members"
# Response:
# [
#   {
#     "account_id": 123,
#     "role": "member",
#     "name": "John Smith",
#     "chatwork_id": "tarochatworkid",
#     "organization_id": 101,
#     "organization_name": "Hello Company",
#     "department": "Marketing",
#     "avatar_image_url": "https://example.com/abc.png"
#   }
# ]
# ------------------------------------------------------------------------------------------/

chatr_room_get_members <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                   roomid = Sys.getenv("CHATWORK_ROOMID")){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (roomid == "") {
    stop("`roomid` not found. Did you forget to call chatr_setup()?")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", roomid, "/members")

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token))
  httr::warn_for_status(response)

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(result)
}

