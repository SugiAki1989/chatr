#' Function to create chat room
#' @description This function is used to create chat room.
#' @param api_token your full ChatWork API token
#' @param description group chat overview text. default is "This room description is created by chatr through API.".
#' @param icon_preset group chat icon type. default is "meeting". choose from
#' {group, check, document, meeting, event, project, business, study, security, star, idea, heart, magcup, beer, music, sports, travel}.
#' @param link whether to create an invitation link. default is 0.
#' @param link_need_acceptance whether to participate by administrator approval. default is 0.
#' @param members_admin_ids character vactor of account IDs of users who want to have administrator privileges among the members who participate in the created chat.
#' at least one person must be specified.
#' you can only specify the account IDs of contacted users or users in your organization.
#' @param members_member_ids character vector of account IDs of the users who want to have member privileges among the members who participate in the created chat.
#' you can only specify the account IDs of contacted users or users in your organization.
#' @param members_readonly_ids character vaector of account IDs of the members who participate in the created chat and want to have read-only permission.
#' you can only specify the account IDs of contacted users or users in your organization.
#' @param name chat name of the group chat you want to create. default is "This room name is created by chatr through API.".
#' @examples
#' chatr_room_post(
#'     description = "For Project X you can use it.",
#'     icon_preset = "meeting",
#'     link = 0,
#'     link_need_acceptance = 0,
#'     members_admin_ids = c("11111111","22222222"),
#'     members_member_ids = c("33333333"),
#'     members_readonly_ids = NULL,
#'     name = "Project X"
#'     )
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#POST-rooms
# Method: POST
# Endpoint: /rooms
# Description: グループチャットを新規作成。
# How:
#   curl -X POST -H "X-ChatWorkToken: {my_api_token}" \
#        -d "description=group+chat+description&  \
#            icon_preset=meeting& \
#            members_admin_ids=123%2C542%2C1001& \
#            members_member_ids=21%2C344& \
#            members_readonly_ids=15%2C103& \
#            name=Website+renewal+project" \
#        "https://api.chatwork.com/v2/rooms"
# Response:
# {
#   "room_id": 1234
# }
# Params:
#   description:グループチャットの概要説明テキスト
#   icon_preset:グループチャットのアイコン種類
#   link:招待リンクを作成するか
#   link_code:リンクのパス部分。省略するとランダムな文字列となる。
#   link_need_acceptance:参加に管理者の承認を必要とするか。
#   members_admin_ids:作成したチャットに参加メンバーのうち管理者権限にしたいユーザーのアカウントIDの配列。最低1人は指定する必要がある。
#                     コンタクト済みユーザーか組織内ユーザーのアカウントIDのみ指定できる。
#   members_member_ids:作成したチャットに参加メンバーのうちメンバー権限にしたいユーザーのアカウントIDの配列。
#                      コンタクト済みユーザーか組織内ユーザーのアカウントIDのみ指定できる。
#   members_readonly_ids:作成したチャットに参加メンバーのうち閲覧のみ権限にしたいユーザーのアカウントIDの配列。
#                        コンタクト済みユーザーか組織内ユーザーのアカウントIDのみ指定できる。
#   name:作成したいグループチャットのチャット名
# ------------------------------------------------------------------------------------------/

chatr_room_post <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                             description = "This room description is created by chatr through API.",
                             icon_preset = "meeting",
                             link = 0,
                             link_need_acceptance = 0,
                             members_admin_ids = NULL, # must
                             members_member_ids = NULL,
                             members_readonly_ids = NULL,
                             name = "This room name is created by chatr through API." # must
                            ){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (is_room_icons(icon_preset) != TRUE){
    stop(
      paste0("`icon_preset` is invalid. choose from {", paste0(DEFAULT_ICONS, collapse = ", "), "}.")
      )
  }

  if (link %nin% c(0, 1)) {
    stop("`link` must be 0 or 1.")
  }

  if (link_need_acceptance %nin% c(0, 1)) {
    stop("`link_need_acceptance` must be 0 or 1.")
  }

  if (is.null(members_admin_ids) == TRUE){
    stop("`members_admin_ids` is invalid. At least 1 id must be specified from the contacted user or the user in the organization.")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms")

  admin_ids_collapse    <- paste0(members_admin_ids, collapse = ",")
  member_ids_collapse   <- paste0(members_member_ids, collapse = ",")
  readonly_ids_collapse <- paste0(members_readonly_ids, collapse = ",")

  response <- httr::POST(url = end_point_url,
                         config = httr::add_headers(`X-ChatWorkToken` = api_token),
                         body = list(description = description,
                                     icon_preset = icon_preset,
                                     link = link,
                                     link_need_acceptance = link_need_acceptance,
                                     members_admin_ids = admin_ids_collapse,
                                     members_member_ids = member_ids_collapse,
                                     members_readonly_ids = readonly_ids_collapse,
                                     name = name)
                         )

  if (httr::http_error(response) == TRUE) {
    stop(throw_error(response))
  }

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = "utf-8")

  return(invisible(result))
}

