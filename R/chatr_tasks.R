#' Function to get my tasks
#' @description This function is used to get my task list.
#' @param api_token your full ChatWork API token
#' @param assigned_by_account_id person id who assigned the task
#' @param status select open task or closed task
#' @examples
#' chatr_tasks()
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_my.html#GET-my-tasks
# Method: GET
# Endpoint: /my/tasks
# Description: 自分のタスク一覧を取得する。(※100件まで取得可能)
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" \
#         "https://api.chatwork.com/v2/my/tasks?assigned_by_account_id=78&status=done"
# Response:
# [
#   { --1つ目のタスク
#     "task_id": 3,
#     "room": {
#       "room_id": 5,
#       "name": "Group Chat Name",
#       "icon_path": "https://example.com/ico_group.png"
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
#   },
#   { --2つ目のタスク
#     "task_id": 3,
#     "room": {
#       "room_id": 5,
#       "name": "Group Chat Name",
#       "icon_path": "https://example.com/ico_group.png"
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

chatr_tasks <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                        assigned_by_account_id = NULL,
                        status = "open"){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "my/tasks")

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token),
                        query = list(assigned_by_account_id = assigned_by_account_id,
                                     status = status))
  httr::warn_for_status(response)

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(result)
}


