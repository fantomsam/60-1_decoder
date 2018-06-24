# vhdl files
FILES = source/*
VHDLEX = .vhdl

# testbench
TESTBENCHPATH = testbench/${TESTBENCHFILE}$(VHDLEX)
TESTBENCHFILE = ${TESTBENCH}_tb
TESTBENCH=speed_counter

#GHDL CONFIG
GHDL_CMD = ghdl
GHDL_FLAGS  = --ieee=synopsys -fexplicit --std=08

SIMDIR = simulation
STOP_TIME = 7000ms
# Simulation break condition
#GHDL_SIM_OPT = --assert-level=error
GHDL_SIM_OPT = --stop-time=$(STOP_TIME)

WAVEFORM_VIEWER = gtkwave

.PHONY: clean

all: clean make run

syntax:
	@$(GHDL_CMD) -s $(GHDL_FLAGS) $(TESTBENCHPATH) $(FILES)
  
make:
ifeq ($(strip $(TESTBENCH)),)
	@echo "TESTBENCH not set. Use TESTBENCH=<value> to set it."
	@exit 1
endif

	@mkdir simulation #-p
	@$(GHDL_CMD) -i $(GHDL_FLAGS) --workdir=simulation --work=work $(TESTBENCHPATH) $(FILES)
	@$(GHDL_CMD) -m $(GHDL_FLAGS) --workdir=simulation --work=work $(TESTBENCHFILE)

run:
	@$(GHDL_CMD) -r $(GHDL_FLAGS) --workdir=simulation $(TESTBENCHFILE) --vcd=$(SIMDIR)/$(TESTBENCHFILE).vcd $(GHDL_SIM_OPT)

view:
	@$(WAVEFORM_VIEWER) $(SIMDIR)/$(TESTBENCHFILE).vcd > /dev/null 2>&1 &

clean:
	@rm -rf $(SIMDIR) *.cf

