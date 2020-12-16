#' Function to create specified chat room tasks
#' @description This function is used to create specified chat room tasks
#' @param api_token your full ChatWork API token
#' @param room_id which room to get
#' @param body task message
#' @param limit task deadline specified in datetime. format is `yyyy-mm-dd hh:mm:ss`.
#' @param limit_type task deadline type(none, date, time)
#' @param to_ids account ids of the person in charge
#' @param origin default origin is "Asia/Tokyo"
#' @examples
#' chatr_room_post_tasks(body = "sample task",
#'                       limit = "2020-12-15 00:00:00", # unix time is 16079583600
#'                       limit_type = "time",
#'                       to_ids = c("1111111","222222"),
#'                       origin = "Asia/Tokyo")
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#POST-rooms-room_id-tasks
# Method: POST
# Endpoint: /rooms/{room_id}/tasks
# Description: チャットに新しいタスクを追加。
# How:
#   curl -X POST -H "X-ChatWorkToken: {my_api_token}" \
#        -d "body=Buy+milk& \
#            limit=1385996399& \
#            limit_type=time& \
#            to_ids=1%2C3%2C6" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/tasks"
# Response:
# {
#   "task_ids": [123,124]
# }
# ------------------------------------------------------------------------------------------/

chatr_room_post_tasks <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                  room_id = Sys.getenv("CHATWORK_ROOMID"),
                                  body = NULL,
                                  limit = NULL,
                                  limit_type = c("none", "date", "time"),
                                  to_ids = NULL,
                                  origin = "Asia/Tokyo"){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (room_id == "") {
    stop("`room_id` not found. Did you forget to call chatr_setup()?")
  }

  if (is.null(body) == TRUE){
    stop("`body` is invalid. you must set content of the task")
  }

  if (is_datetime_format(limit) != TRUE){
    stop("`limit` is invalid. you must set datatime format `yyyy-mm-dd hh:mm:ss`.")
  }

  # API params requires Unix time for setting tasks.
  limit_unixtime <- as.numeric(as.POSIXlt(x = limit, origin = origin))
  if (is_deadline(limit_unixtime) != TRUE){
    stop("`limit` is invalid. you must set the date and time after the current time.")
  }

  limit_type <- match.arg(limit_type)

  if (is.null(to_ids) == TRUE){
    stop("`to_ids` is invalid. At least 1 id must be specified from the contacted user or the user in the organization.")
  }

  to_ids_collapese <- paste0(to_ids, collapse = ",")

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", room_id, "/tasks")

  response <- httr::POST(url = end_point_url,
                         config = httr::add_headers(`X-ChatWorkToken` = api_token),
                         body = list(body = body,
                                     limit = limit_unixtime,
                                     limit_type = limit_type,
                                     to_ids = to_ids_collapese)
  )

  if (httr::http_error(response) == TRUE) {
    stop(throw_error(response))
  }

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(invisible(result))
}


