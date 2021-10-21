FROM centos:7

ENV BUILD_VER=3.9.7
ENV DLURL=http://python.org/ftp/python/${BUILD_VER}/Python-${BUILD_VER}.tgz
ENV INSTALL_DIR=/opt/python-3.9

RUN yum groupinstall -y 'Development Tools' --setopt=group_package_types=mandatory,default,optional \
    && yum -y install \
        deltarpm \
        gcc \
        curl \
        rpm-build \
        which \
        openssl-devel \
        readline-devel \
        bzip2-devel \
        sqlite-devel \
        zlib-devel \
        ncurses-devel \
        db4-devel \
        expat-devel \
        gdbm-devel \
        libffi-devel

# Download sources and extract
RUN mkdir -p /build; cd /build && curl -L ${DLURL} | tar xz

# Build python and install to /tmp/installdir
RUN cd /build/Python-${BUILD_VER} \
    && ./configure --prefix=${INSTALL_DIR} --enable-unicode=ucs4 --enable-ipv6 \
    && make -j4 \
    && make install DESTDIR=/tmp/installdir

# Create post-install script for ldconfig
ENV LD_CONFIG_SH=/tmp/installdir/${INSTALL_DIR}/run-ldconfig.sh

RUN echo 'echo ${INSTALL_DIR}/lib > /etc/ld.so.conf.d/usr-local-lib.conf' > ${LD_CONFIG_SH} \
    && echo '/sbin/ldconfig' >> ${LD_CONFIG_SH} \
    && chmod +x ${LD_CONFIG_SH}
