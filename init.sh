#!/bin/bash

docker run --rm -it \
    -v ${HOME}/.saferc \
    --network container:vault \
    safe target http://vault:8200 vault

docker run --rm -it \
    -v ${HOME}/.saferc:/root/.saferc \
    --network container:vault \
    safe init vault

docker run --rm -it \
    -v ${HOME}/.saferc:/root/.saferc \
    --network container:vault \
    safe vault secrets enable -path=ssh ssh

docker run --rm -it \
    -v ${HOME}/.saferc:/root/.saferc \
    --network container:vault \
    safe vault write ssh/config/ca generate_signing_key=true

docker run --rm -it \
    -v ${HOME}/.saferc:/root/.saferc \
    --network container:vault \
    --volumes-from vault \
    --entrypoint ash \
    safe -c "safe vault read -field=public_key ssh/config/ca > /certs/ca.pem"
