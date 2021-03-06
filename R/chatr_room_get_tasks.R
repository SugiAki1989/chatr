#' Function to get specified chat room tasks
#' @description This function is used to get specified chat room tasks
#' @param api_token your full ChatWork API token
#' @param room_id which room to get
#' @param account_id account id of the person in charge of the task
#' @param assigned_by_account_id account id of the task requester
#' @param status default is "open". If "done" is specified, Completed tasks will be acquired.
#' @param to_df whether to convert the return value to a data frame. default is FALSE.
#' @examples
#' chatr_room_get_tasks(account_id = "11111", assigned_by_account_id = "11111", status = "open")

#' @import httr dplyr purrr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#GET-rooms-room_id-tasks
# Method: GET
# Endpoint: /rooms/{room_id}/tasks
# Description: チャットのタスク一覧を取得 (※100件まで取得可能。)
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/tasks? \
#        account_id=101& \
#        assigned_by_account_id=78& \
#        status=done"
# Response:
# [
#   {
#     "task_id": 3,
#     "account": {
#       "account_id": 123,
#       "name": "Bob",
#       "avatar_image_url": "https://example.com/abc.png"
#     },
#     "assigned_by_account": {
#       "account_id": 456,
#       "name": "Anna",
#       "avatar_image_url": "https://example.com/def.png"
#     },
#     "message_id": "13",
#     "body": "buy milk",
#     "limit_time": 1384354799,
#     "status": "open",
#     "limit_type": "date"
#   }
# ]
# ------------------------------------------------------------------------------------------/

chatr_room_get_tasks <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                 room_id = Sys.getenv("CHATWORK_ROOMID"),
                                 account_id = NULL,
                                 assigned_by_account_id = NULL,
                                 status = c("open", "done"),
                                 to_df = FALSE){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (room_id == "") {
    stop("`room_id` not found. Did you forget to call chatr_setup()?")
  }

  if (is.null(account_id) == TRUE) {
    message("[info] `account_id` is not specified")
  }

  if (is.null(assigned_by_account_id) == TRUE) {
    message("[info] `assigned_by_account_id` is not specified")
  }

  status <- match.arg(status)

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", room_id, "/tasks")

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token),
                        query = list(account_id = account_id,
                                     assigned_by_account_id = assigned_by_account_id,
                                     status = status)
                        )

  if (httr::http_error(response) == TRUE) {
    stop(throw_error(response))
  }

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")


  # NOTE: result returns the following
  #-----------------------------------------------------------------------------
  # List of 3
  # $ :List of 8
  # ..$ task_id            : int 11111111
  # ..$ account            :List of 3
  # .. ..$ account_id      : int 11111111
  # .. ..$ name            : chr "user01"
  # .. ..$ avatar_image_url: chr "https://appdata.chatwork.com/*****.png"
  # ..$ assigned_by_account:List of 3
  # .. ..$ account_id      : int 11111111
  # .. ..$ name            : chr "user01"
  # .. ..$ avatar_image_url: chr "https://appdata.chatwork.com/*****.png"
  # ..$ message_id         : chr "11111111111"
  # ..$ body               : chr "sample task1"
  # ..$ limit_time         : int 11111111
  # ..$ status             : chr "open"
  # ..$ limit_type         : chr "date"
  #-----------------------------------------------------------------------------

  if (to_df == TRUE){
    # Get 1 level of the list `[`
    l1 <- result %>% purrr::map(`[`, c("task_id", "message_id", "body", "limit_time", "status", "limit_type")) %>% purrr::map_dfr(.x = ., .f = function(x){dplyr::bind_rows(x)})
    # Get 2 levels of the list `[[`
    l2 <- result %>% purrr::map(`[[`, "account") %>% purrr::map_dfr(.x = ., .f = function(x){dplyr::bind_rows(x)})
    # Get 2 levels of the list `[[` & rename because name conflict
    l3 <- result %>% purrr::map(`[[`, "assigned_by_account") %>% purrr::map_dfr(.x = ., .f = function(x){dplyr::bind_rows(x)})
    names(l3) <- paste0("assigned_by_", names(l3))

    result <- dplyr::bind_cols(l1, l2, l3)
  }

  return(result)
}
