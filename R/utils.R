CHATWORK_API_URL <- "https://api.chatwork.com/v2/"

DEFAULT_ICONS <- c("group", "check", "document", "meeting", "event", "project",
                   "business", "study", "security", "star", "idea", "heart",
                   "magcup", "beer", "music", "sports", "travel")

'%nin%' <- function(x, y) !(x %in% y)

#' Check file size
#' @description This function is used to check file size.
#' @param file_path file path of the image or video file you want to upload
#' @examples
#' is_file_limit(file_path = ~/path_to_file)

is_file_limit <- function(file_path){

  is_file_path <- file.exists(file_path)
  if (is_file_path != TRUE) {
    stop("image file not found. please confirm file path.")
  }

  file_size <- file.info(file_path)$size
  if (5242880 > file_size){
    result <- TRUE
  } else {
    result <- FALSE
  }
  return(result)
}

#' Check room icon
#' @description This function is used to check room icon.
#' @param icon_preset icon you want to update
#' @examples
#' is_room_icons(icon_preset)

is_room_icons <- function(icon_preset){
  if (icon_preset %in% DEFAULT_ICONS){
    result <- TRUE
  } else {
    result <- FALSE
  }
  return(result)
}

#' Check task deadline datetime format
#' @description This function is used to check datetime format
#' @param datetime datetime
#' @examples
#' is_datetime_format("2020-12-12 00:00:00")

is_datetime_format <- function(datetime) {
  # validation: yyyy-mm-dd hh:mm:ss
  pattern <- "^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[12][0-9]|3[01])\\s{1}([01][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9]"
  result_tmp <- grep(x = datetime, pattern = pattern)

  if (length(result_tmp) == 0) {
    result <- FALSE
    } else if (result_tmp == 1) {
    result <- TRUE
    }

  return(result)
}

#' Unix time converter to datetime
#' @description This function is used to convert from JST datetime to Unix time
#' @param datetime datetime
#' @examples
#' conv_datetime2unixtime("2020-12-12 00:00:00")

conv_datetime2unixtime <- function(datetime){
  result <- as.numeric(as.POSIXlt(datetime, origin = "Asia/Tokyo"))
  return(result)
}

#' Check task deadline datetime
#' @description This function is used to check task deadline date
#' @param datetime datetime
#' @examples
#' is_deadline(datetime)

is_deadline <- function(datetime){
  if (datetime >= as.numeric(Sys.time())){
    result <- TRUE
  } else {
    result <- FALSE
  }
  return(result)
}





