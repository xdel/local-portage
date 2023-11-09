# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Tools that enables control of LXI compatible instruments"
HOMEPAGE="https://github.com/lxi-tools/lxi-tools"
SRC_URI="https://github.com/lxi-tools/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt5"

DEPEND="
	dev-lang/lua:5.3
	dev-libs/liblxi
	qt5? ( dev-qt/qtcharts )
	gui-libs/gtk:4
	gui-libs/gtksourceview:5
	gui-libs/libadwaita
	"

RDEPEND="${DEPEND}"

src_prepare() {
	eapply "${FILESDIR}"/lxi-lua-gentoo.patch
	default
}

src_configure() {
	local emesonargs=(
		$(meson_use qt5 gui)
	)
	meson_src_configure
}
