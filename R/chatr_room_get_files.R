#' Function to get specified chat room files
#' @description This function is used to get specified chat room files.
#' @param api_token your full ChatWork API token
#' @param room_id which room to get
#' @param account_id which account_id to get
#' @param to_df whether to convert the return value to a data frame. default is FALSE.
#' @examples
#' chatr_room_get_files(account_id = "111111111")
#' @import httr dplyr purrr
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
                                 account_id = NULL,
                                 to_df = FALSE){
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

  if (httr::http_error(response) == TRUE) {
    stop(throw_error(response))
  }

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  # NOTE: result returns the following
  #-----------------------------------------------------------------------------
  # $ :List of 6
  # ..$ file_id    : int 11111111
  # ..$ message_id : chr "1111111111111"
  # ..$ filesize   : int 1111
  # ..$ filename   : chr "images.png"
  # ..$ upload_time: int 11111111111
  # ..$ account    :List of 3
  # .. ..$ account_id      : int 11111111111
  # .. ..$ name            : chr "user01"
  # .. ..$ avatar_image_url: chr "https://appdata.chatwork.com/******.png"
  #-----------------------------------------------------------------------------

  if (to_df == TRUE){
    result <-
      dplyr::bind_cols(
        # Get 1 level of the list `[`
        result %>% purrr::map(`[`, c("file_id", "message_id", "filesize", "filename", "upload_time")) %>% purrr::map_dfr(.x = ., .f = function(x){dplyr::bind_rows(x)}),
        # Get 2 levels of the list `[[`
        result %>% purrr::map(`[[`, "account") %>% purrr::map_dfr(.x = ., .f = function(x){dplyr::bind_rows(x)})
      )
  }

  return(result)
}
