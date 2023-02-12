# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Frequency scanner for GNU Radio"
HOMEPAGE="https://github.com/csm/gr-scan"
#SRC_URI="http://git.zx2c4.com/${PN}/snapshot/${P}.tar.xz"
COMMIT="0aaa276459cb474c0ebe7e9f34eadf689a1b6433"
SRC_URI="https://github.com/csm/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"

SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

RDEPEND="
	net-wireless/gnuradio:=[soapy]
	net-wireless/gr-osmosdr:=
	dev-libs/boost:=
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	sed -i -e 's#install -s#install#' -e 's/\/local//g' Makefile
	eapply ${FILESDIR}/makefile.patch
	default
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
}
