tunnel_names = [
    "idle",
    "decide_random",
    "ar_transfer",
    "aw_transfer",
    "complete_ar",
    "register_read_data",
    "wait_r_ready",
    "output_read_data",
    "complete_r",
    "complete_aw",
    "wait_w_valid",
    "w_transfer",
    "complete_w",
    "store_reg_data",
    "wait_b_ready",
    "respond_b",
    "complete_b",

    "gen_idle",
    "gen_decide_random",
    "gen_ar_transfer",
    "gen_aw_transfer",
    "gen_complete_ar",
    "gen_register_read_data",
    "gen_wait_r_ready",
    "gen_output_read_data",
    "gen_complete_r",
    "gen_complete_aw",
    "gen_wait_w_valid",
    "gen_w_transfer",
    "gen_complete_w",
    "gen_store_reg_data",
    "gen_wait_b_ready",
    "gen_respond_b",
    "gen_complete_b",
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
