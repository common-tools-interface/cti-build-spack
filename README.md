# CTI Build with Spack

Spack recipe for [Common Tools Interface](https://github.com/common-tools-interface/cti).

Includes Dockerfile that inherits system Flux installation and builds CTI recipe.

Flux headers are copied from `/usr/include/flux` to build CTI. If Flux headers are updated, the container should be rebuilt.

Test files need to be available to the host system as well for proper Flux launches, so the Docker container will start in the current directory.

	docker build -t cti-test .
	docker run -it `./flux-config` -w $PWD cti-test bash

	Container> source /cti-build-spack/load-cti.sh
	Container> cp -r tests tests-run
	Container> cd tests-run
	Container> ./runTests.sh

	docker run -it `./flux-config` -w $PWD cti-test bash -c " \
		source /cti-build-spack/load-cti.sh && \
		cp -r tests tests-run && cd tests-run && \
		./runTests.sh"
