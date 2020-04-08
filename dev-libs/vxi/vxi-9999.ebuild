# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit git-r3 autotools eutils

DESCRIPTION="A free VXI-11 implementation."
HOMEPAGE="http://www.librevisa.org/"
EGIT_REPO_URI="http://www.librevisa.org/git/vxi.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+libtirpc"

RDEPEND="
    libtirpc? ( net-libs/libtirpc )
    !libtirpc? ( elibc_glibc? ( sys-libs/glibc[rpc(-)] ) )
"


CFLAGS="${CFLAGS} -fPIC"

src_prepare() {
	epatch "${FILESDIR}/glibc-2.26.patch"
	eautoreconf || die "autoreconf failed"
}

src_configure() {
	CFLAGS="-fPIC" econf $(use_with libtirpc)
}
