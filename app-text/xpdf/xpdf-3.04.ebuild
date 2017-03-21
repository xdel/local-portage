# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit fdo-mime gnome2 eutils flag-o-matic toolchain-funcs

DESCRIPTION="An X Viewer for PDF Files"
HOMEPAGE="http://www.foolabs.com/xpdf/"
SRC_URI="ftp://ftp.foolabs.com/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="X a4"

RDEPEND="media-libs/freetype
	sys-libs/zlib
	media-libs/libpng
	X? ( x11-libs/motif )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup() {
	append-flags '-DSYSTEM_XPDFRC="\"/etc/xpdfrc\""'
	# We know it's there, probably won't get rid of it, so let's make
	# the build output readable by removing it.
	einfo "Suppressing warning overload with -Wno-write-strings"
	append-cxxflags -Wno-write-strings
}

src_prepare() {
    epatch "${FILESDIR}"/drm-removal.patch
}

src_configure() {
	econf 	--with-freetype2-library=/usr/lib64 \
		--with-freetype2-includes=/usr/include/freetype2 \
		$(use_enable a4 a4-paper) \
		--prefix=/usr --mandir=/usr/share/man
}

src_compile() {
	tc-export CXX
	emake
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README ANNOUNCE CHANGES
	newicon "${S}/${PN}"/xpdfIcon.xpm xpdf.xpm
	insinto /usr/share/applications
	doins "${FILESDIR}"/xpdf.desktop
	mv "${ED}/usr/bin/pdftops" "${ED}/usr/bin/xpdf-pdftops"
	mv "${ED}/usr/bin/pdftotext" "${ED}/usr/bin/xpdf-pdftotext"
	mv "${ED}/usr/bin/pdfinfo" "${ED}/usr/bin/xpdf-pdfinfo"
	mv "${ED}/usr/bin/pdffonts" "${ED}/usr/bin/xpdf-pdffonts"
	mv "${ED}/usr/bin/pdfdetach" "${ED}/usr/bin/xpdf-pdfdetach"
	mv "${ED}/usr/bin/pdftoppm" "${ED}/usr/bin/xpdf-pdftoppm"
	mv "${ED}/usr/bin/pdfimages" "${ED}/usr/bin/xpdf-pdfimages"
	mv "${ED}/usr/share/man/man1/pdftops.1" "${ED}/usr/share/man/man1/xpdf-pdftops.1"
	mv "${ED}/usr/share/man/man1/pdftotext.1" "${ED}/usr/share/man/man1/xpdf-pdftotext.1"
	mv "${ED}/usr/share/man/man1/pdfinfo.1" "${ED}/usr/share/man/man1/xpdf-pdfinfo.1"
	mv "${ED}/usr/share/man/man1/pdffonts.1" "${ED}/usr/share/man/man1/xpdf-pdffonts.1"
	mv "${ED}/usr/share/man/man1/pdfdetach.1" "${ED}/usr/share/man/man1/xpdf-pdfdetach.1"
	mv "${ED}/usr/share/man/man1/pdftoppm.1" "${ED}/usr/share/man/man1/xpdf-pdftoppm.1"
	mv "${ED}/usr/share/man/man1/pdfimages.1" "${ED}/usr/share/man/man1/xpdf-pdfimages.1"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
