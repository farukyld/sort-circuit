tunnel_names = [
    "wait_aw_ready_or_w_ready",
    "complete_w_wait_aw_ready",
    "send_addr_and_data",
    "wait_b_valid",
    "complete_aw",
    "process_b_resp",
    "complete_w",
    "complete_aw_and_w",
    "idle",
    "complete_aw_wait_w_ready",

    "gen_wait_aw_ready_or_w_ready",
    "gen_complete_w_wait_aw_ready",
    "gen_send_addr_and_data",
    "gen_wait_b_valid",
    "gen_complete_aw",
    "gen_process_b_resp",
    "gen_complete_w",
    "gen_complete_aw_and_w",
    "gen_idle",
    "gen_complete_aw_wait_w_ready",

]

first_x_pos = 490
first_y_pos = 1500

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
