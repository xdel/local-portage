# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit savedconfig toolchain-funcs

DESCRIPTION='a fast, lightweight, vim-like browser based on webkit'
HOMEPAGE='http://fanglingsu.github.io/vimb/'

EGIT_COMMIT="abff254e142317e610fb91d7fed4c76d56f952c8"
SRC_URI="https://github.com/fanglingsu/vimb/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN}-${EGIT_COMMIT}

LICENSE='GPL-3'
SLOT='3'
KEYWORDS='~amd64 ~x86'
IUSE='savedconfig'

RDEPEND='
	x11-libs/gtk+:3
	>=net-libs/webkit-gtk-2.20.0:4
'
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	restore_config config.def.h
}

src_compile() {
	emake PREFIX="/usr"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install
	save_config src/config.def.h
}
