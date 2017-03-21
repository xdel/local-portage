# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/libfprint/libfprint-0.4.0.ebuild,v 1.3 2011/11/14 00:42:44 xmw Exp $

EAPI=3

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/libfprint/libfprint"
	GIT_ECLASS="git-2"
fi


inherit autotools ${GIT_ECLASS}

MY_PV="v_${PV//./_}"
DESCRIPTION="library to add support for consumer fingerprint readers"
HOMEPAGE="http://cgit.freedesktop.org/libfprint/libfprint/"
if [[ ${PV} = *9999* ]]; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://cgit.freedesktop.org/${PN}/${PN}/snapshot/${MY_PV}.tar.bz2 -> ${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="debug static-libs"

RDEPEND="dev-libs/glib:2
	dev-libs/libusb:1
	dev-libs/nss
	x11-libs/gtk+:2
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] )"
DEPEND="${DEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_PV}

src_prepare() {
	mkdir m4 || die
	eautoreconf
}

pkg_setup() {
	einfo
	elog "This version does not support fdu2000 and upektc (yet)."
	einfo
}

src_configure() {
	econf \
		$(use_enable debug debug-log) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install
	use static-libs || find "${D}" -name "*.la" -delete
	dodoc AUTHORS HACKING NEWS README THANKS TODO
}
