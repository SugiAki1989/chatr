#' Setup environment variables for ChatWork API connection
#' @param config_file_path path to config.yml file
#' @description This function sets api_token and roomid as environment variables.
#' @examples
#' chatr_setup(config_file_path = "~/Desktop/r-docker/config.yml")
#' @import config

chatr_setup <- function(config_file_path){

  is_file_path <- file.exists(config_file_path)
  if (is_file_path != TRUE) {
    stop("`config.yml` not found. please create it & save your chatwork api token and roomid.")
  }

  config <- config::get(file = config_file_path)
  Sys.setenv(CHATWORK_API_TOKEN = config$api_token)
  Sys.setenv(CHATWORK_ROOMID = config$roomid)
}


