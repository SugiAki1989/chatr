# chatr_room_post(
#       description = "For Project X you can use it.",
#       icon_preset = "meeting",
#       link = 0,
#       link_need_acceptance = 0,
#       members_admin_ids = c("4262159","4377694"),
#       members_member_ids = NULL,
#       members_readonly_ids = NULL,
#       name = "Project X"
#       )

chatr_room_put(
      description = NULL,
      name = NULL
      )


chatr_room_delete(room_id = "207339015",
                  confirm = TRUE,
                  action_type = "delete")


chatr_room_put_members(
    members_admin_ids = c("4262159","4377694"),
    members_member_ids = NULL,
    members_readonly_ids = NULL,
    )


if (force %nin% c(0, 1)) {
  stop("`force` must be 0 or 1.")
}


chatr_room_put_message
chatr_room_delete_message(message_id = "1389683781857705984", confirm = TRUE)
chatr_room_get_tasks(assigned_by_account_id = "4377694", status = "open")
chatr_room_get_tasks(status = "open")


chatr_room_put_task(task_id = "197487623", body = "open")
