# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils

LICENSE="OWPL-1"
DESCRIPTION="The Open Watcom compiler"
HOMEPAGE="http://www.openwatcom.org"
SRC_URI="ftp://ftp.heanet.ie/pub/openwatcom/source/open_watcom_${PV}-src.tar.bz2"

KEYWORDS="x86"
SLOT="0"
IUSE="examples source"

DEPEND="sys-devel/gcc
	games-emulation/dosbox"

RESTRICT="strip"
S=${WORKDIR}/OW19

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/openwatcom_1.9.0_build_fix.patch"
	epatch "${FILESDIR}/openwatcom_amd64_build_fix.patch"
	epatch "${FILESDIR}/dosbox.env.patch"
}

src_compile() {
	./build.sh rel || die "buildrel.sh failed"
}

src_install() {
	mkdir -p "${D}"/opt
	cp -R rel "${D}"/opt/openwatcom
	ln -s binl64 "${D}"/opt/openwatcom/bin

	use examples || rm -rf "${D}"/opt/openwatcom/samples
	use source || rm -rf "${D}"/opt/openwatcom/src

	INSTALL_DIR=/opt/openwatcom

	local env_file=05${PN}
	cat > ${env_file} <<-EOF
		WATCOM=${INSTALL_DIR}
		INCLUDE=${INSTALL_DIR}/lh
		PATH=${INSTALL_DIR}/binl
	EOF
	# doenvd ${env_file} || die "doenvd ${env_file} failed"
}
