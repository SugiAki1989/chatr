#' Function to get specified chat room specified task
#' @description This function is used to get specified chat room specified task
#' @param api_token your full ChatWork API token
#' @param roomid which room to get
#' @param task_id which task to get
#' @examples
#' chatr_room_get_task(task_id = "11111")
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#GET-rooms-room_id-tasks-task_id
# Method: GET
# Endpoint: /rooms/{room_id}/tasks/{task_id}
# Description: タスク情報を取得
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/tasks/{task_id}"
# Response:
# {
#   "task_id": 3,
#   "account": {
#     "account_id": 123,
#     "name": "Bob",
#     "avatar_image_url": "https://example.com/abc.png"
#   },
#   "assigned_by_account": {
#     "account_id": 456,
#     "name": "Anna",
#     "avatar_image_url": "https://example.com/def.png"
#   },
#   "message_id": "13",
#   "body": "buy milk",
#   "limit_time": 1384354799,
#   "status": "open",
#   "limit_type": "date"
# }
# ------------------------------------------------------------------------------------------/

chatr_room_get_task <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                roomid = Sys.getenv("CHATWORK_ROOMID"),
                                task_id = NULL){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (roomid == "") {
    stop("`roomid` not found. Did you forget to call chatr_setup()?")
  }

  if (is.null(task_id) == TRUE){
    stop("`task_id` not found. specify the task id.")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", roomid, "/tasks/", task_id)

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token)
  )
  httr::warn_for_status(response)

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(result)
}