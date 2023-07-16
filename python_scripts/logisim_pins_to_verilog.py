import xml.etree.ElementTree as ET
import sys
import os

def parse_xml(xml_file, chosen_circuit=None):
    tree = ET.parse(xml_file)
    root = tree.getroot()

    inputs = []
    outputs = []
    circuits = {}

    for circuit in root.iter('circuit'):
        circuit_name = circuit.get('name')
        circuits[circuit_name] = {'inputs': [], 'outputs': []}
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
                        circuits[circuit_name]['outputs'].append((label, width))
                    else:
                        circuits[circuit_name]['inputs'].append((label, width))

    if chosen_circuit is None or chosen_circuit not in circuits:
        print("Available circuits:", ', '.join(circuits.keys()))
        chosen_circuit = input("Please enter the name of the circuit to generate Verilog code for: ")
    
    inputs, outputs = circuits.get(chosen_circuit, ({}, {}))

    return inputs, outputs, chosen_circuit

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
    if len(sys.argv) < 2:
        print(f"Usage: python3 {sys.argv[0]} xml_file [circuit_name]")
        sys.exit(1)

    xml_file = sys.argv[1]
    chosen_circuit = sys.argv[2] if len(sys.argv) > 2 else None

    inputs, outputs, module_name = parse_xml(xml_file, chosen_circuit)
    verilog_module = generate_verilog(inputs, outputs, module_name)
    print(verilog_module)
