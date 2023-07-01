import xml.etree.ElementTree as ET
import sys
from pyverilog.vparser.parser import parse
from pyverilog.vparser.ast import (
        Source,
        Description,
        ModuleDef,
        Paramlist,
        Portlist,
        Port,
        Width,
        Decl,
        Parameter,
        Rvalue,
        Minus,
        Identifier,

        )


def parse_verilog_header(filename):
    # Parse Verilog file using pyverilog
    ast, _ = parse([filename])
    
    # Extract module name, input, and output ports
    children_tuple = ast.children()
    desc:Description = children_tuple[0]
    module:ModuleDef = desc.definitions[0]

    paramDict = {}
    param_list = [decl.children()[0] for decl in module.paramlist.params]
    for parameter in param_list:
        paramDict[parameter.name] = int(parameter.value.var.value)

    inputs = []
    outputs = []
    for item in [item.first for item in module.portlist.ports]:
        item = item
        width = item.width
        pin_width = 1
        if width and isinstance(width.msb, Minus) and isinstance(width.msb.left, Identifier):
            msbVal = paramDict[width.msb.left.name] - int(width.msb.right.value)
            lsbVal = int(width.lsb.value)
            pin_width = msbVal-lsbVal+1
            
        pin_info = (item.name, pin_width)

        if item.__class__.__name__ == 'Input':
            inputs.append(pin_info)
        if item.__class__.__name__ == 'Output':
            outputs.append(pin_info)

    return module.name, inputs, outputs

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
