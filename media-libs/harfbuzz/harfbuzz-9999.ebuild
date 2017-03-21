# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="An OpenType text shaping engine"
HOMEPAGE="http://freedesktop.org/wiki/Software/HarfBuzz"

if [[ ${PV} == *9999 ]]; then
        SCM_ECLASS="git-2"
fi
EGIT_REPO_URI="git://anongit.freedesktop.org/harfbuzz"
inherit autotools ${SCM_ECLASS}
unset SCM_ECLASS

if [[ ${PV} != *9999 ]]; then
        SRC_URI="mirror://www.freedesktop.org/software/${PN}/release/${P}.tar.bz2"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.16
        >=x11-libs/cairo-1.8.0
        dev-libs/icu
        >=media-libs/freetype-2"

DEPEND="${RDEPEND}
        dev-util/pkgconfig
        >=sys-devel/autoconf-2.64
        >=sys-devel/libtool-2.2
        dev-util/ragel"

#src_unpack() { #no pathing needed at the moment
#       git-2_src_unpack
#       cd "${S}"
#       epatch "${FILESDIR}"/disable-tests.patch
#}

src_prepare() {
        eautoreconf
}

src_install() {
        default

        find "${ED}" -name '*.la' -delete
}
