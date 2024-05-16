FROM arti.hpc.amslabs.hpecorp.net/baseos-docker-master-local/sles15sp5:latest

ENV http_proxy=http://proxy.houston.hpecorp.net:8080/
ENV https_proxy=http://proxy.houston.hpecorp.net:8080/

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
COPY cti_wlm_test.c repo.yaml runBuild.sh spack.yaml /cti-build-spack/
COPY packages /cti-build-spack/packages
RUN cd /cti-build-spack \
	&& echo ./runBuild.sh
