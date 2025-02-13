# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

PYTHON_COMPAT=( python3_{9..11} )
inherit eutils git-r3 python-any-r1 toolchain-funcs

DESCRIPTION="IceStorm - tools for analyzing and creating bitstreams for Lattice iCE40 FPGAs"
HOMEPAGE="http://www.clifford.at/icestorm/"
LICENSE="ISC"
EGIT_REPO_URI="https://github.com/cliffordwolf/icestorm.git"

SLOT="0"
KEYWORDS=""
IUSE="ftdi"

RDEPEND="ftdi? ( dev-embedded/libftdi:= )"
DEPEND="
		${PYTHON_DEPS}
		virtual/pkgconfig
		${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-path-fix.patch
	sed -i 's/\/usr\/local/\/usr/g' Makefile */Makefile config.mk
	epatch "${FILESDIR}"/${P}-config-mk.patch
	epatch "${FILESDIR}"/${P}-iceprog.patch
	if ! use ftdi; then
		epatch "${FILESDIR}"/${P}-no-iceprog.patch
	else
		epatch "${FILESDIR}"/${P}-libftdi1-fix.patch
	fi

	eapply_user
}

src_compile() {
	export PREFIX=/usr
	emake CC=$(tc-getCC) CXX=$(tc-getCXX) CFLAGS="$CFLAGS"
}
