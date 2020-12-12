#' Function to update specified chat room authority
#' @description This function is used to update specified chat room authority
#' @param api_token your full ChatWork API token
#' @param room_id which room to update
#' @param members_admin_ids character vactor of account IDs of users who want to have administrator privileges among the members who participate in the created chat.
#' At least one id must be specified. You can only specify the account IDs of contacted users or users in your organization.
#' @param members_member_ids character vactor of account IDs of users who want to have member privileges among the members who participate in the created chat.
#' You can only specify the account IDs of contacted users or users in your organization.
#' @param members_readonly_ids character vactor of account IDs of users who want to have readonly privileges among the members who participate in the created chat.
#' You can only specify the account IDs of contacted users or users in your organization.
#' @examples
#' chatr_room_put_members(
#'     members_admin_ids = c("11111111","22222222"),
#'     members_member_ids = c("33333333"),
#'     members_readonly_ids = NULL,
#'     )
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#PUT-rooms-room_id-members
# Method: PUT
# Endpoint: PUT/rooms/{room_id}/members
# Description: チャットのメンバーを一括変更。
# How:
#   curl -X PUT -H "X-ChatWorkToken: {my_api_token}" \
#        -d "members_admin_ids=123%2C542%2C1001& \
#            members_member_ids=21%2C344& \
#            members_readonly_ids=15%2C103" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/members"
# Response:
# {
#   "admin": [123, 542, 1001],
#   "member": [10, 103],
#   "readonly": [6, 11]
# }
# Params:
#   members_admin_ids:作成したチャットに参加メンバーのうち、管理者権限にしたいユーザーのアカウントIDの配列。
#                     最低1人は指定する必要がある。コンタクト済みユーザーか組織内ユーザーのアカウントIDのみ指定できる。
#   members_member_ids:作成したチャットに参加メンバーのうち、メンバー権限にしたいユーザーのアカウントIDの配列。
#                      コンタクト済みユーザーか組織内ユーザーのアカウントIDのみ指定できる。
#   members_readonly_ids:作成したチャットに参加メンバーのうち、閲覧のみ権限にしたいユーザーのアカウントIDの配列。
#                        コンタクト済みユーザーか組織内ユーザーのアカウントIDのみ指定できる。
# ------------------------------------------------------------------------------------------/

chatr_room_put_members <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                   room_id = Sys.getenv("CHATWORK_ROOMID"),
                                   members_admin_ids = NULL, # must
                                   members_member_ids = NULL,
                                   members_readonly_ids = NULL){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (is.null(members_admin_ids) == TRUE){
    stop("`members_admin_ids` is invalid.
         At least 1 id must be specified from the contacted user or the user in the organization.")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", room_id, "/members")

  admin_ids_collapse    <- paste0(members_admin_ids, collapse = ",")
  member_ids_collapse   <- paste0(members_member_ids, collapse = ",")
  readonly_ids_collapse <- paste0(members_readonly_ids, collapse = ",")

  response <- httr::PUT(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token),
                        query = list(members_admin_ids = admin_ids_collapse,
                                     members_member_ids = member_ids_collapse,
                                     members_readonly_ids = readonly_ids_collapse
                                     )
  )
  httr::warn_for_status(response)

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(result)
}
