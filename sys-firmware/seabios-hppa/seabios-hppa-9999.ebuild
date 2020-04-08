# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit eutils flag-o-matic python-r1

# SeaBIOS maintainers sometimes don't release stable tarballs or stable
# binaries to generate the stable tarball the following is necessary:
# git clone git://git.seabios.org/seabios.git && cd seabios
# git archive --output seabios-${PV}.tar.gz --prefix seabios-${PV}/ rel-${PV}

if [[ ${PV} = *9999* ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/hdeller/seabios-hppa.git"
    EGIT_BRANCH="parisc_firmware"
fi

DESCRIPTION="Port of SEABIOS to the parisc/hppa architecture"
HOMEPAGE="https://www.seabios.org/"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
IUSE="debug"

# The amd64/x86 check is needed to workaround #570892.
SOURCE_DEPEND="${PYTHON_DEPS}"
DEPEND="${SOURCE_DEPEND}
	app-emulation/qemu"
RDEPEND=""

src_configure() {
	tc-ld-disable-gold #438058

	if use debug ; then
		echo "CONFIG_DEBUG_LEVEL=8" >.config
	fi
	# sed -i 's/hppa-linux-gnu-/hppa-unknown-linux-gnu-/g' Makefile
	./scripts/buildversion.py src/parisc/autoversion.h
}

_emake() {
	LANG=C \
	emake V=1 \
		VERSION="Gentoo/${EGIT_COMMIT:-${PVR}}" \
		"$@"
}

src_compile() {

	_emake CROSS_PREFIX=hppa-linux-gnu- parisc
	mv out/hppa-firmware.img ../hppa-firmware-master.img || die
}

src_install() {
	insinto /usr/share/qemu
	doins ../hppa-firmware-master.img
}
