# CTI Build with Spack

Spack recipe for [Common Tools Interface](https://github.com/common-tools-interface/cti).

Includes Dockerfile that inherits system Flux installation and builds CTI recipe.

	docker build -t cti-test .
	docker run -it `./flux-config` bash

	Container> cd /cti-build-spack
	Container> source ./load-cti.sh
	Container> ./cti_wlm_test
