% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chatr_room_get_files.R
\name{chatr_room_get_files}
\alias{chatr_room_get_files}
\title{Function to get specified chat room files}
\usage{
chatr_room_get_files(
  api_token = Sys.getenv("CHATWORK_API_TOKEN"),
  room_id = Sys.getenv("CHATWORK_ROOMID"),
  account_id = NULL,
  to_df = FALSE
)
}
\arguments{
\item{api_token}{your full ChatWork API token}

\item{room_id}{which room to get}

\item{account_id}{which account_id to get}

\item{to_df}{whether to convert the return value to a data frame. default is FALSE.}
}
\description{
This function is used to get specified chat room files.
}
\examples{
chatr_room_get_files(account_id = "111111111")
}
