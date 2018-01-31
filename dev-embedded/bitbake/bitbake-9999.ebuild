# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 vcs-snapshot

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/openembedded/bitbake.git"
	inherit git-2
	KEYWORDS=""
else
	SRC_URI="https://github.com/openembedded/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

DESCRIPTION="package management tool for OpenEmbedded"
HOMEPAGE="http://git.openembedded.org/bitbake/"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc"

RDEPEND="dev-python/ply
	dev-python/progressbar"
DEPEND="doc? ( dev-libs/libxslt )"
