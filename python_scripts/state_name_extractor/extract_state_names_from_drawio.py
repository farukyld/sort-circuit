import xml.etree.ElementTree as ET
from html import unescape
from bs4 import BeautifulSoup

# Parse XML
tree = ET.parse('path_to_your_drawio_file.xml')
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

print("\n".join([str(name) for name in state_names]))

# Print and mark duplicates
state_counts = {}
for state_name in state_names:
    state_counts[state_name] = state_counts.get(state_name, 0) + 1
    print(f"State: {state_name}")
    if state_counts[state_name] > 1:
        print(f"Duplicate: {state_name}")


