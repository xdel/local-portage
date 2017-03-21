# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils linux-info

DESCRIPTION="Dynamic tracing framework created (ported to Linux)"
HOMEPAGE="http://www.crisp.demon.co.uk/blog/"
SRC_URI="ftp://crisp.dynalias.com/pub/release/website/${PN}/${P}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-libs/libelf
	dev-libs/libdwarf
	virtual/linux-sources"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison
	dev-lang/perl"

src_prepare() {
	rm build || die

	epatch "${FILESDIR}"/${P}-destdir.patch \
		"${FILESDIR}"/${P}-build.patch
}

src_compile() {
	set_arch_to_kernel || die
	emake all || die
}

src_install() {
	dodoc Bugs CONTRIB Changes README Status.txt || die

	local KV_FULL=$(uname -r)
	local modulename=dtracedrv
	einfo "Installing ${modulename} module"
	insinto /lib/modules/${KV_FULL}/extra
	doins build-${KV_FULL}/driver/${modulename}.ko || die

	emake DESTDIR="${D}" install || die
}
