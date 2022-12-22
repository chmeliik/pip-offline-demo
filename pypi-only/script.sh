#!/bin/bash
set -o errexit -o nounset -o pipefail -o xtrace

# find build dependencies
pip_find_builddeps.py requirements.txt -o requirements-build.in
pip-compile requirements-build.in --allow-unsafe

# download dependencies
pip download --no-binary :all: --no-deps -r requirements.txt
pip download --no-binary :all: --no-deps -r requirements-build.txt

# pip install in container
podman run --rm -ti -v "$PWD:$PWD:z" -w "$PWD" --network none pied-pipper:latest \
    pip install --find-links=. --no-index -r requirements.txt
