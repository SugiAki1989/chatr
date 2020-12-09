chatr_setup(config_file_path = '/Users/aki/Documents/chatr/config.yml')

# https://enadgltk5u4u.x.pipedream.net

r <- GET("https://enadgltk5u4u.x.pipedream.net",
         query = list(key1 = "value1", key2 = "value2"))

library(httr)
r <- GET("http://httpbin.org/get")
r


httr::http_status(r)
# $category
# [1] "Success"
#
# $reason
# [1] "OK"
#
# $message
# [1] "Success: (200) OK"


httr::message_for_status(r)
# OK (HTTP 200).

warn_for_status(r)
stop_for_status(r)

httr::status_code(r)
# [1] 200

httr::headers(r)
# $date
# [1] "Wed, 09 Dec 2020 12:03:38 GMT"
#
# $`content-type`
# [1] "application/json"
#
# $`content-length`
# [1] "365"
#
# $connection
# [1] "keep-alive"
#
# $server
# [1] "gunicorn/19.9.0"
#
# $`access-control-allow-origin`
# [1] "*"
#
# $`access-control-allow-credentials`
# [1] "true"
#
# attr(,"class")
# [1] "insensitive" "list"

httr::content(x = r, as = "parsed", encoding = 'utf-8')
# $args
# named list()
#
# $headers
# $headers$Accept
# [1] "application/json, text/xml, application/xml, */*"
#
# $headers$`Accept-Encoding`
# [1] "deflate, gzip"
#
# $headers$Host
# [1] "httpbin.org"
#
# $headers$`User-Agent`
# [1] "libcurl/7.64.1 r-curl/4.3 httr/1.4.2"
#
# $headers$`X-Amzn-Trace-Id`
# [1] "Root=1-5fd0bd1a-643a71ce43ba08806075b248"
#
#
# $origin
# [1] "160.86.161.89"
#
# $url
# [1] "http://httpbin.org/get"

httr::content(x = r, type = 'text', encoding = 'utf-8')
# [1] "{\n  \"args\": {}, \n  \"headers\": {\n
# \"Accept\": \"application/json, text/xml, application/xml, */*\", \n
# \"Accept-Encoding\": \"deflate, gzip\", \n
# \"Host\": \"httpbin.org\", \n
# \"User-Agent\": \"libcurl/7.64.1 r-curl/4.3 httr/1.4.2\", \n
# \"X-Amzn-Trace-Id\": \"Root=1-5fd0bd1a-643a71ce43ba08806075b248\"\n
# }, \n  \"origin\": \"160.86.161.89\", \n
# \"url\": \"http://httpbin.org/get\"\n}\n"


r <- GET("http://httpbin.org/cookies/set", query = list(a = 1, b = 2, c = 3))
cookies(r)

#        domain  flag path secure expiration name value
# 1 httpbin.org FALSE    /  FALSE       <NA>    a     1
# 2 httpbin.org FALSE    /  FALSE       <NA>    b     2
# 3 httpbin.org FALSE    /  FALSE       <NA>    c     3

r <- GET("http://httpbin.org/cookies/set", query = list(d = 4))
cookies(r)
#        domain  flag path secure expiration name value
# 1 httpbin.org FALSE    /  FALSE       <NA>    a     1
# 2 httpbin.org FALSE    /  FALSE       <NA>    b     1
# 3 httpbin.org FALSE    /  FALSE       <NA>    c     3
# 4 httpbin.org FALSE    /  FALSE       <NA>    d     4




r <- GET("http://httpbin.org/get",
         query = list(key1 = "value1", key2 = "value2"))
content(r)$args
# $key1
# [1] "value1"
#
# $key2
# [1] "value2"


r <- GET("http://httpbin.org/get", add_headers(Name = "Hadley"))
str(content(r)$headers)
# List of 7
# $ Accept         : chr "application/json, text/xml, application/xml, */*"
# $ Accept-Encoding: chr "deflate, gzip"
# $ Cookie         : chr "d=4; c=3; b=1; a=1"
# $ Host           : chr "httpbin.org"
# $ Name           : chr "Hadley"
# $ User-Agent     : chr "libcurl/7.64.1 r-curl/4.3 httr/1.4.2"
# $ X-Amzn-Trace-Id: chr "Root=1-5fd0c443-2290c5b10e1dd6473ef5b511"


r <- GET("http://httpbin.org/cookies", set_cookies("MeWant" = "cookies"))
content(r)$cookies
# $MeWant
# [1] "cookies"
#
# $a
# [1] "1"
#
# $b
# [1] "1"
#
# $c
# [1] "3"
#
# $d
# [1] "4"


r1 <- POST("http://httpbin.org/post", body = list(a = 1, b = 2, c = 3), encode = "form")
r1

# POST("http://httpbin.org/post", body = list(a = 1, b = 2, c = 3), encode = "json")
r2 <- POST("http://httpbin.org/post", body = list(a = 1, b = 2, c = 3), encode = "json")
r2

POST("https://enadgltk5u4u.x.pipedream.net/post", body = list(a = 1, b = 2, c = 3))


POST(url, body = upload_file("mypath.txt"))
POST(url, body = list(x = upload_file("mypath.txt")))


