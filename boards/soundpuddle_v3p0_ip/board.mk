################################################################################
# Board makefile                                                               #
#                                                                              #
# This file provides:                                                          #
# - BOARD_PCF           Board pin assignment                                   #
################################################################################

# --- DIRECTORIES ------------------------------------------------------------ #

BOARD_DIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

# --- INITIALIZATION --------------------------------------------------------- #

BOARD_PCF         := $(BOARD_DIR)/ice40.pcf
BOARD_TEST        := $(BOARD_DIR)/full_test.v
