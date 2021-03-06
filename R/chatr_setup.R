#' Setup environment variables for ChatWork API connection
#' @description This function sets api_token and room_id as environment variables.
#' @param config_file_path path to config.yml file
#' @examples
#' chatr_setup(config_file_path = "~/Documents/chatr/dummy_config.yml")
#' @import config
#' @export

chatr_setup <- function(config_file_path = NULL){

  is_file_path <- file.exists(config_file_path)
  if (is_file_path != TRUE) {
    stop("`config.yml` not found. please create it & save your chatwork api token and room_id.")
  }

  config <- config::get(file = config_file_path)
  Sys.setenv(CHATWORK_API_TOKEN = config$api_token)
  Sys.setenv(CHATWORK_ROOMID = config$room_id)

}
