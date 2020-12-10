#' Send txet and R code to ChatWork room.
#' @description This function is used to send a text or an R code to the specified roomid.
#' @param ... expressions to be sent to ChatWork
#' @param api_token your full ChatWork API token
#' @param roomid which room to post the text and R code
#' @param code Whether to enclose text and R code in [code][/code] tags or not
#' @examples
#' chatr(code = TRUE,
#' set.seed(1989),
#' x <- rnorm(10),
#' y <- rnorm(10),
#' f <- lm(y ~ x),
#' summary(f))
#'
#' chatr(code = FALSE, "Hello ChatWork!")
#' @import httr
#' @export

# /------------------------------------------------------------------------------------------
# From: https://developer.chatwork.com/ja/endpoint_rooms.html#POST-rooms-room_id-messages
# Method: POST
# Endpoint: /rooms/{room_id}/messages
# Description: チャットに新しいメッセージを追加
# How:
#   curl -X POST -H "X-ChatWorkToken: {my_api_token}" \
#        -d "body=Hello+Chatwork%21&self_unread=0" \
#        "https://api.chatwork.com/v2/rooms/{room_id}/messages"
# Response:
# {
#   "message_id": 1234
# }
# ------------------------------------------------------------------------------------------/

chatr <- function(...,
                  code = FALSE,
                  api_token = Sys.getenv("CHATWORK_API_TOKEN"),
                  roomid = Sys.getenv("CHATWORK_ROOMID")) {

  if (api_token == "") {
    stop("`api_token` not found. Did you forget to call chatr_setup()?")
  }

  if (roomid == "") {
    stop("`roomid` not found. Did you forget to call chatr_setup()?")
  }

  if (!missing(...)) {
    # get the arglist
    args <- as.list(substitute(list(...))[-1L])

    # setup in-memory sink
    rval <- NULL
    file <- textConnection(object = "rval", open = "w", local = TRUE)
    sink(file)

    # how we'll eval expressions
    evalVis <-function(expr){
      withVisible(eval(expr, parent.frame()))
    }

    # for each expression
    for (i in seq_along(args)) {
      expr <- args[[i]]

      tmp <- switch(
        mode(expr),
        # if it's actually an expresison, iterate over it
        expression = {
          cat(sprintf("> %s\n", deparse(expr)))
          lapply(expr, evalVis)
        },
        # if it's a call or a name, eval, printing run output as if in console
        call = ,
        name = {
          cat(sprintf("> %s\n", deparse(expr)))
          list(evalVis(expr))
        },
        # if pretty much anything else (i.e. a bare value) just output it
        integer = ,
        double = ,
        complex = ,
        raw = ,
        logical = ,
        numeric = cat(sprintf("%s\n\n", as.character(expr))),
        character = cat(sprintf("%s\n\n", expr)),
        stop("mode of argument not handled at present by chatr")
      )
      for (item in tmp) {
        if (item$visible) {
          print(item$value)
          cat("\n")
        }
      }
    }

    sink()
    close(file)

    # convert character vector
    output <- paste0(rval, collapse = "\n")

    end_point_url <- paste0(CHATWORK_API_URL, "rooms/", roomid, "/messages")

    if (code == TRUE) {
      output <- sprintf("[code]%s[/code]", output)
    }

    # `self_unread` arg 1: Unread, 0(default): Already read
    response <- httr::POST(
      url = end_point_url,
      config = httr::add_headers(`X-ChatWorkToken` = api_token),
      body = list(body = output,
                  self_unread = 0)
    )

    # REVIEW:
    # response$message_id <- as.character(httr::content(x = response, as = "parsed"))
  }

  return(response)
}


