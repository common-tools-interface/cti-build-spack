#!/bin/bash

set -e

# Check for Spack
if ! command -v spack &> /dev/null; then

	# Get Spack
	if [[ ! -d ./spack ]]; then
		git clone -c feature.manyFiles=true https://github.com/spack/spack.git
	fi

	# Activate Spack
	source spack/share/spack/setup-env.sh
fi

if ! command -v spack &> /dev/null; then
	echo "Failed to run \`spack\`. Ensure that Spack is installed and configured"
	exit 1
fi

echo "Spack installed and activated"
if ! spack repo add $PWD &> /dev/null; then
	echo "CTI repo already added to Spack"
fi

CTI_INSTALL_DIR=$(spack find --format "{prefix}" cray-cti | head -n1)

# Build CTI
if [[ ! -d $CTI_INSTALL_DIR ]]; then
	echo "Building cray-cti"
	spack install --keep-stage cray-cti
fi

CTI_INSTALL_DIR=$(spack find --format "{prefix}" cray-cti | head -n1)
echo "cray-cti installed at: $CTI_INSTALL_DIR"

# Example build with frontend library
CTI_FE_PKGCONFIG_SCRIPT=$CTI_INSTALL_DIR/lib/pkgconfig/common_tools_fe.pc
CTI_BE_PKGCONFIG_SCRIPT=$CTI_INSTALL_DIR/lib/pkgconfig/common_tools_be.pc

echo "Building CTI workload manager test. See \`runBuild.sh\` for pkg-config script usage"
cc -g -O2 $CXXFLAGS $(pkg-config --cflags --libs $CTI_FE_PKGCONFIG_SCRIPT) \
	cti_wlm_test.c -o cti_wlm_test
echo "Build successful."

# Run basic link test
if ! test_output=$(./cti_wlm_test); then
	echo "Test built successfully, but it failed to start. Library may have been linked incorrectly"
	exit 1
fi

# Check test output
if echo "$test_output" | grep -q "No supported workload manager detected"; then
	echo "Test ran successfully, but did not detect a workload manager."
	echo "Depending on the setup of your build system, this may be expected."
else
	echo "Test ran successfully. $test_output"
fi
