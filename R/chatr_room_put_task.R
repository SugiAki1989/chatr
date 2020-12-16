#' Function to update specified chat room task status
#' @description This function is used to update specified chat room task status
#' @param api_token your full ChatWork API token
#' @param room_id which room to get
#' @param task_id which task to update
#' @param body which status you change(open or done)
#' @examples
#' chatr_room_put_task(task_id = "11111111", body = "done")
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#PUT-rooms-room_id-tasks-task_id-status
# Method: PUT
# Endpoint: /rooms/{room_id}/tasks/{task_id}/status
# Description: タスク完了状態を変更する。
# How:
#   curl -X PUT -H "X-ChatWorkToken: {my_api_token}" \
#        -d "body=done" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/tasks/{task_id}/status"
# Response:
# {
#   "task_id": 1234
# }
# ------------------------------------------------------------------------------------------/

chatr_room_put_task <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                room_id = Sys.getenv("CHATWORK_ROOMID"),
                                task_id = NULL,
                                body = c("open", "done")){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (room_id == "") {
    stop("`room_id` not found. Did you forget to call chatr_setup()?")
  }

  if (is.null(task_id) == TRUE){
    stop("`task_id` not found. specify the task id.")
  }

  body <- match.arg(body)

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", room_id, "/tasks/", task_id, "/status")

  response <- httr::PUT(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token),
                        query = list(body = body)
  )

  if (httr::http_error(response) == TRUE) {
    stop(throw_error(response))
  }

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(invisible(result))
}
