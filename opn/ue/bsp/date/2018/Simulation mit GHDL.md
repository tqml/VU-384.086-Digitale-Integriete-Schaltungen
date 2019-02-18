# VHDL Simulation with GHDL

## Installation: 
- Install GHDl (use https://github.com/ghdl/ghdl)
- Install GtkWaveview


## Run

```bash
# Analyze files
ghdl -a --std=08 FILE(s)
# Run a unit (most likely a testbench) and export data to a waveview file
ghdl --elab-run UNIT_NAME --vcd=WAVEVIEWFILE.vcd

```


Um beispielsweise Beispiel Nr 3 zu kompilieren und zu simulieren, kann folgender Befehler ausgeführt werden.

```bash
ghdl -a --std=08 tb_register_file.vhdl register_file.vhdl register_file_beh.vhdl ; ghdl --elab-run --std=08 tb_register_file --vcd=wave.vcd
```