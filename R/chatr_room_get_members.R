#' Function to get specified chat room members
#' @description This function is used to get specified chat room members.
#' @param api_token your full ChatWork API token
#' @param room_id which room to get
#' @param to_df whether to convert the return value to a data frame. default is FALSE.
#' @examples
#' chatr_room_get_members()
#' @import httr dplyr purrr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#GET-rooms-room_id-members
# Method: GET
# Endpoint: /rooms/{room_id}/members
# Description: チャットのメンバー一覧を取得。
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}"
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
                                   room_id = Sys.getenv("CHATWORK_ROOMID"),
                                   to_df = FALSE){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (room_id == "") {
    stop("`room_id` not found. Did you forget to call chatr_setup()?")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", room_id, "/members")

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token))

  if (httr::http_error(response) == TRUE) {
    stop(throw_error(response))
  }

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  if(to_df == TRUE){
    result <- result %>% purrr::map_dfr(.x = ., .f = function(x){dplyr::bind_rows(x)})
    }

  return(result)
}

