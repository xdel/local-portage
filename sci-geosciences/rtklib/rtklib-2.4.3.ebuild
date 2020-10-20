# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="Real Time Kinematic and other advanced GPS positioning techniques"
HOMEPAGE="http://gpspp.sakura.ne.jp/rtklib/rtklib.htm"
SRC_URI="http://deb.debian.org/debian/pool/main/r/rtklib/rtklib_2.4.3+dfsg1.orig.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lapack"
S="${WORKDIR}/${P}+dfsg1"
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

src_configure() {
	find . -type f -iname makefile | xargs sed -i \
		-e "s|/usr/local/bin|${D}/usr/bin|g" -e "s|-Wall -O3|${CFLAGS}|g" || die
	sed -i "s|-O3|${FFLAGS}|g" lib/iers/gcc/makefile
	eqmake5 "${myqmakeargs[@]}"
}

src_compile() {
	emake -C lib/iers/gcc
	for i in pos2kml str2str rnx2rtkp convbin rtkrcv
		do emake -C app/${i}/gcc
	done
	emake -C util/rnx2rtcm
	emake
}

src_install() {
	dodoc -r doc/
	exeinto /usr/bin
	for i in pos2kml str2str rnx2rtkp convbin rtkrcv
		do doexe ./app/${i}/gcc/${i}
	done
	for i in rtkconv_qt rtkget_qt rtklaunch_qt rtknavi_qt rtkplot_qt \
		srctblbrows_qt strsvr_qt
		do doexe ./app/${i}/${i}
	done
	doexe util/rnx2rtcm/rnx2rtcm
	doexe app/rtkrcv/gcc/rtkshut.sh
	doexe app/rtkrcv/gcc/rtkstart.sh
}
