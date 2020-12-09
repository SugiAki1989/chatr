# chatr

<!-- badges: start -->
<!-- badges: end -->

This package is based on slackr and made for ChatWork. A package chatr to send text and R code to ChatWork room.

## Installation

You can install the development version of chatr from [GitHub](https://github.com/SugiAki1989/chatr) with:

``` r
# install.packages("remotes")
remotes::install_github("SugiAki1989/chatr")

library(chatr)
```

## Setup

This is a basic example which shows you how to solve a common problem:

The `chatr_setup()` function reads values from the configuration file(config.yml) from the specified directory. As shown below, ChatWork API token and roomid are described in the configuration file.

``` r
default:
  api_token: "xxxxxxxxxxxxxxxxxxxxxx"
  roomid: "123456789"
```

Execute the function with the configuration file path. In this version you can not write configurations in function directly. So you have to set configuration by `chatr_setup()`.

``` r
chatr_setup(config_file_path = "~/rproject_file/config.yml")
```

## Usage

If you want to send text, set `code = FALSE` and execute the function.

``` r
chatr(code = FALSE, "Calculation Done!")
```

If you want to send Rcode and eval it, set `code = TRUE` and execute the function. In this case, the text is enclosed by code tag.

``` r
chatr(code = TRUE,
  set.seed(1989),
  x <- rnorm(10),
  y <- rnorm(10),
  fit <- lm(y ~ x),
  summary(fit))
```
