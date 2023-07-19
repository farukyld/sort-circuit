import sys
from pyverilog.vparser.parser import parse

def check_verilog_syntax(file_path):
    try:
        ast, _ = parse([file_path])
        print(f"Syntax check for {file_path} passed successfully.")
    except Exception as e:
        print(f"Syntax check for {file_path} failed.")
        print(str(e))

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Please provide a Verilog file path.")
    else:
        check_verilog_syntax(sys.argv[1])
