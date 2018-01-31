# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs autotools-utils

DESCRIPTION="SystemC verification library"
HOMEPAGE="http://www.systemc.org/"
SRC_URI="${P}.tar.gz"

SLOT="0"
LICENSE="SOPLA-3.0"
IUSE="doc static-libs"
KEYWORDS="~amd64 ~x86"

RESTRICT="fetch test"

RDEPEND="sci-electronics/systemc"
DEPEND="${RDEPEND}"

AUTOTOOLS_IN_SOURCE_BUILD=1

pkg_nofetch() {
	elog "${PN} developers require end-users to accept their license agreement"
	elog "by registering on their Web site (${HOMEPAGE})."
	elog "Please download ${A} manually and place it in ${DISTDIR}."
}

src_configure() {
	econf $(use_enable static-libs static) \
	--with-systemc="${EPREFIX}/usr" \
	CXX=$(tc-getCXX)
}

src_install() {
	dodoc AUTHORS ChangeLog INSTALL NEWS README RELEASENOTES
	rm docs/Makefile* || die
	rm examples/Makefile* || die
	use doc && dodoc -r docs/* && dodoc -r examples/*
	cd src
	autotools-utils_src_install
}
