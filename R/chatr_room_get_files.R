#' Function to get specified chat room files
#' @description This function is used to get specified chat room files.
#' @param api_token your full ChatWork API token
#' @param room_id which room to get
#' @param account_id which account_id to get
#' @examples
#' chatr_room_get_files(account_id = "111111111")
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#GET-rooms-room_id-files
# Method: GET
# Endpoint: /rooms/{room_id}/files
# Description: チャットのファイル一覧を取得 (※100件まで取得可能)。
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/files?account_id=101"
# Response:
# [
#   {
#     "file_id": 3,
#     "account": {
#       "account_id": 123,
#       "name": "Bob",
#       "avatar_image_url": "https://example.com/ico_avatar.png"
#     },
#     "message_id": "22",
#     "filename": "README.md",
#     "filesize": 2232,
#     "upload_time": 1384414750
#   }
# ]
# ------------------------------------------------------------------------------------------/

chatr_room_get_files <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                 room_id = Sys.getenv("CHATWORK_ROOMID"),
                                 account_id = NULL){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (room_id == "") {
    stop("`room_id` not found. Did you forget to call chatr_setup()?")
  }

  if (is.null(account_id) == TRUE) {
    message("[info] `account_id` is not specified.")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", room_id, "/files")

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token),
                        query = list(account_id = account_id))
  httr::warn_for_status(response)

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(result)
}
