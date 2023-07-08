import xml.etree.ElementTree as ET
import sys

def combine_circuits(input_files, output_file):
    # Parse the first file to establish base tree and root
    base_tree = ET.parse(input_files[0])
    base_root = base_tree.getroot()

    # Hold a list of existing circuit names to prevent duplicates
    existing_circuits = [circuit.get('name') for circuit in base_root.findall('circuit')]

    for file_name in input_files[1:]:
        # Parse each subsequent file
        tree = ET.parse(file_name)
        root = tree.getroot()

        # Iterate over all circuits in the current file
        for circuit in root.findall('circuit'):
            # If circuit not already in base file, append it
            if circuit.get('name') not in existing_circuits:
                base_root.append(circuit)
                existing_circuits.append(circuit.get('name'))

    # Finally, write the new combined project file
    base_tree.write(output_file)

# Usage:
# python script.py file1.xml file2.xml ... output.xml
# sys.argv[0] is the script name
# sys.argv[-1] is the last argument, which we'll treat as the output file
# sys.argv[1:-1] are the input files
if len(sys.argv) < 3:
    print("Usage: python script.py file1.xml file2.xml ... output.xml")
else:
    input_files = sys.argv[1:-1]
    output_file = sys.argv[-1]
    combine_circuits(input_files, output_file)
