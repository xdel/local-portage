# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit cmake-utils

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://github.com/nitram2342/${PN}"
	inherit git-2
fi

DESCRIPTION="Open source software for chip reverse engineering"
HOMEPAGE="http://www.degate.org"
SLOT="0"

LICENSE="GPL-3"

RDEPEND="dev-libs/boost
	dev-util/cppunit
	app-doc/doxygen
	dev-cpp/gtkmm:2.4
	dev-libs/libxml2
	media-libs/freetype
	dev-cpp/gtkglextmm
	dev-libs/libzip
	dev-libs/xmlrpc-c
	media-libs/tiff
	media-libs/libpng
	net-misc/curl"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	cmake-utils_src_install
	dodoc changelog LICENSE.TXE README.rst
}
