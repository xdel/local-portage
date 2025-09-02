# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils git-r3

DESCRIPTION="Real Time Kinematic and other advanced GPS positioning techniques"
HOMEPAGE="http://gpspp.sakura.ne.jp/rtklib/rtklib.htm"
EGIT_REPO_URI="https://github.com/rtklibexplorer/RTKLIB"
EGIT_BRANCH="main"
# SRC_URI="https://rtkexplorer.com/pdfs/manual_demo5.pdf -> rtklib-manual-demo5.pdf"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lapack"
# S="${WORKDIR}/${P}+dfsg1"
MAKEOPTS="${MAKEOPTS} -j1"

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtserialport:5
	media-libs/libpng
	sys-devel/gcc[fortran]
	lapack? ( virtual/lapack )
"

RDEPEND="${DEPEND}"

src_prepare() {
	# cat "${DISTDIR}"/rtklib-manual-demo5.pdf | tee ${S}/rtklib-manual-demo5.pdf > /dev/null || die
#	eapply "${FILESDIR}"/01-fix-ublox-biases.patch
#	eapply "${FILESDIR}"/03-gfortran-back.patch
#	eapply "${FILESDIR}"/rnx2rtcm.patch
	eapply "${FILESDIR}"/gencrc-include.patch
	default
}

src_configure() {
	find . -type f -iname makefile | xargs sed -i \
		-e "s|/usr/local/bin|${D}/usr/bin|g" -e "s|-Wall -O3|${CFLAGS}|g" || die
	sed -i "s|-O3|${FFLAGS}|g" lib/iers/gcc/makefile
	cd app/qtapp
	eqmake5 "${myqmakeargs[@]}"
}

src_compile() {
	emake -C app/consapp
	emake -C app/qtapp
	emake -C util/rnx2rtcm
	emake -C util/gencrc
}

src_install() {
	dodoc -r doc/
	dolib.so lib/libRTKLib.so*
	exeinto /usr/bin
	for i in pos2kml str2str rnx2rtkp convbin rtkrcv
		do doexe ./app/consapp/${i}/gcc/${i}
	done
	for i in rtkconv_qt rtknavi_qt rtkplot_qt rtkpost_qt srctblbrows_qt strsvr_qt rtkget_qt \
	rtklaunch_qt
		do doexe ./app/qtapp/${i}/${i}
	done
	doexe util/rnx2rtcm/rnx2rtcm
	doexe util/gencrc/{gencrc,genxor,genmsk}
	doexe app/consapp/rtkrcv/gcc/rtkshut.sh
	doexe app/consapp/rtkrcv/gcc/rtkstart.sh
}
