tunnel_names = [
    "gen_wait_start",
    "gen_assign_i",
    "gen_outer_loop_check",
    "gen_done",
    "gen_read_arr_i",
    "gen_assign_elem2insert",
    "gen_assng_j",
    "gen_inner_loop_check",
    "gen_inc_i",
    "gen_read_arr_j",
    "gen_assign_elem2compare",
    "gen_check_if_correct_place",
    "gen_shift_elem2insert_left",
    "gen_shif_elem2compare_right",
    "gen_decrmt_j",
    "gen_read_function",
    "gen_wait_ar_ready",
    "gen_complete_ar",
    "gen_wait_r_valid",
    "gen_process_r_data_resp",
    "gen_return_read_fn",
    "gen_write_function",
    "gen_send_addr_and_data",
    "gen_wait_aw_ready_or_w_ready",
    "gen_complete_w_wait_aw_ready",
    "gen_complete_aw",
    "gen_complete_aw_wait_w_ready",
    "gen_complete_w",
    "gen_complete_aw_and_w",
    "gen_wait_b_valid",
    "gen_process_b_resp",
    "gen_return_write_fn",
    "gen_err",
]

first_x_pos = 490
first_y_pos = 830

x_incr = 0
y_incr = 30

n_tunnel = len(tunnel_names)

last_x_pos = first_x_pos + x_incr * (n_tunnel - 1)
last_y_pos = first_y_pos + y_incr * (n_tunnel - 1)

tunnel_y_poses = range(first_y_pos, last_y_pos + 1, y_incr)
tunnel_x_poses= [first_x_pos]*n_tunnel


format_str = """    <comp lib="0" loc="(%s,%s)" name="Tunnel">
      <a name="label" val="%s"/>
    </comp>"""

# Loop through tunnel names and positions
for x, y, name in zip(tunnel_x_poses,tunnel_y_poses, tunnel_names):
    # Format the string with x, y positions and tunnel name
    formatted_string = format_str % (x, y, name)
    # Output the formatted string
    print(formatted_string,end="")
