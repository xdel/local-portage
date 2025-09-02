# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="6"
inherit eutils

DESCRIPTION="A high-quality scanning and digital camera raw image processing software."
HOMEPAGE="http://www.hamrick.com/"
SRC_URI="https://www.hamrick.com/files/vuex6497.tgz -> ${P}.tgz"
RESTRICT="primaryuri strip"

LICENSE="vuescan"
SLOT="0"
KEYWORDS="~amd64 ~x86"

MY_LINGUAS="ar be bg ca cs da de el en es et fi fr gl he hi hr hu id it ja ko lt lv nl no pb pl pt ro ru sk sl sr sv ta th tl tr tw uk vi zh"

for MY_LINGUA in ${MY_LINGUAS}; do
	IUSE="${IUSE} linguas_${MY_LINGUA/-/_}"
done

S="${WORKDIR}/VueScan"

INSTALLDIR="/opt/${PN}"

DEPEND="dev-util/bsdiff"
RDEPEND="
	app-arch/bzip2
	dev-libs/atk
	dev-libs/expat
	dev-libs/fribidi
	dev-libs/glib
	dev-libs/libbsd
	dev-libs/libffi
	dev-libs/libpcre
	media-gfx/graphite2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libpng
	media-libs/mesa
	sys-apps/util-linux
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libdrm
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
		x11-libs/libXdamage
	x11-libs/libXdmcp
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxshmfence
	x11-libs/libXxf86vm
	x11-libs/pango
	x11-libs/pixman
"

src_unpack() {
	unpack ${P}.tgz
	cd ${S}
}

src_install() {
	for LINGUA in ${MY_LINGUAS}; do
		if ! use linguas_${LINGUA/-/_}; then
			rm -f lan_"${LINGUA}".txt
		fi
	done
	bspatch vuescan vuescan.patched "${FILESDIR}"/vuescan.patch.bin

	cat vuescan.patched > vuescan && rm -f vuescan.patched

	insinto ${INSTALLDIR}
	doins vuescan.rul vuescan.svg README.txt

	exeinto ${INSTALLDIR}
	doexe vuescan

	exeinto /usr/bin
	# Provide a simple exec wrapper
	doexe ${FILESDIR}/vuescan
	
	doicon ${FILESDIR}/VueScan.png

	make_desktop_entry "${INSTALLDIR}/${PN}" vuescan VueScan.png Graphics
}

pkg_postinst() {
	einfo "VueScan expects the webbrowser Mozilla installed in your PATH."
	einfo "You have to change this in the 'Prefs' tab or make available"
	einfo "a symlink/script named 'mozilla' starting your favourite browser."
	einfo "Otherwise VueScan will fail to show the HTML documentation."

	if use amd64 ; then
		ewarn "VueScan needs 32bit version of the libusb library."
		ewarn "You need to install it yourself since it is not provided with Gentoo."
		ewarn "Good luck."
	fi
	
	einfo "To use scanner with Vuescan under user you need add user into scanner group."
	einfo "Just run under root: gpasswd -a username scanner"
}
