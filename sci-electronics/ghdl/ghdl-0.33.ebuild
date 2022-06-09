# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit eutils multilib

GCC_VERSION="4.9.3"
GNATGCC_SLOT="4.9"

DESCRIPTION="Complete VHDL simulator using the GCC technology"
HOMEPAGE="http://ghdl.free.fr"
SRC_URI="http://ghdl.free.fr/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
DEPEND="<sys-apps/texinfo-5.1
	dev-lang/gnat-gcc:${GNATGCC_SLOT}"
RDEPEND=""
S="${WORKDIR}/gcc-${GCC_VERSION}"

ADA_INCLUDE_PATH="${ROOT}/usr/lib/gnat-gcc/${CHOST}/${GNATGCC_SLOT}/adainclude"
ADA_OBJECTS_PATH="${ROOT}/usr/lib/gnat-gcc/${CHOST}/${GNATGCC_SLOT}/adalib"
GNATGCC_PATH="${ROOT}/usr/${CHOST}/gnat-gcc-bin/${GNATGCC_SLOT}:${ROOT}/usr/libexec/gnat-gcc/${CHOST}/${GNATGCC_SLOT}"

src_prepare() {

	# Fix issue similar to bug #195074, ported from vapier's fix for binutils
	sed -i -e "s:egrep.*texinfo.*dev/null:egrep 'texinfo[^0-9]*(4\.([4-9]|[1-9][0-9])|[5-9]|[1-9][0-9])' >/dev/null:" \
		"${WORKDIR}/${P}"/configure* || die "sed failed"
}


src_configure() {
	econf --enable-languages=vhdl
}

src_compile() {
	emake -j1 || die "Compilation failed"
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "Installation failed"

	cd "${D}"/usr/bin ; rm `ls --ignore=ghdl`
	rm -rf "${D}"/usr/include
	rm "${D}"/usr/$(get_libdir)/lib*
	cd "${D}"/usr/$(get_libdir)/gcc/${CHOST}/${GCC_VERSION} ; rm -rf `ls --ignore=vhdl*`
	cd "${D}"/usr/libexec/gcc/${CHOST}/${GCC_VERSION} ; rm -rf `ls --ignore=ghdl*`
	cd "${D}"/usr/share/info ; rm `ls --ignore=ghdl*`
	cd "${D}"/usr/share/man/man1 ; rm `ls --ignore=ghdl*`
	rm -Rf "${D}"/usr/share/locale
	rm -Rf "${D}"/usr/share/man/man7
}
