# Copyright 2013-2023 Lawrence Livermore National Security, LLC and other
# Spack Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: (Apache-2.0 OR MIT)

# ----------------------------------------------------------------------------
# If you submit this package back to Spack as a pull request,
# please first remove this boilerplate and all FIXME comments.
#
# This is a template package file for Spack.  We've put "FIXME"
# next to all the things you'll want to change. Once you've handled
# them, you can save this file and test your package like this:
#
#     spack install tutorial-cti
#
# You can edit this file again by typing:
#
#     spack edit tutorial-cti
#
# See the Spack documentation for more information on packaging.
# ----------------------------------------------------------------------------

import spack.build_systems.autotools
from spack.package import *


class CrayCti(AutotoolsPackage):
    """CTI is a library enabling tool developers to launch and manage tool daemons"""
    """alongside applications on HPC systems."""

    homepage = "https://github.com/common-tools-interface/cti"
    git = "https://github.com/common-tools-interface/cti.git"

    # maintainers("ardangelo", "johnlvogt")

    # FIXME: Add proper versions and checksums here.
    version("2.18.4", submodules=False)

    # Build dependencies
    depends_on("autoconf", type="build", when="build_system=autotools")
    depends_on("automake", type="build", when="build_system=autotools")
    depends_on("libtool", type="build", when="build_system=autotools")
    depends_on("boost")
    depends_on("dyninst@12.3.0")
    depends_on("libiconv")
    depends_on("libarchive~iconv")
    depends_on("libssh2@1.11.0")

    def patch(self):
        # Patch pkgconfig files
        filter_file(r"${&libdir&}", r"-Wl,-rpath,${libdir} -L${libdir}",
            "pkgconfig/common_tools_fe.pc.in", string=True)
        filter_file(r"${&libdir&}", r"-Wl,-rpath,${libdir} -L${libdir}",
            "pkgconfig/common_tools_be.pc.in", string=True)
        # Spack rewrites rpath, checksums will fail
        filter_file(r"#ifdef HAVE_CHECKSUM", r"#if 0",
            "src/frontend/checksum/libchecksum.cpp", string=True)

    def configure_args(self):
        spec = self.spec
        args = [
            f"--with-boost={spec['boost'].prefix}",
            f"--with-dyninst={spec['dyninst'].prefix}",
            f"--with-libiconv={spec['libiconv'].prefix}",
            f"--with-libarchive={spec['libarchive'].prefix}",
            f"--with-libssh2-pc={spec['libssh2'].prefix}/lib/pkgconfig/libssh2.pc",
            f"--enable-pals=no",
            f"--enable-alps=no",
            f"--with-flux=/usr/include",
            f"DYNINST_CFLAGS=-I{spec['dyninst'].prefix}/include",
            f"DYNINST_LIBS=-L{spec['dyninst'].prefix}/lib -Wl,-rpath,{spec['dyninst'].prefix}/lib",
        ]
        return args

    def install(self, spec, prefix):
        make()
        make("install")

