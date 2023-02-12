# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic git-r3

DESCRIPTION="OsmocomBB MS-side GSM Protocol stack (L1, L2, L3) excluding firmware"
HOMEPAGE="http://bb.osmocom.org"
EGIT_REPO_URI="git://git.osmocom.org/osmocom-bb.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+transmit"

DEPEND="net-libs/libosmocore
		net-wireless/libosmo-gprs"
RDEPEND="${DEPEND}"

src_prepare() {
	use transmit && append-cflags "-DCONFIG_TX_ENABLE"
	eapply_user
	cd src/host/osmocon && eautoreconf && cd ../../.. || die
	cd src/host/layer23 && eautoreconf && cd ../../.. || die
	cd src/host/gprsdecode && eautoreconf && cd ../../.. || die
}

src_configure() {
	cd src/host/osmocon && econf && cd ../../.. || die
	cd src/host/layer23 && econf && cd ../../.. || die
	cd src/host/gprsdecode && econf && cd ../../.. || die
}

src_compile() {
	cd src/host/osmocon && emake && cd ../../.. || die
	cd src/host/layer23 && emake && cd ../../.. || die
	cd src/host/gprsdecode && emake && cd ../../.. || die

}

src_install() {
	cd src/host/osmocon && emake install DESTDIR="${D}" && cd ../../.. || die
	cd src/host/layer23 && emake install DESTDIR="${D}" && cd ../../.. || die
	cd src/host/gprsdecode && emake install DESTDIR="${D}" && cd ../../.. || die
}
