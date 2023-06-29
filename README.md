# sort-circuit
an RTL circuit that sorts the integer values in its register file
## purpose
to practice hlsm design, and bus protocols.
## how to run
you will be able to open .circ files with [logisim-evolution](https://github.com/logisim-evolution/logisim-evolution/releases)

to run the python scripts under logisim_circuit_generator_python_scripts folder, you should have a python interpreter that provides the packages given in [requirements.txt](https://github.com/faruk.yld/sort-circuit/requirements.txt)

you can do it by:


```bash
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
python -m venv virtual_environment_name
# above line will create an empty virtual environment 
# under a folder with provided name

. virtual_environment_name/Scripts/Activate.ps1

python -m pip install -r requirements.txt
# this line will add packages specified 
# inside requirements.txt into your newly created virtual environment
```
