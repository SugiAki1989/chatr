% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chatr_rooms_get.R
\name{chatr_rooms_get}
\alias{chatr_rooms_get}
\title{Function to get information about chat rooms you own}
\usage{
chatr_rooms_get(api_token = Sys.getenv("CHATWORK_API_TOKEN"), to_df = FALSE)
}
\arguments{
\item{api_token}{your full ChatWork API token}

\item{to_df}{whether to convert the return value to a data frame. default is FALSE.}
}
\description{
This function is used to get information about chat rooms you own
}
\examples{
chatr_rooms_get()
}
