#' Function to get information about chat rooms you own
#' @description This function is used to get information about chat rooms you own
#' @param api_token your full ChatWork API token
#' @param to_df whether to convert the return value to a data frame. default is FALSE.
#' @examples
#' chatr_rooms_get()
#' @import httr dplyr purrr jsonlite
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#GET-rooms
# Method: GET
# Endpoint: /rooms
# Description: 自分のチャット一覧の取得。
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" "https://api.chatwork.com/v2/rooms"
# Response:
# [
#   {
#     "room_id": 123,
#     "name": "Group Chat Name",
#     "type": "group",
#     "role": "admin",
#     "sticky": false,
#     "unread_num": 10,
#     "mention_num": 1,
#     "mytask_num": 0,
#     "message_num": 122,
#     "file_num": 10,
#     "task_num": 17,
#     "icon_path": "https://example.com/ico_group.png",
#     "last_update_time": 1298905200
#   }
# ]
# ------------------------------------------------------------------------------------------/

chatr_rooms_get <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                            to_df = FALSE){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms")

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token))

  if (httr::http_error(response) == TRUE) {
    stop(throw_error(response))
  }

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  if(to_df == TRUE){
    result <- purrr::map_dfr(.x = result, .f = function(x){dplyr::bind_rows(x)})
  }
ß
  return(result)
}



