EAPI=8

inherit meson

DESCRIPTION="collection of Kiwix related command line tools"
HOMEPAGE="https://kiwix.org/"
SRC_URI="https://github.com/kiwix/$PN/archive/$PV.tar.gz -> $P.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=">=dev-libs/libkiwix-11
	net-libs/libmicrohttpd
	sys-libs/zlib"

src_prepare() {
#	eapply "${FILESDIR}"/depname.patch
	default
}
