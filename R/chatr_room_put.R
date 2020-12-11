#' Function to create chat room
#' @description This function is used to create chat room.
#' @param api_token your full ChatWork API token
#' @param roomid which room to update
#' @param description group chat overview text you want to update.
#' @param icon_preset group chat icon type you want to update.
#' @param name chat name of the group chat you want to update
#' @examples
#' chatr_room_put(
#'     description = "description you want to update",
#'     name = "name you want to update"
#'     )
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#PUT-rooms-room_id
# Method: PUT
# Endpoint: /rooms/{room_id}
# Description: チャットの名前、アイコンをアップデート。
# How:
#   curl -X PUT -H "X-ChatWorkToken: {my_api_token}" \
#        -d "description=group+chat+description& \
#            icon_preset=meeting& \
#            name=Website+renewal+project" \
#        "https://api.chatwork.com/v2/rooms/{room_id}"
# Response:
# {
#   "room_id": 1234
# }
# Params:
#   description:グループチャットの概要説明テキスト
#   icon_preset:グループチャットのアイコン種類
#   name:作成したいグループチャットのチャット名
# ------------------------------------------------------------------------------------------/

chatr_room_put <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                           roomid = Sys.getenv("CHATWORK_ROOMID"),
                           description = NULL,
                           icon_preset = NULL,
                           name = NULL
                            ){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (roomid == "") {
    stop("`roomid` not found. Did you forget to call chatr_setup()?")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", roomid)

  response <- httr::PUT(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token),
                        query = list(description = description,
                                     icon_preset = icon_preset,
                                     name = name)
  )
  httr::warn_for_status(response)

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(result)
}

