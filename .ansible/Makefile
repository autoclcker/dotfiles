SRC_DIR := $(dir $(lastword $(MAKEFILE_LIST)))

ansible-py/install:
	ansible-playbook --ask-become-pass --inventory $(SRC_DIR)inventory.ini $(SRC_DIR)playbook.yml
.PHONY: ansible-py/install

ansible-py/ping:
	ansible all --inventory $(SRC_DIR)inventory.ini --module-name ping
.PHONY: ansible-py/ping
