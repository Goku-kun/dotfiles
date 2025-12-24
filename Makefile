# setup neovim and alacritty config by copying from this repo to the appropriate locations


NVIM_SRC_DIR := ./nvim
NVIM_DEST_DIR := $(HOME)/.config/nvim

ALACRITTY_SRC_DIR := ./alacritty
ALACRITTY_DEST_DIR := $(HOME)/.config/alacritty


ZSH_REPO_FILE := ./zsh/.zshrc
ZSH_HOME_FILE := $(HOME)/.zshrc



.PHONY: all setup_nvim setup_alacritty
all: setup_nvim setup_alacritty

setup_nvim:
	mkdir -p $(NVIM_DEST_DIR)
	cp -r $(NVIM_SRC_DIR)/* $(NVIM_DEST_DIR)/
	@echo "Neovim configuration copied to $(NVIM_DEST_DIR)"
setup_alacritty:
	mkdir -p $(ALACRITTY_DEST_DIR)
	cp -r $(ALACRITTY_SRC_DIR)/* $(ALACRITTY_DEST_DIR)/
	@echo "Alacritty configuration copied to $(ALACRITTY_DEST_DIR)"
setup_zshrc: 
	@echo "Copying from $(ZSH_REPO_FILE) $(ZSH_HOME_FILE)"
	cp $(ZSH_REPO_FILE) $(ZSH_HOME_FILE)
	@echo "Copied from $(ZSH_REPO_FILE) $(ZSH_HOME_FILE)"
install_nvim_debian_root: setup_nvim
	@echo "Installing Neovim on Debian as root..."
	apt install ninja-build gettext cmake curl build-essential git
	git clone https://github.com/neovim/neovim
	cd neovim && make CMAKE_BUILD_TYPE=Release
	cd neovim && make install
	nvim --version
install_nvim_debian: setup_nvim
	@echo "Installing Neovim on Debian..."
	sudo apt install ninja-build gettext cmake curl build-essential git
    git clone https://github.com/neovim/neovim
	cd neovim && make CMAKE_BUILD_TYPE=Release
	cd neovim && make install
	nvim --version
install_nvim_mac: setup_nvim
	@echo "Installing Neovim via Homebrew..."
	brew install neovim
	nvim --version
install_alacritty_mac: setup_alacritty
	@echo "Installing Alacritty via Homebrew..."
	# go to alacritty github page to get the latest installation instructions
	open "https://github.com/alacritty/alacritty/releases"
clean_nvim:
	rm -rf $(NVIM_DEST_DIR)/*
	@echo "Neovim configuration files removed from $(NVIM_DEST_DIR)"
clean_alacritty:
	rm -rf $(ALACRITTY_DEST_DIR)/*
	@echo "Alacritty configuration files removed from $(ALACRITTY_DEST_DIR)"
clean: clean_nvim clean_alacritty
	@echo "Configuration files removed from $(NVIM_DEST_DIR) and $(ALACRITTY_DEST_DIR)"
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
reverse_zshrc:
	@echo "Copying from $(ZSH_HOME_FILE) to $(ZSH_REPO_FILE)"
	cp $(ZSH_HOME_FILE) $(ZSH_REPO_FILE)
	@echo ".zshrc configuration copied to $(ZSH_REPO_FILE)"

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
	@echo "  install_nvim_mac  - Install Neovim on macOS using Homebrew"
	@echo "  install_alacritty_mac - Install Alacritty on macOS by visting the GitHub releases page"
	@echo "  setup_nvim       	- Set up Neovim configuration"
	@echo "  setup_alacritty  	- Set up Alacritty configuration"
	@echo "  reverse_nvim 		- Copy Neovim configuration back to source directory"
	@echo "  reverse_alacritty  - Copy Alacritty configuration back to source directory"
	@echo "  clean      		- Remove configuration files"
	@echo "  status     		- Show the status of configurations"
	@echo "  help       		- Show this help message"
.DEFAULT_GOAL := help

# End of Makefile

