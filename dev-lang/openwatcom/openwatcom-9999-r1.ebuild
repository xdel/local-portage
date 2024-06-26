# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils git-r3

LICENSE="OWPL-1"
DESCRIPTION="The Open Watcom compiler"
HOMEPAGE="http://www.openwatcom.org"
EGIT_REPO_URI="https://github.com/open-watcom/open-watcom-v2.git"
#EGIT_COMMIT="6c82fa8b15caae8259c410da7b0cebda95bbcb39"
EGIT_COMMIT="e3e5816c4902834e273b6c704789571c46414f96"

KEYWORDS="amd64 x86"
SLOT="0"
IUSE="examples source"

DEPEND="sys-devel/gcc
	games-emulation/dosbox"

RESTRICT="strip"
# S=${WORKDIR}/OW9999

src_compile() {
	epatch "${FILESDIR}/dosbox.env.patch"
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
