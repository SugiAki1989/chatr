#' Function to get specified chat room specified file
#' @description This function is used to get specified chat room specified file.
#' @param api_token your full ChatWork API token
#' @param room_id which room to get
#' @param file_id which file_id to get
#' @param create_download_url whether to generate a URL to download(0 is No, 1 is Yes).
#' @examples
#' chatr_room_get_file(file_id = "111111111", create_download_url = 1)
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#GET-rooms-room_id-files-file_id
# Method: GET
# Endpoint: /rooms/{room_id}/files/{file_id}
# Description: チャットのファイル一覧を取得 (※100件まで取得可能)。
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/files/{file_id}?create_download_url=1"
# Response:
# {
#   "file_id":3,
#   "account": {
#     "account_id":123,
#     "name":"Bob",
#     "avatar_image_url": "https://example.com/ico_avatar.png"
#   },
#   "message_id": "22",
#   "filename": "README.md",
#   "filesize": 2232,
#   "upload_time": 1384414750
# }
# ------------------------------------------------------------------------------------------/

chatr_room_get_file <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                room_id = Sys.getenv("CHATWORK_ROOMID"),
                                file_id = NULL,
                                create_download_url = 0){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (room_id == "") {
    stop("`room_id` not found. Did you forget to call chatr_setup()?")
  }

  if (is.null(file_id) == TRUE){
    stop("`file_id` not found. set file_id you want to get.")
  }

  if (create_download_url %nin% c(0, 1)) {
    stop("`create_download_url` must be 0 or 1.")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", room_id, "/files/", file_id)

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token),
                        query = list(create_download_url = create_download_url)
                        )
  httr::warn_for_status(response)

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(result)
}


