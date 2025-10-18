# setup neovim and alacritty config by copying from this repo to the appropriate locations


NVIM_SRC_DIR := ./nvim
NVIM_DEST_DIR := $(HOME)/.config/nvim

ALACRITTY_SRC_DIR := ./alacritty
ALACRITTY_DEST_DIR := $(HOME)/.config/alacritty


.PHONY: all nvim alacritty
all: nvim alacritty

nvim:
	mkdir -p $(NVIM_DEST_DIR)
	cp -r $(NVIM_SRC_DIR)/* $(NVIM_DEST_DIR)/
	echo "Neovim configuration copied to $(NVIM_DEST_DIR)"
alacritty:
	mkdir -p $(ALACRITTY_DEST_DIR)
	cp -r $(ALACRITTY_SRC_DIR)/* $(ALACRITTY_DEST_DIR)/
	echo "Alacritty configuration copied to $(ALACRITTY_DEST_DIR)"
clean:
	rm -rf $(NVIM_DEST_DIR)/*
	rm -rf $(ALACRITTY_DEST_DIR)/*
	echo "Configuration files removed from $(NVIM_DEST_DIR) and $(ALACRITTY_DEST_DIR)"
reverse_nvim:
	@echo "Reversing Neovim configuration update."
	mkdir -p $(NVIM_SRC_DIR)
	cp -r $(NVIM_DEST_DIR)/* $(NVIM_SRC_DIR)/
	echo "Neovim configuration copied back to $(NVIM_SRC_DIR)"
reverse_alacritty:
	@echo "Reversing Alacritty configuration update."
	mkdir -p $(ALACRITTY_SRC_DIR)
	cp -r $(ALACRITTY_DEST_DIR)/* $(ALACRITTY_SRC_DIR)/
	echo "Alacritty configuration copied back to $(ALACRITTY_SRC_DIR)"
# install: all
# 	# Additional installation steps can be added here if needed
# 	@echo "Installation complete."
# uninstall: clean
# 	# Additional uninstallation steps can be added here if needed
# 	@echo "Uninstallation complete."
# update: all
# 	@echo "Configuration files updated."
status:
	@echo "Neovim configuration is located at $(NVIM_DEST_DIR)"
	@echo "Alacritty configuration is located at $(ALACRITTY_DEST_DIR)"
help:
	@echo "# Makefile commands:"
	@echo "Usage: make [target]"
	@echo "  all        		- Set up both Neovim and Alacritty configurations"
	@echo "  nvim       		- Set up Neovim configuration"
	@echo "  alacritty  		- Set up Alacritty configuration"
	@echo "  reverse_nvim 		- Copy Neovim configuration back to source directory"
	@echo "  reverse_alacritty  - Copy Alacritty configuration back to source directory"
	@echo "  clean      		- Remove configuration files"
	@echo "  status     		- Show the status of configurations"
	@echo "  help       		- Show this help message"
.DEFAULT_GOAL := help

# End of Makefile

