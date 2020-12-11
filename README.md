# chatr

<!-- badges: start -->
<!-- badges: end -->

chatr package is a R wrapper for sending texts, R scripts and images to chat rooms to get, update and delete chat room information and tasks from Chatwork’s Web API.

## Installation

You can install the development version of chatr from [GitHub](https://github.com/SugiAki1989/chatr) with:

``` r
# install.packages("remotes")
remotes::install_github("SugiAki1989/chatr")

library(chatr)
```

## Setup

This is a basic example which shows you how to solve a common problem:

First, get the API Token from the "Service Linkage" page in your Chatwork account. Then use `chatr_setup()` to set the API Token to the R environment variable.

The `chatr_setup()` function reads values from the configuration file(config.yml) from the specified directory. As shown below, API token and roomid are described in the configuration file.

``` r
default:
  api_token: "xxxxxxxxxxxxxxxxxxxxxx"
  roomid: "123456789"
  
```

Execute the function with the configuration file path. I'm assuming that a particular account id will access a particular chat room id, but if you want to access other chat rooms as well, override the `room_id` argument in the each function. In this case, `room_id` is plaintext and is not recommended.

``` r
chatr_setup(config_file_path = "~/path_to_file/config.yml")
```

## Basic Usage
### Send text or Rscript to chat room
If you want to send text, set `code = FALSE` and execute `chatr()`.

``` r
chatr(code = FALSE, "Long Long Loooooong Calculation Done!!")
```

If you want to send Rscript and eval it, set `code = TRUE` and execute the function. In this case, the text is enclosed by code tag(`[code]Rscript[/code]`).

``` r
chatr(code = TRUE,
  set.seed(1989),
  x <- rnorm(100),
  y <- rnorm(100),
  fit <- lm(y ~ x),
  summary(fit))
```

### Send image file to chat room
If you want to send image file, execute `chatr_room_post_file()` with `message` and `file_path`.

```R:R
chatr_room_post_file(file_message = "Hello Chatwork image.", file_path = "~/path_to_image/image.png")
```
