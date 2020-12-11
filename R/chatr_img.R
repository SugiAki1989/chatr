#' Function to upload image file
#' @description This function is used to upload image file to the specified roomid.
#' @param api_token your full ChatWork API token
#' @param roomid which room to post the text and R code
#' @param file_message the body of the message you post with the file
#' @param file_path file path of the image file you want to upload
#' @examples
#' chat_img(file_message = "Hello Chatwork image.",
#'          file_path = "path_to_image_file")
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#POST-rooms-room_id-files
# Method: POST
# Endpoint: /rooms/{room_id}/files
# Description: チャットに新しいファイルをアップロード
# How:
#   curl -X POST -H "X-ChatWorkToken: {my_api_token}" \
#        -F"file=@/path/to/file" \
#        -F"message=I+attached+comment+to+chat." \
#        "https://api.chatwork.com/v2/rooms/{room_id}/files"
# Response:
# {
#   "file_id": 1234
# }
# ------------------------------------------------------------------------------------------/
# ggplot2::ggplot(data=iris, aes(x=Species, y=Sepal.Length, fill=Species)) + geom_point()
# ggsave(filename = "test_img_43419byte.png", path = "~/Desktop")
# chat_img(file_path = "~/Desktop/test_img_43419byte.png")

chat_img <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                     roomid = Sys.getenv("CHATWORK_ROOMID"),
                     file_path,
                     message = "Image file uploaded by chatr through API."
                     ) {

  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (roomid == "") {
    stop("`roomid` not found. Did you forget to call chatr_setup()?")
  }

  is_file_path <- file.exists(file_path)
  if (is_file_path != TRUE) {
    stop("image file not found. please confirm file path.")
  }

  is_limit <- is_file_limit(file_path)
  if (is_limit != TRUE){
    stop("Image file size exceeds the upper limit of 5MB.")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", roomid, "/files")

  response <- httr::POST(
    url = end_point_url,
    config = c(
      httr::add_headers(`X-ChatWorkToken` = api_token),
      httr::add_headers(`Content-Type` = "multipart/form-data")
    ),
    body = list(file = httr::upload_file(file_path),
                message = message)
    )
  httr::warn_for_status(response)

  return(response)
}



