# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils flag-o-matic games

DESCRIPTION="Quake 2 engine focused on single player and 64-bit"
HOMEPAGE="http://www.yamagi.org/quake2/"
SRC_URI="http://deponie.yamagi.org/quake2/quake2-${PV}.tar.xz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client dedicated jpeg ogg openal +sdl"
REQUIRED_USE="|| ( client dedicated )"

RDEPEND="sys-libs/zlib
	client? (
		media-libs/libsdl
		virtual/opengl
		jpeg? ( virtual/jpeg )
		ogg? ( media-libs/libogg
				media-libs/libvorbis )
		openal? ( media-libs/openal )
		!sdl? ( x11-libs/libX11
				x11-libs/libXxf86vm ) )"

DEPEND="${RDEPEND}"

S="${WORKDIR}/quake2-${PV}"
YQ2LIB="$(games_get_libdir)/${PN}"

src_prepare() {
	# Add the game lib directory to the search path.
	epatch "${FILESDIR}/yq2lib.patch"

	# Fix for newer zlib versions.
	sed -i 's/\bOF\b/_Z_OF/g' src/common/unzip/*.{c,h} || die

	# Override the base flags.
	sed -i -r 's/^(C|LD)FLAGS :=/OLD_\0/' Makefile || die
}

src_compile() {
	# Refer to the Makefile about these flags.
	append-cflags -fno-strict-aliasing -fomit-frame-pointer -Wall -MMD -DYQ2LIB="\\\"${YQ2LIB}\\\""
	append-ldflags -lm -ldl 2> /dev/null # Upstream does it so...

	local TARGETS="game"
	use client && TARGETS="client refresher ${TARGETS}"
	use dedicated && TARGETS="server ${TARGETS}"

	emake ${TARGETS} \
		VERBOSE=1 \
		WITH_CDA=yes \
		WITH_ZIP=yes \
		WITH_SYSTEMWIDE=yes \
		WITH_SYSTEMDIR="${GAMES_DATADIR}/quake2" \
		WITH_RETEXTURING=$(use jpeg && echo yes || echo no) \
		WITH_OGG=$(use ogg && echo yes || echo no) \
		WITH_OPENAL=$(use openal && echo yes || echo no) \
		WITH_X11GAMMA=$(use sdl && echo no || echo yes)
}

src_install() {
	if use dedicated; then
		newgamesbin release/q2ded "${PN/quake2/q2ded}"
	fi

	if use client; then
		newgamesbin release/quake2 "${PN}"
		newicon stuff/icon/Quake2.png "${PN}.png"
		make_desktop_entry "${PN}" "Yamagi Quake II"

		insinto "${GAMES_DATADIR}/${PN}"
		exeinto "${GAMES_DATADIR}/${PN}"
		doins stuff/yq2.cfg
		doexe stuff/cdripper.sh

		exeinto "${YQ2LIB}"
		doexe release/ref_gl.so
	fi

	exeinto "${YQ2LIB}/baseq2"
	doexe release/baseq2/game.so

	dodoc CHANGELOG CONTRIBUTE README
	prepgamesdirs
}
