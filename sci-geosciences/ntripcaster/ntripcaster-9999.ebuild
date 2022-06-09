# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils
if [[ ${PV} == "9999" ]] ; then
	inherit autotools git-r3
	KEYWORDS=""
	EGIT_REPO_URI="https://github.com/baidu/ntripcaster.git"
fi

DESCRIPTION="GNSS real-time data server"
HOMEPAGE="http://www.teromovigo.com/"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		eautoreconf
	fi
	eapply_user
}

src_configure() {
	econf
}

src_install() {
	sed -i -e 's/^NTRIPCASTER_LOGDIR_INST.*/NTRIPCASTER_LOGDIR_INST = \/var\/log\/ntripcaster/g' \
		-e 's/^NTRIPCASTER_ETCDIR_INST.*/NTRIPCASTER_ETCDIR_INST = \/etc\/ntripcaster/g' Makefile \
		src/Makefile conf/Makefile || die
	emake DESTDIR="${D}" install || die
	dodoc README.md || die
	keepdir /var/log/ntripcaster
}
