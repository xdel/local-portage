# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic git-r3

DESCRIPTION="Osmocom GPRS libraries"
HOMEPAGE="http://bb.osmocom.org"
EGIT_REPO_URI="https://github.com/osmocom/libosmo-gprs"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	eapply_user
	eautoreconf
}
