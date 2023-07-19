import subprocess
import random
import sys
import os

def generate_memfile(filename, size, word_width):
    with open(filename, 'w') as f:
        for _ in range(size):
            value = random.getrandbits(word_width)
            f.write(f"{value:0{word_width}b}\n")

def compile_verilog(files):
    cmd = ['iverilog', '-o', 'a.out', *files]
    subprocess.run(cmd, check=True)

def run_simulation():
    cmd = ['vvp', 'a.out']
    subprocess.run(cmd, check=True)

def main():
    if len(sys.argv) < 3:
        print(f'Usage: python {sys.argv[0]} [--temp_mem | -t] <verilog_files> <vcd file>')
        sys.exit(1)

    temp_mem = False
    if sys.argv[1] in ['--temp_mem', '-t']:
        temp_mem = True
        del sys.argv[1]
    
    if len(sys.argv) < 2:
        print(f'Usage: python {sys.argv[0]} [--temp_mem | -t] <verilog_files>')
        sys.exit(1)

    memfile = "initial_ram_state.mem"
    vcd_file = sys.argv[-1]
    verilog_files = sys.argv[1:-1]
    ADDR_WDTH = 4
    DATA_WDTH = 32


    generate_memfile(memfile, size=2**ADDR_WDTH, word_width=DATA_WDTH)
    compile_verilog(verilog_files)
    run_simulation(vcd_file)

    # Clean up
    os.remove('a.out')
    if temp_mem:
        os.remove(memfile)

if __name__ == "__main__":
    main()
