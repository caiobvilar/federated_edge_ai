#!/bin/bash
export _UID=$(id -u)
export GID=$(id -g)
export HOSTNAME="$(cat /etc/hostname)"

IMAGE="federated_learning:latest"
CONTAINER="federated_learning"
NETWORK="host"
APPNAME="FedLearning"


docker run --tty --interactive \
--network ${NETWORK} \
--device=/dev/video0:/dev/video0 \
--env DISPLAY \
--volume /tmp/.X11-unix \
--volume /dev:/dev \
--volume $(pwd)/../..:/home/${USER}/federate_edge_ai \
--volume=/run/user/${UID}/pulse:/run/user/1000/pulse \
--privileged \
--group-add dialout \
--group-add 27 \
--group-add video \
--group-add audio \
--name ${CONTAINER} \
${IMAGE}