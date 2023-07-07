tunnel_names = [
    "initial",
    "write_random_number",
    "wait_submodule_return",
    "incr_i",
    "check_i",
    "done",

    "gen_initial",
    "gen_write_random_number",
    "gen_wait_submodule_return",
    "gen_incr_i",
    "gen_check_i",
    "gen_done",

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
