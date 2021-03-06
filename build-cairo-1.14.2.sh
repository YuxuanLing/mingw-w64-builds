#!/bin/bash

. ./config.sh

./check_folders.sh

./check_prereqs.sh

URL='http://cairographics.org/releases/cairo-1.14.2.tar.xz'
ARCHIVE_NAME='cairo-1.14.2.tar.xz'
TARBALL_NAME='cairo-1.14.2.tar'
SOURCE_DIR_NAME='cairo-1.14.2'

pushd ${ARCHIVE_DIR} > /dev/null
curl --retry 5 --remote-name -L ${URL} || exit 1
popd > /dev/null

pushd ${SOURCE_DIR} > /dev/null
if [ -d ${SOURCE_DIR_NAME} ]
then
    rm -rf ${SOURCE_DIR_NAME}
fi

xz -d ${ARCHIVE_DIR}/${ARCHIVE_NAME} || exit 1
tar xf ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1
rm -f ${ARCHIVE_DIR}/${ARCHIVE_NAME} ${ARCHIVE_DIR}/${TARBALL_NAME} || exit 1

pushd ${SOURCE_DIR_NAME} > /dev/null

./configure --enable-shared \
            --enable-static \
            || exit 1
CFLAGS='-fno-lto -D__USE_MINGW_ANSI_STDIO=1 -Wno-error -include math.h' \
  make -j 1 || exit 1
make install || exit 1

popd > /dev/null
popd > /dev/null

