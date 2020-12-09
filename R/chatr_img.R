# TODO:description

# curl -X POST -H "X-ChatWorkToken: {api_token}"
# -F"file=@/Users/aki/Desktop/test_img.png"
# -F"message=I+attached+comment+to+chat."
# "https://api.chatwork.com/v2/rooms/{room_id}/files"

# test_img <- ggplot(data=iris, aes(x=Species, y=Sepal.Length, fill=Species)) +
#   geom_point()

chat_img <- function(api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                     roomid = Sys.getenv("CHATWORK_ROOMID"),
                     file_message,
                     file_path) {

  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (roomid == "") {
    stop("`roomid` not found. Did you forget to call chatr_setup()?")
  }

  end_point_url <- paste0("https://api.chatwork.com/v2/rooms/", roomid, "/files")

  # TODO:	confirm httr::POST() args
  res <- httr::POST(
    url = end_point_url,
    config = c(
      httr::add_headers(`X-ChatWorkToken` = api_token),
      httr::add_headers(`Content-Type` = "multipart/form-data")
      ),
    body = list(
      file = httr::upload_file(file_path),
      message = file_message
    )
  )
  return(res)
}


chat_img(
  file_message = "test_imgae",
  file_path = "/Users/aki/Desktop/test_img.png")




