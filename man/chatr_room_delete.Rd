% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chatr_room_delete.R
\name{chatr_room_delete}
\alias{chatr_room_delete}
\title{Function to leave or delete group chat room}
\usage{
chatr_room_delete(
  api_token = Sys.getenv("CHATWORK_API_TOKEN"),
  roomid = Sys.getenv("CHATWORK_ROOMID"),
  action_type = c("leave", "delete")
)
}
\arguments{
\item{api_token}{your full ChatWork API token}

\item{roomid}{which room to update.}

\item{action_type}{leave or delete}
}
\description{
This function is used to leave or delete group chat room.
}
\examples{
chatr_room_delete(action_type = "delete")
}