#' Function to get my account information
#' @description This function is used to get my account infomation.
#' @param api_token your full ChatWork API token
#' @examples
#' chatr_me()
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_me.html#GET-me
# Method: GET
# Endpoint: /me
# Description: 自分自身の情報にアクセスできます。
# How:
#   curl -X GET -H "X-ChatWorkToken: {my_api_token}" "https://api.chatwork.com/v2/me"
# Response:
# {
#   "account_id": 123,
#   "room_id": 322,
#   "name": "John Smith",
#   "chatwork_id": "tarochatworkid",
#   "organization_id": 101,
#   "organization_name": "Hello Company",
#   "department": "Marketing",
#   "title": "CMO",
#   "url": "http://mycompany.example.com",
#   "introduction": "Self Introduction",
#   "mail": "taro@example.com",
#   "tel_organization": "XXX-XXXX-XXXX",
#   "tel_extension": "YYY-YYYY-YYYY",
#   "tel_mobile": "ZZZ-ZZZZ-ZZZZ",
#   "skype": "myskype_id",
#   "facebook": "myfacebook_id",
#   "twitter": "mytwitter_id",
#   "avatar_image_url": "https://example.com/abc.png",
#   "login_mail": "account@example.com"
# }
# ------------------------------------------------------------------------------------------/

chatr_me <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN")){
  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "me")

  response <- httr::GET(url = end_point_url,
                        config = httr::add_headers(`X-ChatWorkToken` = api_token))

  result <- httr::content(x = response,
                          as = "parsed",
                          encoding = 'utf-8')
  httr::warn_for_status(response)

  return(result)
}



