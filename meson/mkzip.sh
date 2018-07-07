#!/bin/bash

UUID=${1}
DATADIR=${2}
MODE=${3}

ZIP_DESTDIR="${MESON_BUILD_ROOT}/_zip"
ZIP_DIR="${MESON_BUILD_ROOT}/${UUID}"
ZIP_FILE="${MESON_BUILD_ROOT}/${UUID}.zip"

GSCHEMA_DIR="${ZIP_DESTDIR}/${DATADIR}/glib-2.0/schemas"
LOCALE_DIR="${ZIP_DESTDIR}/${DATADIR}/locale"

# PRE-CLEAN
rm -rf ${ZIP_DESTDIR} ${ZIP_DIR} ${ZIP_FILE}

# BUILD
cd ${MESON_BUILD_ROOT}
DESTDIR=${ZIP_DESTDIR} ninja install

# COPY
mkdir -p ${ZIP_DIR}
cp -pr ${ZIP_DESTDIR}/${DATADIR}/gnome-shell/extensions/${UUID}/* ${ZIP_DIR}

cp -pr ${GSCHEMA_DIR} ${ZIP_DIR}
glib-compile-schemas ${ZIP_DIR}/schemas

if [ -d ${LOCALE_DIR} ]; then
    cp -pr ${LOCALE_DIR} ${ZIP_DIR}
fi

# COMPRESS
cd ${ZIP_DIR}
zip -qr ${ZIP_FILE} .

# INSTALL
if [[ ${MODE} == "install" ]]; then
    INSTALL_DIR="${HOME}/.local/share/gnome-shell/extensions/${UUID}"
    rm -rf ${INSTALL_DIR}
    unzip ${ZIP_FILE} -d ${INSTALL_DIR}
fi
