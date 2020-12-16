#' Function to get specified chat room messages
#' @description This function is used to get specified chat room messages
#' @param api_token your full ChatWork API token
#' @param room_id which room to get
#' @param force If 1 is specified, the latest 100 items will be acquired regardless of whether they have not been acquired. default is 0.
#' @param to_df whether to convert the return value to a data frame. default is FALSE.
#' @examples
#' chatr_room_get_messages(force = 0)
#' @import httr purrr dplyr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#GET-rooms-room_id-messages
# Method: GET
# Endpoint: /rooms/{room_id}/messages
# Description: チャットのメッセージ一覧を取得。パラメータ未指定だと前回取得分からの差分のみを返します。(最大100件まで取得)
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/messages?force=0"
# Response:
# [
#   {
#     "message_id": "5",
#     "account": {
#       "account_id": 123,
#       "name": "Bob",
#       "avatar_image_url": "https://example.com/ico_avatar.png"
#     },
#     "body": "Hello Chatwork!",
#     "send_time": 1384242850,
#     "update_time": 0
#   }
# ]
# ------------------------------------------------------------------------------------------/

chatr_room_get_messages <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                    room_id = Sys.getenv("CHATWORK_ROOMID"),
                                    force = 0,
                                    to_df = FALSE){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (room_id == "") {
    stop("`room_id` not found. Did you forget to call chatr_setup()?")
  }

  if (force %nin% c(0, 1)) {
    stop("`force` must be 0 or 1.")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", room_id, "/messages")

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token),
                        query = list(force = force)
                        )

  if (httr::http_error(response) == TRUE) {
    stop(throw_error(response))
  }

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  # NOTE: result returns the following
  #-----------------------------------------------------------------------------
  # $ :List of 5
  # ..$ message_id : chr "11111111111111"
  # ..$ account    :List of 3
  # .. ..$ account_id      : int 1111111
  # .. ..$ name            : chr "user01"
  # .. ..$ avatar_image_url: chr "https://appdata.chatwork.com/aaaa.png"
  # ..$ body       : chr "hello world"
  # ..$ send_time  : int 111111
  # ..$ update_time: int 0
  #-----------------------------------------------------------------------------
  # TODO check list in data.frame
  # do.call(what = rbind, args = lapply(X = result, FUN = function(x){`[`(x, c("message_id", "body", "send_time", "update_time"))})),
  # do.call(what = rbind, args = lapply(X = result, FUN = function(x){`[[`(x, "account")}))

  if (to_df == TRUE){
    result <-
        dplyr::bind_cols(
          # Get 1 level of the list `[`
          result %>% purrr::map(`[`, c("message_id", "body", "send_time", "update_time")) %>% purrr::map_dfr(.x = ., .f = function(x){dplyr::bind_rows(x)}),
          # Get 2 levels of the list `[[`
          result %>% purrr::map(`[[`, "account") %>% purrr::map_dfr(.x = ., .f = function(x){dplyr::bind_rows(x)})
        )
    }

  return(result)
}
