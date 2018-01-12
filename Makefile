################################################################################
# Top-level makefile                                                           #
################################################################################

# --- PROJECT ROOT DIRECTORY ------------------------------------------------- #

# Root directory is the one this makefile resides in
ROOT_DIR    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

# --- PROJECT CONFIGURATION -------------------------------------------------- #

PROJECT := led_frontend
BOARD   := soundpuddle_v3p0_ip

# --- PROJECT DIRECTORIES ---------------------------------------------------- #

BUILDDIR  := $(ROOT_DIR)/build/$(PROJECT)/$(BOARD)

MCUDIR    := $(realpath $(ROOT_DIR)/../soundpuddle_mcu)
FWDIR     := $(MCUDIR)/system/fpga/$(PROJECT)

# Directories that need to be generated
DIRS     := $(BUILDDIR) $(FWDIR)

# --- OPTIONS ---------------------------------------------------------------- #

# Delete files on failed target completion
.DELETE_ON_ERROR:

# --- PROJECT SECTIONS ------------------------------------------------------- #

PROJECT_MK := $(ROOT_DIR)/$(PROJECT)/project.mk

ifneq ("$(wildcard $(PROJECT_MK))","")
include $(PROJECT_MK)
else
$(error No project named "$(PROJECT)")
endif

BOARD_MK := $(ROOT_DIR)/boards/$(BOARD)/board.mk

ifneq ("$(wildcard $(BOARD_MK))","")
include $(BOARD_MK)
else
$(error No configuration for board "$(BOARD)")
endif

# --- SOURCE ----------------------------------------------------------------- #

VSRC   := $(PROJECT_VSRC)
SIMSRC := /usr/share/yosys/ice40/cells_sim.v

PCF    := $(BOARD_PCF)

TEST   := $(PROJECT_TEST) \
          $(BOARD_TEST)

TWRAP  := $(addsuffix _wrap.v, $(addprefix $(BUILDDIR)/, $(notdir $(TEST:.v=))))
TEXE   := $(addprefix $(BUILDDIR)/, $(notdir $(TEST:.v=.vvp)))


TRACE     := $(addprefix $(BUILDDIR)/, $(notdir $(TEST:.v=.vcd)))
ALLTRACE  := $(TRACE) \
             $(BUILDDIR)/synth.vcd $(BUILDDIR)/route.vcd

VPATH  := $(sort $(dir $(VSRC)) $(dir $(TEST)))

# --- TOOLS ------------------------------------------------------------------ #

YOSYS    := yosys
ROUTE    := arachne-pnr
TIME     := icetime
PACK     := icepack
IVERILOG := iverilog
SIM      := vvp
TVIEW    := gtkwave

# --- RULES ------------------------------------------------------------------ #

all: $(BUILDDIR)/$(PROJECT).bin

test: $(TRACE)

synth_test: $(BUILDDIR)/synth.vcd
route_test: $(BUILDDIR)/route.vcd

to_fw: $(FWDIR)/fpga_blob.bin

$(DIRS): %:
	@mkdir -p $@

$(BUILDDIR)/synth.blif: $(VSRC) $(MAKEFILE_LIST) | $(BUILDDIR)
	$(YOSYS) -v3 -l $(BUILDDIR)/synth.log -p 'synth_ice40 -top top -blif $@; write_verilog -attr2comment $(BUILDDIR)/synth.v' $(filter %.v, $^)

$(BUILDDIR)/synth.v: $(BUILDDIR)/synth.blif

$(BUILDDIR)/$(PROJECT).txt: $(BUILDDIR)/synth.blif $(MAKEFILE_LIST) | $(BUILDDIR)
	$(ROUTE) -d 8k -P tq144:4k -o $@ -p $(PCF) $<

$(BUILDDIR)/$(PROJECT).bin: $(BUILDDIR)/$(PROJECT).txt $| $(BUILDDIR)
	$(PACK) $< $@

$(FWDIR)/fpga_blob.bin: $(BUILDDIR)/$(PROJECT).bin $(MAKEFILE_LIST) | $(FWDIR)
	cp $< $@

$(TWRAP): $(BUILDDIR)/%_wrap.v: %.v $(MAKEFILE_LIST) | $(BUILDDIR)
	@echo "\`timescale 1ns/100ps"                                       >  $@
	@echo ""                                                            >> $@
	@echo "module testbench();"                                         >> $@
	@echo "initial begin"                                               >> $@
	@echo "    \$$dumpfile(\"$(BUILDDIR)/$(notdir $(<:.v=.vcd)\"));"    >> $@
	@echo "    \$$dumpvars(0, testbench);"                              >> $@
	@echo "end"                                                         >> $@
	@echo "\`include \"$<\""                                            >> $@
	@echo "endmodule"                                                   >> $@

$(BUILDDIR)/synth_wrap.v: full_test.v $(MAKEFILE_LIST) | $(BUILDDIR)
	@echo "\`timescale 1ns/100ps"                       >  $@
	@echo ""                                            >> $@
	@echo "module testbench();"                         >> $@
	@echo "initial begin"                               >> $@
	@echo "    \$$dumpfile(\"$(BUILDDIR)/synth.vcd\");" >> $@
	@echo "    \$$dumpvars(0, testbench);"              >> $@
	@echo "end"                                         >> $@
	@echo "\`include \"$<\""                            >> $@
	@echo "endmodule"                                   >> $@

$(BUILDDIR)/route_wrap.v: full_test.v $(MAKEFILE_LIST) | $(BUILDDIR)
	@echo "\`timescale 1ns/100ps"                       >  $@
	@echo ""                                            >> $@
	@echo "module testbench();"                         >> $@
	@echo "initial begin"                               >> $@
	@echo "    \$$dumpfile(\"$(BUILDDIR)/route.vcd\");" >> $@
	@echo "    \$$dumpvars(0, testbench);"              >> $@
	@echo "end"                                         >> $@
	@echo "\`include \"$<\""                            >> $@
	@echo "endmodule"                                   >> $@

$(TEXE): %.vvp: %_wrap.v $(VSRC) $(MAKEFILE_LIST) | $(BUILDDIR)
	@echo "[VER] $(<F)"
	@$(IVERILOG) $(VSRC) $(SIMSRC) $< -o $@

$(BUILDDIR)/route.v: $(BUILDDIR)/$(PROJECT).txt
	icebox_vlog -L -n top -sp $(PCF) $< > $@

$(BUILDDIR)/synth.vvp: $(BUILDDIR)/synth_wrap.v $(BUILDDIR)/synth.v
	$(IVERILOG) $^ $(SIMSRC) -o $@

$(BUILDDIR)/route.vvp: $(BUILDDIR)/route_wrap.v $(BUILDDIR)/route.v
	$(IVERILOG) $^ $(SIMSRC) -o $@

$(ALLTRACE): %.vcd: %.vvp $(MAKEFILE_LIST) | $(BUILDDIR)
	@@echo "[SIM] $(@F)"
	@$(SIM) $< -vcd

synth_sim: $(BUILDDIR)/synth.vvp
	$(SIM) $<

.PHONY: time
time: $(BUILDDIR)/$(PROJECT).txt
	$(TIME) -d hx8k -P tq144:4k -p $(PCF) $<

view-%: $(BUILDDIR)/%.vcd
	@$(TVIEW) $<

clean:
	rm -rf build
