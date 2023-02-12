# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="The command-line client for the patchwork patch tracking tool"
HOMEPAGE="https://github.com/getpatchwork/pwclient"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
