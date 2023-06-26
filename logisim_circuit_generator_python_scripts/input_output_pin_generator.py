import re
import xml.etree.ElementTree as ET
import sys

def parse_verilog_header(filename):
    with open(filename, 'r') as file:
        content = file.read()

    # Regular expressions to match module name, input/output ports
    module_pattern = re.compile(r'module\s+(\w+)', re.MULTILINE)
    input_pattern = re.compile(r'input\s+(?:wire)?\s*(?:\[\s*(\d+).*?:\s*0\s*\])?\s*(\w+)', re.MULTILINE)
    output_pattern = re.compile(r'output\s+(?:wire)?\s*(?:\[\s*(\d+).*?:\s*0\s*\])?\s*(\w+)', re.MULTILINE)

    # Find module name, input, and output ports
    module_name = re.search(module_pattern, content).group(1)
    inputs = [(name, int(width) if width else 1) for width, name in re.findall(input_pattern, content)]
    outputs = [(name, int(width) if width else 1) for width, name in re.findall(output_pattern, content)]

    return module_name, inputs, outputs

def insert_circuit(logisim_file, circuit_name, inputs, outputs):
    # Parse the Logisim XML file
    tree = ET.parse(logisim_file)
    root = tree.getroot()

    # Remove existing circuit with the same name
    for circuit in root.findall('circuit'):
        if circuit.get('name') == circuit_name:
            root.remove(circuit)

    # Create a new circuit
    circuit_element = ET.SubElement(root, 'circuit', {'name': circuit_name})

    # Add pins to the new circuit
    x, y = 500, 100
    for name, width in inputs:
        pin = ET.SubElement(circuit_element, 'comp', {'lib': '0', 'loc': f'({x},{y})', 'name': 'Pin'})
        ET.SubElement(pin, 'a', {'name': 'appearance', 'val': 'NewPins'})
        ET.SubElement(pin, 'a', {'name': 'facing', 'val': 'east'})
        ET.SubElement(pin, 'a', {'name': 'label', 'val': name})
        ET.SubElement(pin, 'a', {'name': 'output', 'val': 'false'})
        ET.SubElement(pin, 'a', {'name': 'width', 'val': str(width)})
        y += 40

    x, y = 1000, 100
    for name, width in outputs:
        pin = ET.SubElement(circuit_element, 'comp', {'lib': '0', 'loc': f'({x},{y})', 'name': 'Pin'})
        ET.SubElement(pin, 'a', {'name': 'appearance', 'val': 'NewPins'})
        ET.SubElement(pin, 'a', {'name': 'facing', 'val': 'west'})
        ET.SubElement(pin, 'a', {'name': 'label', 'val': name})
        ET.SubElement(pin, 'a', {'name': 'output', 'val': 'true'})
        ET.SubElement(pin, 'a', {'name': 'width', 'val': str(width)})
        y += 40

    # Write back to file
    tree.write(logisim_file, encoding='UTF-8', xml_declaration=True)

if __name__ == "__main__":
    # Get filenames from command line arguments
    if len(sys.argv) < 3:
        print("Usage: python {} <logisim_file> <verilog_file>".format(sys.argv[0]))
        sys.exit(1)

    logisim_file = sys.argv[1]
    verilog_file = sys.argv[2]

    # Parse Verilog file
    module_name, inputs, outputs = parse_verilog_header(verilog_file)

    # Insert circuit into the Logisim file
    insert_circuit(logisim_file, module_name, inputs, outputs)

    print(f"The circuit '{module_name}' has been added to the Logisim project '{logisim_file}'.")
