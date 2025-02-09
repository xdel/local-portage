# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AT_M4DIR="${EROOT}/usr/share/mega/m4"
inherit autotools flag-o-matic
MY_PN="MEGAcmd"
if [[ -z ${PV%%*9999} ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/meganz/${MY_PN}.git"
#	EGIT_SUBMODULES=( )
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/meganz/${MY_PN}.git"
	EGIT_TAG="1.7.0_Linux"
fi

DESCRIPTION="Command Line Interactive and Scriptable Application to access MEGA"
HOMEPAGE="https://mega.nz/cmd"
KEYWORDS="~amd64 ~x86"

LICENSE="BSD-2"
SLOT="0"
IUSE="pcre"

DEPEND="
	pcre? ( dev-libs/libpcre:3[cxx] )
	sys-libs/readline:0
	media-libs/freeimage
	dev-libs/crypto++:=
	sys-libs/zlib
	dev-libs/libpcre:3[cxx]
	dev-libs/openssl:0
	net-dns/c-ares
	net-misc/curl
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-cxxflags $(test-flags-CXX -std=c++17)
	local myeconfargs=(
		--with-readline="/usr/$(get_libdir)"
		$(use_with pcre pcre "/usr")
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	dodoc UserGuide.md contrib/docs/*.md
}
