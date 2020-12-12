t <- chatr_room_get_messages(force = 0)
test <- head(t, 2)
test
str(test)
# List of 2
# $ :List of 5
# ..$ message_id : chr "1389692260693676032"
# ..$ account    :List of 3
# .. ..$ account_id      : int 4262159
# .. ..$ name            : chr "Test user"
# .. ..$ avatar_image_url: chr "https://appdata.chatwork.com/avatar/5118/5118806.rsz.png"
# ..$ body       : chr "あいうえお"
# ..$ send_time  : int 1607802054
# ..$ update_time: int 0
# $ :List of 5
# ..$ message_id : chr "1389692279106625536"
# ..$ account    :List of 3
# .. ..$ account_id      : int 4262159
# .. ..$ name            : chr "Test user"
# .. ..$ avatar_image_url: chr "https://appdata.chatwork.com/avatar/5118/5118806.rsz.png"
# ..$ body       : chr "かきくけこ"
# ..$ send_time  : int 1607802058
# ..$ update_time: int 0

test %>% purrr::map("message_id")

test %>% purrr::map("account") %>% purrr::map("account_id")
test %>% purrr::map(c("account", "account_id"))

test %>% purrr::map("account") %>% purrr::map("name")
test %>% purrr::map("account") %>% purrr::map("avatar_image_url")


# - -----------------------------------------------------------------------
test %>% purrr::map(`[`, c("message_id", "body", "send_time", "update_time"))
test %>% purrr::map("account")
test %>% purrr::map(c("account", "name"))
test %>% purrr::map(c("account", "avatar_image_url"))

# test %>% purrr::map(`[`, c("message_id", "body", "send_time", "update_time"))
# test %>% purrr::map(.x = ., .f = `[`, c("message_id", "body", "send_time", "update_time"))
test %>% purrr::map(.x = ., .f = function(x){`[`(x, c("message_id", "body", "send_time", "update_time"))})

# - -----------------------------------------------------------------------
test %>% purrr::map(`[`, c("message_id", "body", "send_time", "update_time")) %>% purrr::map_dfr(.x = ., .f = function(x){bind_rows(x)})
test %>% purrr::map("account") %>% purrr::map_dfr(.x = ., .f = function(x){bind_rows(x)})


`+`(1,2)
