# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Modern Quake III Arena engine"
HOMEPAGE="https://github.com/ec-/Quake3e"
EGIT_REPO_URI="https://github.com/ec-/Quake3e.git"
EGIT_BRANCH="master"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="sdl curl vulkan system-jpeg renderer-dlopen ogg"

DEPEND="
	sdl? ( media-libs/libsdl2 )
	system-jpeg? ( virtual/jpeg )
	curl? ( net-misc/curl )
	vulkan? ( dev-util/vulkan-headers )
	ogg? ( media-libs/libogg )
	"

RDEPEND="${DEPEND}"

src_compile() {
	# hack around linker failure
	if [ $ARCH == 'amd64' ] ; then
		COMPILE_ARCH=x86_64
	else
		COMPILE_ARCH=$ARCH
	fi
	emake USE_SDL=$(usex sdl 1 0) USE_SYSTEM_JPEG=$(usex system-jpeg 1 0) \
	USE_VULKAN=$(usex vulkan 1 0) USE_VULKAN_API=$(usex vulkan 1 0) \
	USE_CURL=$(usex curl 1 0) USE_RENDERER_DLOPEN=$(usex renderer-dlopen 1 0) \
	USE_OGG_VORBIS=$(usex ogg 1 0) USE_SYSTEM_OGG=$(usex ogg 1 0) \
	USE_SYSTEM_VORBIS=$(usex ogg 1 0) RENDERER_DEFAULT=$(usex vulkan vulkan opengl) \
	ARCH=$COMPILE_ARCH
}

src_install() {
	# work around buggy install Makefile phase
	dodoc -r docs/
	dobin build/release-linux-${COMPILE_ARCH}/quake3e*
	# dolib.so build/release-linux-${COMPILE_ARCH}/quake3e_*
}
