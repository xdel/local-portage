# Copyright 2014 Julian Ospald <hasufell@posteo.de>
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils check-reqs gnome2-utils flag-o-matic toolchain-funcs

# BASE_DATA_PV=1.0
# BASE_DATA_P=${PN}_${BASE_DATA_PV}_unified
DATA_PV=1.51
UPDATE_P=${PN}_${DATA_PV}_update
ENGINE_PV=1.51
ENGINE_P=${PN}_${ENGINE_PV}_sdk

DESCRIPTION="Multiplayer FPS based on the QFusion engine (evolved from Quake 2)"
HOMEPAGE="http://www.warsow.net/"
SRC_URI="http://www.warsow.eu/${ENGINE_P}.tar.gz
	http://www.warsow.eu/warsow_${DATA_PV}_unified.tar.gz
	mirror://gentoo/warsow.png"

# ZLIB: bundled angelscript
LICENSE="GPL-2 ZLIB warsow"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug dedicated irc openal server"

RDEPEND=">=dev-libs/libRocket-1.2.1_p20130110
	<dev-libs/libRocket-1.3.0.0
	media-libs/freetype
	net-misc/curl
	sys-libs/zlib
	!dedicated? (
		media-libs/libpng:0
		media-libs/libsdl
		media-libs/libtheora
		media-libs/libvorbis
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXinerama
		x11-libs/libXrandr
		x11-libs/libXxf86dga
		x11-libs/libXxf86vm
		virtual/jpeg
		virtual/opengl
		openal? ( media-libs/openal )
	)"
DEPEND="${RDEPEND}
	app-arch/unzip
	x11-misc/makedepend
	!dedicated? (
		x11-proto/xineramaproto
		x11-proto/xf86dgaproto
		x11-proto/xf86vidmodeproto
	)
	openal? ( virtual/pkgconfig )"

S=${WORKDIR}/source/source

CHECKREQS_DISK_BUILD="1G"
CHECKREQS_DISK_USR="500M"

src_prepare() {
	if [[ $(tc-getCC) =~ clang ]]; then
		einfo "disabling -ffast-math due to clang bug"
		einfo "http://llvm.org/bugs/show_bug.cgi?id=13745"
		append-cflags -fno-fast-math
		append-cxxflags -fno-fast-math
	fi

	sed -i \
		-e "/fs_basepath =/ s:\.:/usr/share/${PN}:" \
		qcommon/files.c \
		|| die "sed files.c failed"

	# edos2unix breaks whitespace files
	einfo "removing dos line breaks"
	find . -type f -exec sed -i 's/\r$//' '{}' + || die

	cd "${S}"/.. || die
	epatch "${FILESDIR}"/${PN}-1.5.1-build.patch \
		"${FILESDIR}"/${PN}-1.03-pic.patch \
		"${FILESDIR}"/${PN}-1.5.1-openal.patch
	epatch_user
}

src_compile() {
	yesno() { use ${1} && echo YES || echo NO ; }

	tc-export CC CXX LD AR RANLIB

	emake -C ../libsrcs/angelscript/sdk/angelscript/projects/gnuc

	local arch
	if use amd64 ; then
		arch=x86_64
	elif use x86 ; then
		arch=i386
	fi

	local myconf
	if use dedicated ; then
		myconf=(
			BUILD_CLIENT=NO
			BUILD_IRC=NO
			BUILD_SND_OPENAL=NO
			BUILD_SND_QF=NO
			BUILD_CIN=NO
			BUILD_SERVER=YES
			BUILD_TV_SERVER=YES
		)
	else
		myconf=(
			BUILD_CLIENT=YES
			BUILD_IRC=$(yesno irc)
			BUILD_SND_OPENAL=$(yesno openal)
			BUILD_SND_QF=YES
			BUILD_CIN=YES
			BUILD_SERVER=$(yesno server)
			BUILD_TV_SERVER=$(yesno server)
		)
	fi

	emake \
		V=YES \
		SYSTEM_LIBS=YES \
		BASE_ARCH=${arch} \
		BINDIR=lib \
		BUILD_ANGELWRAP=YES \
		DEBUG_BUILD=$(yesno debug) \
		${myconf[@]}
}

src_install() {
	cd lib

	if ! use dedicated ; then
		newbin ${PN}.* ${PN}
		doicon -s 48 "${DISTDIR}"/${PN}.png
		make_desktop_entry ${PN} Warsow
	fi

	if use dedicated || use server ; then
		newbin wsw_server.* ${PN}-ded
		newbin wswtv_server.* ${PN}-tv
	fi

	exeinto /usr/libexec/${PN}
	doexe */*.so

	insinto /usr/share/${PN}
	doins -r "${WORKDIR}"/${PN}_15/basewsw

	local so
	for so in basewsw/*.so ; do
		dosym /usr/libexec/${PN}/${so##*/} \
			/usr/share/${PN}/${so}
	done

	if [[ -e libs ]] ; then
		dodir /usr/share/${PN}/libs
		for so in libs/*.so ; do
			dosym /usr/libexec/${PN}/${so##*/} \
				/usr/share/${PN}/${so}
		done
	fi

	dodoc "${WORKDIR}"/${PN}_15/docs/*
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}

