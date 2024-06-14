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

export CTI_INSTALL_DIR=$(spack find --format "{prefix}" cray-cti | head -n1)
echo "cray-cti installed at: $CTI_INSTALL_DIR"
