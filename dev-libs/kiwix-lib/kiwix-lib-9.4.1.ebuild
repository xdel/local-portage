# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit meson
inherit flag-o-matic

DESCRIPTION="kiwix-lib"
HOMEPAGE="https://github.com/kiwix/kiwix-lib"
SRC_URI="https://github.com/kiwix/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
https://github.com/kainjow/Mustache/archive/refs/tags/v4.1.tar.gz -> mustache.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-libs/icu
		dev-libs/libzim
		dev-libs/pugixml
		net-misc/curl
		net-libs/libmicrohttpd
		sys-libs/zlib
		net-misc/aria2"
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
	default
	mv "${WORKDIR}"/libkiwix-"${PV}" "${WORKDIR}"/"${P}"
}

src_configure() {
	append-flags "-I$(realpath ../Mustache-*/)"
	meson_src_configure
}

src_compile() {
	default
}
