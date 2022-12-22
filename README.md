# pip-offline-demo

## How to

```shell
make
source venv/bin/activate
cd pypi-only  # or a different demo
./script.sh
```

## Demos

### [pypi-only](./pypi-only)

Uses a simple `pip download`, only dependencies from PyPI.

* Figure out the build dependencies
* Download sdists for build and runtime dependencies (`pip download --no-binary :all:`)
* Install the dependencies in a network-isolated container using `--find-links --no-index`

### [external](./external)

Same as pypi-only, but downloads `requests` from a url instead.

Two extra steps compared to pypi-only:

* Download the requests tarball directly from the url
* Replace the https:// url in requirements.txt with a file:// url

### [atomic-reactor](atomic-reactor)

Uses [cachi2][cachi2] to process [atomic-reactor][atomic-reactor].

* Download sdists for build and runtime dependencies (`cachi2 fetch-deps`)
* Replace git:// url in requirements.txt with a file:// url (`cachi2 inject-files`)
* Set environment variables `PIP_FIND_LINKS PIP_NO_INDEX` (`cachi2 generate-env`)
* Run a network-isolated container build

[cachi2]: https://github.com/containerbuildsystem/cachi2
[atomic-reactor]: https://github.com/containerbuildsystem/atomic-reactor
