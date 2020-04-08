# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils
DESCRIPTION="Simple disk I/0 latency measuring tool"
HOMEPAGE="https://github.com/koct9i/ioping"
SRC_URI="https://github.com/koct9i/ioping/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86"

src_compile() {
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
