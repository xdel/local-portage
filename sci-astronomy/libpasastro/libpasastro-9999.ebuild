# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit base eutils subversion

MY_PV=${PV:0:3}-${PV:4:2}
DESCRIPTION="Provide Pascal interface for standard astronomy libraries"
HOMEPAGE="http://www.sourceforge.net/projects/libpasastro/"
ESVN_REPO_URI="https://svn.code.sf.net/p/libpasastro/code/trunk"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/lazarus"
RDEPEND="${DEPEND}"

src_install() {
	if use amd64; then
		sed -i 's/destdir\/lib/destdir\/lib64/g' "${S}/install.sh"
	fi
	emake DESTDIR="${D}" PREFIX="${D}/usr" INSTALL_PROGRAM="install" install || die "install failed"
}

