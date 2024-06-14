FROM registry.suse.com/suse/sle15:latest

# Install dependencies
RUN zypper install -y -t pattern devel_basis
RUN zypper install -y libarchive-devel libsodium-devel libjansson-devel libpciaccess-devel \
	libhwloc-devel munge python3 gzip bzip2 wget gcc12 gcc12-c++ gdb
RUN pip install ply

# Configure GCC
RUN rm /usr/bin/gcc /usr/bin/g++ \
	&& ln -s /usr/bin/gcc-12 /usr/bin/gcc \
	&& ln -s /usr/bin/g++-12 /usr/bin/g++

# Build CTI
COPY load-cti.sh repo.yaml runBuild.sh spack.yaml /cti-build-spack/
COPY packages /cti-build-spack/packages
ADD /usr/include/flux
RUN cd /cti-build-spack \
	&& ./runBuild.sh
