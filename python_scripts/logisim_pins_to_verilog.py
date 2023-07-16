import xml.etree.ElementTree as ET
import sys
import os

def parse_xml(xml_file):
    tree = ET.parse(xml_file)
    root = tree.getroot()

    inputs = []
    outputs = []
    for comp in root.iter('comp'):
        if comp.get('name') == 'Pin':
            label = None
            width = '1'
            direction = None
            for attribute in comp:
                if attribute.get('name') == 'label':
                    label = attribute.get('val')
                if attribute.get('name') == 'width':
                    width = attribute.get('val')
                if attribute.get('name') == 'output':
                    direction = attribute.get('val')

            if label is not None:
                if direction == 'true':
                    outputs.append((label, width))
                else:
                    inputs.append((label, width))
    
    module_name = None
    for circuit in root.iter('circuit'):
        module_name = circuit.get('name')

    return inputs, outputs, module_name

def generate_verilog(inputs, outputs, module_name='module_name'):
    inputs_str = ', '.join([f"input [{int(width)-1}:0] {name}" if width != '1' else f"input {name}" for name, width in inputs])
    outputs_str = ', '.join([f"output [{int(width)-1}:0] {name}" if width != '1' else f"output {name}" for name, width in outputs])
    verilog_module = f"""
module {module_name}(
{inputs_str},
{outputs_str}
);
// module body here
endmodule
    """
    return verilog_module

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 script_name.py xml_file.xml")
        sys.exit(1)
    
    xml_file = sys.argv[1]
    inputs, outputs, module_name = parse_xml(xml_file)
    if module_name is None:
        module_name = os.path.splitext(os.path.basename(xml_file))[0] # Use the file name as module name if circuit name is not found
    verilog_module = generate_verilog(inputs, outputs, module_name)
    print(verilog_module)
