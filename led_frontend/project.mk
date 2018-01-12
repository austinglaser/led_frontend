################################################################################
# Project makefile                                                             #
#                                                                              #
# This file provides:                                                          #
# - PROJECT_VSRC          Project verilog files                                #
# - PROJECT_TEST          Project verilog files                                #
################################################################################

# --- DIRECTORIES ------------------------------------------------------------ #

PROJECT_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

# --- INITIALIZATION --------------------------------------------------------- #

PROJECT_VSRC :=
PROJECT_VSRC += $(PROJECT_DIR)/top.v
#PROJECT_VSRC += $(PROJECT_DIR)/test_top.v
PROJECT_VSRC += $(PROJECT_DIR)/bank.v
PROJECT_VSRC += $(PROJECT_DIR)/divider.v

PROJECT_TEST :=
PROJECT_TEST += $(PROJECT_DIR)/bank_test.v
