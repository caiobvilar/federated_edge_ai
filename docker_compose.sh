#!/bin/bash
export UID=$(id -u)
export GID=$(id -g)

IMAGE="federated_learning:latest"

echo -e "\nCreating the Docker image ${IMAGE}"

while true
do
    read -r -p "    Confirm? [y/n]" input
    
    case $input in
        [yY][eE][sS]|[yY])
    echo "    Creating image"
    docker-compose build
    break
    ;;
        [nN][oO]|[nN])
    echo "    No images were created."
    break
            ;;
        *)
    echo "    The only options are Y for yes and N for no..."
    ;;
    esac
done