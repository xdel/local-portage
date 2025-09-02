# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="cross-platform viewer/manager for ZIM archives"
HOMEPAGE="https://kiwix.org/"
SRC_URI="https://github.com/kiwix/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-libs/libzim
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtimageformats:5
	dev-qt/qtsvg:5
	dev-qt/qtwebchannel:5
	dev-qt/qtwebengine:5[widgets]
	>=dev-libs/libkiwix-14.0.0:=
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i '/-Werror/d' kiwix-desktop.pro || die
}
src_configure() {
	eqmake5 PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake install INSTALL_ROOT="${ED}"
}
