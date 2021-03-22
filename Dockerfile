#
# Dockerfile -- Base image container with Python and SSH server 
#
# Usage:
#    
#    $ cp ~/.ssh/id_rsa.pub .
#    $ docker build -t base .
#    $ docker run --name base --rm -d base
#    $ export base_container_ip=$(docker inspect --format '{{.NetworkSettings.IPAddress}}' base)
#    $ ssh root@$base_container_ip
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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    ssh \
    python3.7 \
    --no-install-recommends \
    && apt-get clean \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3.7 0

RUN mkdir -p /run/sshd && chmod 0755 /run/sshd
RUN mkdir /root/.ssh
COPY id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 400 /root/.ssh/authorized_keys

EXPOSE 22

ENTRYPOINT ["/usr/sbin/sshd", "-D"]
