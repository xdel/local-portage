# Copyright 2013 Hacking Networked Solutions
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI="6"

inherit eutils multilib

DESCRIPTION="A 'wiring' like library for the Raspberry Pi"
HOMEPAGE="http://wiringpi.com/"
SRC_URI="http://downloads.mad-hacking.net/software/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="virtual/libcrypt"
DEPEND="${RDEPEND}"

MAKEDIRS="wiringPi devLib wiringPiD"

src_prepare() {
	eapply "${FILESDIR}"/2.50-make.patch
	default
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
