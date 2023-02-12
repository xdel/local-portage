# Original by eroen, 2014
#
# modified by Markus Baier 17.04.2019
# added new Variable LICENSEPATH_VAR
# Changed the find parameters to exclude *.source
# Deletet the line responsible for the remove of license.txt
# Added boost 1.56 depandancy, the mex file in the path
# /opt/matlab/R2018a/bin/glnxa64/ depends on boost 1.56
# check with "ldd mex | grep boost" in /opt/matlab/R2018a/bin/glnxa64/
# Added a new parameter -javauserdir that will be
# set when the Installer script is called.
# Its neccessary because the jre runtime tries to create
# a file into the user directory which breaks the
# gentoo installer sandbox. With this parameter we
# hand over an alternative path for the java user directory
# which isthe temporary installation directory that is
# located inside the installer sandbox.
# Therfore the install_unix script that can be found
# inside the matlab_R2018a/bin/glnxa64/ folder has to
# be modified.
# Also needs Python v3.5 installed as minimum Version
# All supported Python versions can be found under the path
# /opt/matlab/R2019a/bin/glnxa64/ then search for matlabruntimeforpython
#
# Distributed under the terms of the ISC licence
# $Header: $

EAPI=6

inherit cdrom

MY_PV=R${PV}

DESCRIPTION="High-level language and interactive environment"
HOMEPAGE="http://www.mathworks.com/products/matlab/"
SRC_URI=""

LICENSE="MATLAB"
RESTRICT="bindist"
SLOT=${MY_PV}
KEYWORDS="-* ~amd64"
IUSE=""

HDEPEND="app-admin/chrpath"
LIBDEPEND=""
LIBDEPEND=""
RDEPEND="${PYTHON_DEPS} ${LIBDEPEND} =sys-devel/gcc-9*"
DEPEND="${RDEPEND}"
[[ ${EAPI} == *-hdepend ]] || DEPEND+=" ${HDEPEND}"

S=${WORKDIR}
BINDIR=/opt/bin
MY_PREFIX=/opt/${PN}/${MY_PV}
MY_EXE=${PN}-${PV}
INSTALL_KEY_VAR=MATLAB_${MY_PV}_FILE_INSTALLATION_KEY
LICENSEPATH_VAR=MATLAB_${MY_PV}_FILE_LICENSEPATH

QA_PRESTRIPPED="${MY_PREFIX#/}/.*"
QA_TEXTRELS="${MY_PREFIX#/}/bin/glnxa64/*"
QA_FLAGS_IGNORED="${MY_PREFIX#/}/.*"

pkg_pretend() {
	if [[ $MERGE_TYPE != binary ]] && [[ -z ${!INSTALL_KEY_VAR} ]]; then
		eerror "You need to set ${INSTALL_KEY_VAR} to your MATLAB ${MY_PV}"
		eerror "File Installation Key, eg. by adding"
		eerror "    ${INSTALL_KEY_VAR}=\"12345-67890-12345-67890\""
		eerror "to your make.conf ."
		eerror
		die
	fi

        if [[ $MERGE_TYPE != binary ]] && [[ -z ${!LICENSEPATH_VAR} ]]; then
                eerror "You need to set ${LICENSEPATH_VAR} to your MATLAB ${MY_PV}"
                eerror "File Installation Key, eg. by adding"
                eerror "    ${LICENSEPATH_VAR}=\"/tmp/network-lic.dat\""
                eerror "to your make.conf ."
                eerror
                die
        fi

}

src_unpack() {
	CDROM_NAME="MATLAB ${MY_PV}_UNIX dvd" cdrom_get_cds version.txt

	# I can't find any version-specific filenames at all :(
	local DISK_PV=$(head -n 1 "${CDROM_ROOT}"/version.txt)
	if [[ ${DISK_PV} != ${MY_PV} ]]; then
		eerror "Incorrect disk found at ${CDROM_ROOT}."
		eerror "Expected version: ${MY_PV}"
		eerror "Found version:    ${DISK_PV}"
		eerror
		die
	fi
}

src_configure() {
	sed -e '/^# destinationFolder=/a destinationFolder='"${ED%/}${MY_PREFIX}" \
		-e '/^# fileInstallationKey=/afileInstallationKey='"${!INSTALL_KEY_VAR}" \
		-e '/^# agreeToLicense=/a agreeToLicense=yes' \
		-e '/^# licensePath=/alicensePath='"${!LICENSEPATH_VAR}" \
		-e '/^# mode=/a mode=silent' \
		-e '/^# automatedModeTimeout=/a automatedModeTimeout=0' \
		-e '/^# outputFile=/a outputFile='"${ED%image/}"temp/matlab_installation.log \
		< "${CDROM_ROOT}"/installer_input.txt \
		> "${T}"/installer_input.txt \
		|| die
}

src_compile() {
	einfo
	einfo "Dies ist der compile Abschnitt" \
	|| die
}

src_install() {
	"${CDROM_ROOT}"/install \
		-inputFile "${T}"/installer_input.txt \
		-tmpdir "${T}" \
		-javauserdir "${T}" \
		-verbose \
		|| die

	einfo "Stripping RPATH from binaries ..."
	find "${ED%/}${MY_PREFIX}"/bin/glnxa64 -type f \( -name '*.so*' ! -name '*.source' \) -execdir chrpath -d {} + || die
	einfo "Fixing broken png files ..."
	cp "${FILESDIR}"/MatlabIcon.png "${ED%/}${MY_PREFIX}"/toolbox/shared/dastudio/resources/MatlabIcon.png || die

	# User should be able to add a licence.
	dodir "${MY_PREFIX}"/licenses
	fperms 1777 "${MY_PREFIX}"/licenses

	dosym "${MY_PREFIX}"/bin/matlab "${BINDIR}"/matlab-${PV}
	dosym "${MY_PREFIX}"/bin/mex "${BINDIR}"/mex-${PV}
}

pkg_postinst() {
	elog "On first startup, you will be asked to provide a MATLAB ${MY_PV} licence"
	elog "file. Alternatively, you can save your licence file as one of"
	elog "    ~/.matlab/${MY_PV}_licenses/*.lic"
	elog "    ${EPREFIX}${MY_PREFIX}/licenses/license.dat"
	elog "    ${EPREFIX}${MY_PREFIX}/licenses/network.lic"
	elog
	elog "If you experience blank windows after launching ${MY_EXE}, try"
	elog "installing x11-misc/wmname and running"
	elog "    wmname LG3D"
	elog "before launching ${MY_EXE} again."
}
