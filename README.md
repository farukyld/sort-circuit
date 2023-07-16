# sort-circuit
an RTL circuit that sorts the integer values in its register file
## purpose
to practice hlsm design, and bus protocols.
## how to run

after cloning the repo into your local by
```bash
git clone "https://github.com/farukyld/sort-circuit"
cd "sort-circuit"
```

you will be able to open [.circ files](https://github.com/farukyld/sort-circuit/tree/main/logisim_files) with [logisim-evolution](https://github.com/logisim-evolution/logisim-evolution/releases)

to open sort_circuit.circ

```bash
path/to/where/you/installed/logisim-evolution.exe "logisim_files/sort_circuit.circ"
```

when you type the above line, logisim is going to want you to specify the memory_module library via a dialog box, you should select the memory_module.circ file.



### the [circuit generator](https://github.com/faruk.yld/sort-circuit/python_scripts/logisim_circuit_generator/) script(s)
 you should have a python interpreter that provides the packages given in [requirements.txt](https://github.com/faruk.yld/sort-circuit/python_scripts/logisim_circuit_generator/requirements.txt) in that folder.

you can do it by:


```bash
cd python_scripts/logisim_circuit_generator

python3 -m venv virtual_environment_name
# above line will create an empty virtual environment
# under a folder with provided name

source virtual_environment_name/bin/activate

python3 -m pip install -r requirements.txt
# this line will add packages specified
# inside requirements.txt into your newly created virtual environment

```


in powershell
```powershell
cd python_scripts/logisim_circuit_generator

python -m venv virtual_environment_name
# above line will create an empty virtual environment 
# under a folder with provided name

. virtual_environment_name/Scripts/Activate.ps1

python -m pip install -r requirements.txt
# this line will add packages specified 
# inside requirements.txt into your newly created virtual environment
```

### the [state name extractor](https://github.com/faruk.yld/sort-circuit/python_scripts/state_name_extractor/) script(s)
 you should have a python interpreter that provides the packages given in [requirements.txt](https://github.com/faruk.yld/sort-circuit/python_scripts/state_name_extractor/requirements.txt) in that folder.

you can do it by:

**--note: we assumed that state names are written inside ellipses--**
```bash
cd python_scripts/state_name_extractor

python3 -m venv virtual_environment_name
# above line will create an empty virtual environment
# under a folder with provided name

source virtual_environment_name/bin/activate

python3 -m pip install -r requirements.txt
# this line will add packages specified
# inside requirements.txt into your newly created virtual environment

```


in powershell
```powershell
cd python_scripts/logisim_circuit_generator

python -m venv virtual_environment_name
# above line will create an empty virtual environment 
# under a folder with provided name

. virtual_environment_name/Scripts/Activate.ps1

python -m pip install -r requirements.txt
# this line will add packages specified 
# inside requirements.txt into your newly created virtual environment
```