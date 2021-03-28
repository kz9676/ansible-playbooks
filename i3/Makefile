#
# Makefile -- Build rules and helper utilities for i3 window manager
# container.
#
#
# Copyright (C) 2021 Kostya Zolotarov
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
#

image_name = ansible-i3
container_name = i3
container_ip = $(shell docker inspect --format '{{.NetworkSettings.IPAddress}}' $(container_name))

all: build run hosts check install

setup:
	@cp -v ~/.ssh/id_rsa.pub .

build: setup
	@docker build -t $(image_name) -f ../Dockerfile .

install:
	ansible-playbook -i hosts -u root site.yml

check:
	@docker images $(image_name)
	@docker container ls -f "name = $(container_name)"

run:
	@docker run --name $(container_name) --rm -d $(image_name)

ip:
	@echo $(container_ip)

ping: hosts
	ansible -m ping -i hosts -u root i3_desktops

.PHONY: hosts
hosts:
	@echo "[i3_desktops]" > hosts 
	@echo $(container_ip) >> hosts 
	
ssh:
	ssh-keyscan -t ecdsa $(container_ip) >> $(HOME)/.ssh/known_hosts
	ssh root@$(container_ip)

stop:
	@docker stop $(container_name)

clean:
	@if [ -f ./id_rsa.pub ]; then rm -v ./id_rsa.pub; fi

uninstall:
	@docker rmi $(image_name)

help:
	@echo "Usage: make {setup,build,install,check,ip,ping,run,hosts,ssh,clean,uninstall,help}"

