import xml.etree.ElementTree as ET
from html import unescape
from bs4 import BeautifulSoup
import sys

def extract_state_names(file_path):
    # Parse XML
    tree = ET.parse(file_path)
    root = tree.getroot()

    # Look for the mxCell tags where style starts with 'ellipse'
    state_names = []
    for mxCell in root.iter('mxCell'):
        style = mxCell.get('style', '')
        value = mxCell.get('value', '')
        if style.startswith('ellipse') and value:
            # Unescape HTML entities (like &lt; for <) and then extract text from font tag
            html_content = unescape(value)
            soup = BeautifulSoup(html_content, "html.parser")
            state_name = soup.get_text().strip()
            state_names.append(state_name)

    # Print and mark duplicates
    state_counts = {}
    for state_name in state_names:
        state_counts[state_name] = state_counts.get(state_name, 0) + 1
        print(f"State: {state_name}")
        if state_counts[state_name] > 1:
            print(f"Duplicate: {state_name}")
    print(f"total of {len(state_names)} states")
    
if __name__ == "__main__":
    # Check if the file path is provided as a command line argument
    if len(sys.argv) != 2:
        print(f"Usage: python {sys.argv[0]} path_to_drawio_xml_file")
        sys.exit(1)

    # Extract state names from the Draw.io XML file
    file_path = sys.argv[1]
    extract_state_names(file_path)
