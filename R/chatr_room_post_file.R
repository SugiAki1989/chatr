#' Function to upload image file
#' @description This function is used to upload image file to the specified room_id.
#' @param api_token your full ChatWork API token
#' @param room_id which room to post
#' @param message the body of the message you post with the file
#' @param file file path of the image file you want to upload
#' @examples
#' chatr_room_post_file(message = "Hello Chatwork image.", file = "~/Documents/chatr/Rlogo.png")
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
# chatr_room_post_file(file = "~/Desktop/test_img_43419byte.png")

chatr_room_post_file <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                                 room_id = Sys.getenv("CHATWORK_ROOMID"),
                                 file,
                                 message = "Image file uploaded by chatr through API."
                     ) {

  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (room_id == "") {
    stop("`room_id` not found. Did you forget to call chatr_setup()?")
  }

  is_file_path <- file.exists(file)
  if (is_file_path != TRUE) {
    stop("`file` is invalid. image file not found. please confirm file path.")
  }

  is_limit <- is_file_limit(file)
  if (is_limit != TRUE){
    stop("Image file size exceeds the upper limit of 5MB.")
  }

  end_point_url <- paste0(CHATWORK_API_URL, "rooms/", room_id, "/files")

  response <- httr::POST(
    url = end_point_url,
    config = c(
      httr::add_headers(`X-ChatWorkToken` = api_token),
      httr::add_headers(`Content-Type` = "multipart/form-data")
    ),
    body = list(file = httr::upload_file(file),
                message = message)
    )

  if (httr::http_error(response) == TRUE) {
    stop(throw_error(response))
  }

  return(invisible(result))
}

