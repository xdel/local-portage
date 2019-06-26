# Copyright (C) 2015 Olaf Leidinger
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils

DESCRIPTION="ImageJ distribution"
HOMEPAGE="http://fiji.sc"
SRC_URI="https://downloads.imagej.net/fiji/latest/fiji-linux64.zip -> ${P}.zip"

RESTRICT="mirror strip"
LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="virtual/jre"
RDEPEND="${DEPEND}"

S="${WORKDIR}/Fiji.app"

src_install() {
	exeinto "/opt/${PN}"

	use amd64 && doexe ImageJ-linux64
	use x86   && doexe ImageJ-linux32

	insinto "/opt/${PN}"
	for i in Contents  db.xml.gz  images  jars  luts  macros  plugins  README.md  retro  scripts  WELCOME.md; do
           doins -r $i
	done

	dodir /usr/bin
	use amd64 && ln -s "/opt/${PN}/ImageJ-linux64" "${D}/usr/bin/fiji"
	use x86   && ln -s "/opt/${PN}/ImageJ-linux32" "${D}/usr/bin/fiji"

	make_desktop_entry "/usr/bin/fiji" "Fiji (imagej)" "/opt/$PN/images/icon.png" Graphics;RasterGraphics;Viewer
}
