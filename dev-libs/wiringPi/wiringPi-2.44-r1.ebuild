# Copyright 2013 Hacking Networked Solutions
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI="3"

inherit eutils multilib

DESCRIPTION="A 'wiring' like library for the Raspberry Pi"
HOMEPAGE="http://wiringpi.com/"
SRC_URI="http://downloads.mad-hacking.net/software/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

MAKEDIRS="wiringPi devLib"

src_prepare() {
	epatch "${FILESDIR}/2.44-wiringPi_Makefile.patch"
	epatch "${FILESDIR}/2.44-devLib_Makefile.patch"
	epatch "${FILESDIR}/2.44-multilib_strict.patch"
	epatch "${FILESDIR}/libpath.diff"
}

src_compile() {
	for d in ${MAKEDIRS}; do
		cd "${WORKDIR}/${P}/${d}"	
		emake 
	done
}

src_install() {
	for d in ${MAKEDIRS}; do
		cd "${WORKDIR}/${P}/${d}"	
		emake DESTDIR="${D}/usr/" LIBSUBDIR="$(get_libdir)" PREFIX="" install
	done
}
