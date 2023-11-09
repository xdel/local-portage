# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson git-r3

DESCRIPTION="Q2PRO is an enhanced, multiplayer oriented Quake 2 client and server"
HOMEPAGE="https://skuller.net/q2pro/"
EGIT_REPO_URI="https://github.com/skullernet/q2pro"
EGIT_BRANCH="master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl ffmpeg sdl png jpeg zlib X openal wayland"

DEPEND="
	openal? ( media-libs/openal )
	sdl? ( media-libs/libsdl2 )
	png? ( >=media-libs/libpng-1.6.11 )
	jpeg? ( virtual/jpeg )
	zlib? ( sys-libs/zlib )
	curl? ( >=net-misc/curl-7.68.0 )
	ffmpeg? ( >=media-video/ffmpeg-5.1.3 )
	X? ( x11-libs/libXi media-libs/mesa )
	wayland? ( dev-libs/wayland )
	"

RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		$(meson_feature ffmpeg avcodec)
		$(meson_feature curl libcurl)
		$(meson_feature jpeg libjpeg)
		$(meson_feature png libpng)
		$(meson_feature openal)
		$(meson_feature sdl sdl2)
		$(meson_feature wayland)
		$(meson_feature X x11)
		$(meson_feature zlib)
	)
	meson_src_configure
}

src_install() {
	dodoc -r doc
	meson_src_install
}
