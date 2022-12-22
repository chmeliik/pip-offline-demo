#!/bin/bash
set -o errexit -o nounset -o pipefail -o xtrace

# fetch dependencies, modify requirements.txt, set environment variables
cachi2 fetch-deps \
    --source ./atomic-reactor \
    --package '{
        "type":"pip",
        "requirements_files": ["requirements.txt"],
        "requirements_build_files": ["requirements-build.txt", "requirements-pip.txt"]
    }'
cachi2 inject-files ./cachi2-output --for-output-dir /cachi2
source <(cachi2 generate-env ./cachi2-output -f env --for-output-dir /cachi2)

# build the container
podman build . \
    --tag cachi2-atomic-reactor \
    --network none \
    --volume "$(realpath ./cachi2-output)":/cachi2:z \
    --build-arg PIP_NO_INDEX="$PIP_NO_INDEX" \
    --build-arg PIP_FIND_LINKS="$PIP_FIND_LINKS"
