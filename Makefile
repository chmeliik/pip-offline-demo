.PHONY: all
all: venv submodules helper-containers

.PHONY: venv
venv:
	virtualenv venv
	venv/bin/pip install pip-tools
	venv/bin/pip install 'cachi2 @ git+https://github.com/containerbuildsystem/cachi2.git'
	curl https://raw.githubusercontent.com/containerbuildsystem/cachito/master/bin/pip_find_builddeps.py -O
	chmod +x ./pip_find_builddeps.py
	mv ./pip_find_builddeps.py venv/bin

.PHONY: submodules
submodules:
	git submodule update --init

.PHONY: helper-containers
helper-containers: pied-pipper builder-image

.PHONY: pied-pipper
pied-pipper:
	podman build -t pied-pipper helper-containers/pied-pipper

.PHONY: builder-image
builder-image:
	podman build -t builder-image helper-containers/builder-image
