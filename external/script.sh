#!/bin/bash
set -o errexit -o nounset -o pipefail -o xtrace

# find build dependencies
pip_find_builddeps.py requirements.txt -o requirements-build.in
pip-compile requirements-build.in --allow-unsafe

# download dependencies
pip download --no-binary :all: --no-deps -r requirements.txt
pip download --no-binary :all: --no-deps -r requirements-build.txt

# download external requests archive
curl -L https://github.com/psf/requests/archive/refs/tags/v2.28.1.tar.gz -o requests-external.tar.gz

# modify requirements file
sed "s|requests @ [^ ]*|requests @ file://$PWD/requests-external.tar.gz|" requirements.txt > requirements-replaced.txt

# pip install in container
podman run --rm -ti -v "$PWD:$PWD:z" -w "$PWD" --network none pied-pipper:latest \
    pip install --find-links=. --no-index -r requirements-replaced.txt
