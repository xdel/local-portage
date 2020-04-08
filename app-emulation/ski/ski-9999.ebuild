# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="ia64 instruction set simulator"
HOMEPAGE="http://ski.sourceforge.net/ http://www.gelato.unsw.edu.au/IA64wiki/SkiSimulator"
if [[ ${PV} = *9999* ]]; then
        EGIT_REPO_URI="https://github.com/trofi/ski.git"
        inherit git-r3
        SRC_URI=""
else
		SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="motif"

RDEPEND="dev-libs/libltdl:0=
	sys-libs/binutils-libs:0=
	sys-libs/ncurses:0=
	virtual/libelf
	motif? ( x11-libs/motif:0= )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	dev-util/gperf"

PATCHES=(
	"${FILESDIR}"/${P}-no-local-ltdl.patch
)

src_prepare() {
	default

	rm -rf libltdl src/ltdl.[ch] macros/ltdl.m4

	AT_M4DIR="macros" eautoreconf
}

src_configure() {
	econf \
		--without-included-ltdl \
		--without-gtk \
		$(use_with motif x11)
}
