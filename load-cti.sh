#!/bin/bash

ldconfig
source /cti-build-spack/spack/share/spack/setup-env.sh
export CTI_INSTALL_DIR=$(spack find --format "{prefix}" cray-cti | head -n1)
