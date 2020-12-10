#' Check file size
#' @description This function is used to chack file size.
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
