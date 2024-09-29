# Variables
SERVICE_NAME = audio-handler
SERVICE_FILE = $(SERVICE_NAME).service
SCRIPT_NAME = audio_handler.sh
INSTALL_DIR = /etc/systemd/system
SCRIPT_INSTALL_DIR = /usr/local/bin

# Ensure we use bash
SHELL := /bin/bash

.PHONY: all install uninstall enable disable start stop restart status logs

all:
	@echo "Available commands:"
	@echo "  make install   - Install the service"
	@echo "  make uninstall - Uninstall the service"
	@echo "  make enable    - Enable the service to start on boot"
	@echo "  make disable   - Disable the service from starting on boot"
	@echo "  make start     - Start the service"
	@echo "  make stop      - Stop the service"
	@echo "  make restart   - Restart the service"
	@echo "  make status    - Check the status of the service"
	@echo "  make logs      - View the service logs"

install:
	@echo "Installing $(SERVICE_NAME) service..."
	sudo cp $(SERVICE_FILE) $(INSTALL_DIR)/
	sudo cp $(SCRIPT_NAME) $(SCRIPT_INSTALL_DIR)/
	sudo chmod +x $(SCRIPT_INSTALL_DIR)/$(SCRIPT_NAME)
	sudo systemctl daemon-reload
	@echo "Service installed successfully."

uninstall:
	@echo "Uninstalling $(SERVICE_NAME) service..."
	sudo systemctl stop $(SERVICE_NAME)
	sudo systemctl disable $(SERVICE_NAME)
	sudo rm -f $(INSTALL_DIR)/$(SERVICE_FILE)
	sudo rm -f $(SCRIPT_INSTALL_DIR)/$(SCRIPT_NAME)
	sudo systemctl daemon-reload
	@echo "Service uninstalled successfully."

enable:
	@echo "Enabling $(SERVICE_NAME) service..."
	sudo systemctl enable $(SERVICE_NAME)
	@echo "Service enabled successfully."

disable:
	@echo "Disabling $(SERVICE_NAME) service..."
	sudo systemctl disable $(SERVICE_NAME)
	@echo "Service disabled successfully."

start:
	@echo "Starting $(SERVICE_NAME) service..."
	sudo systemctl start $(SERVICE_NAME)
	@echo "Service started successfully."

stop:
	@echo "Stopping $(SERVICE_NAME) service..."
	sudo systemctl stop $(SERVICE_NAME)
	@echo "Service stopped successfully."

restart:
	@echo "Restarting $(SERVICE_NAME) service..."
	sudo systemctl restart $(SERVICE_NAME)
	@echo "Service restarted successfully."

status:
	@echo "Checking status of $(SERVICE_NAME) service..."
	sudo systemctl status $(SERVICE_NAME)

logs:
	@echo "Viewing logs for $(SERVICE_NAME) service..."
	sudo journalctl -u $(SERVICE_NAME) -f
