import xml.etree.ElementTree as ET
import sys
import os

def parse_xml(xml_file, chosen_circuit=None):
    tree = ET.parse(xml_file)
    root = tree.getroot()

    circuits = {}
    for circuit in root.iter('circuit'):
        module_name = circuit.get('name')
        if chosen_circuit is not None and module_name != chosen_circuit:
            continue
        
        inputs = []
        outputs = []
        for comp in circuit.iter('comp'):
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

        if module_name not in circuits: 
            circuits[module_name] = (inputs, outputs)

    if chosen_circuit is None:
        return circuits
    else:
        return circuits[chosen_circuit]

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

def write_to_file(content, file_path):
    with open(file_path, 'w') as f:
        f.write(content)

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python3 script_name.py logisim_file verilog_file [circuit_name]")
        sys.exit(1)

    xml_file = sys.argv[1]
    verilog_file = sys.argv[2]
    chosen_circuit = sys.argv[3] if len(sys.argv) > 3 else None

    inputs_outputs_module_name = parse_xml(xml_file, chosen_circuit)
    verilog_module = generate_verilog(*inputs_outputs_module_name)
    write_to_file(verilog_module, verilog_file)
