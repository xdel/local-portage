# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/skychart/skychart-3.10.2854.ebuild,v 1.1 2014/04/03 12:29:38 hasufell Exp $

EAPI=6

inherit toolchain-funcs eutils xdg-utils

DESCRIPTION="Planetarium for amateur astronomers"
HOMEPAGE="http://www.ap-i.net/skychart/"

MY_PV=${PV:0:3}-${PV:4:4}
DATA_PKG="data_jpleph.tgz
	catalog_gcvs.tgz
	catalog_idx.tgz
	catalog_tycho2.tgz
	catalog_wds.tgz
	catalog_gcm.tgz
	catalog_gpn.tgz
	catalog_lbn.tgz
	catalog_ngc.tgz
	catalog_ocl.tgz
	catalog_pgc.tgz
	catalog_vdb.tgz
	data_spicesun.tgz
	catalog_leda.tgz
	catalog_barnard.tgz"
SRC_URI="${DATA_SRC_URI}
	mirror://sourceforge/skychart/1-software/version_${PV:0:3}/skychart-${MY_PV}-src.tar.xz"
for i in ${DATA_PKG} ; do
	SRC_URI="${SRC_URI} mirror://sourceforge/skychart/4-source_data/${i}"
done
unset i

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="system-healpix"

# pascal
QA_FLAGS_IGNORED="usr/bin/cdcicon
	usr/bin/skychart
	usr/bin/varobs
	usr/bin/catgen"
# usr/bin/varobs_lpv_bulletin

CDEPEND="x11-libs/libX11"
RDEPEND="${CDEPEND}
	x11-misc/xplanet
	sci-libs/libpasastro
	sci-libs/indilib"
DEPEND="${CDEPEND}
	>=dev-lang/lazarus-3.0.0[qt5,extras]
	>=dev-lang/fpc-3.0.0
	system-healpix? ( sci-astronomy/healpix )"

S=${WORKDIR}/${PN}-${MY_PV}-src

src_unpack() {
	unpack skychart-${MY_PV}-src.tar.xz

	local i
	for i in ${DATA_PKG} ; do
		mkdir ${i} || die
		cd ${i} || die
		unpack ${i}
		cd ..
	done
}

src_prepare() {
	ewarn "If build fails on qtprinters include, add Lazarus symlinks like below
	qtprinters_h.inc -> qt/qtprinters_h.inc
	qtprinters.inc -> qt/qtprinters.inc
	qtprndialogs.inc -> qt/qtprndialogs.inc"

	epatch "${FILESDIR}"/${P}-QA.patch
	epatch "${FILESDIR}"/${P}-lazarus-3.patch
	if use system-healpix ; then
		sed -i '/chealpix/d' library/Makefile.in
	fi
	eapply_user
}

src_configure() {
	tc-export CC CXX

	./configure \
		fpcbin="/usr/bin" \
		fpc="/usr/lib/fpc/$(fpc -iV)/source" \
		lazarus="/usr/share/lazarus" \
		prefix="/usr"
}

src_compile() {
	# this is ugly, but the build system sux, so don't bother me
	UNITDIR="/usr/share/lazarus/components/printers:/usr/share/lazarus/components/printers/unix" \
	INCDIR="/usr/share/lazarus/components/printers/unix:/usr/share/lazarus/components/printers" \
		emake -j1
}

src_install() {
	# use build system install rules on version bump
	# to check for new files
	# dobin varobs/{varobs,varobs_lpv_bulletin}
	dobin varobs/varobs
	dobin skychart/cdcicon
	dobin skychart/catgen
	newbin skychart/cdc skychart

	dolib.so skychart/library/plan404/libplan404.so
	dolib.so skychart/library/getdss/libgetdss.so
	dolib.so skychart/library/wcs/libcdcwcs.so
	dolib.so skychart/library/calceph/libcalceph.so.1.1

	insinto /usr/share
	doins -r system_integration/Linux/share/{applications,doc,icons,metainfo,pixmaps}

	dodoc system_integration/Linux/share/doc/skychart/changelog

	insinto /usr/share/skychart
	doins -r tools/{cat,data}
	for i in ${DATA_PKG} ; do
		cd "${WORKDIR}/${i}" || die
		doins -r .
	done
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
