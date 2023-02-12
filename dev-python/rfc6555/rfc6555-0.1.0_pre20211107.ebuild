# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=no
DISTUTILS_USE_SETUPTOOLS=bdepend
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 git-r3

DESCRIPTION="Implementation of the Happy Eyeballs Algorithm described in RFC 6555."
HOMEPAGE="https://github.com/sethmlarson/rfc6555"
EGIT_REPO_URI="https://github.com/sethmlarson/${PN}.git"
EGIT_COMMIT="b63778b5b5553e9848d7f26916618d755240c0ff"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
BDEPEND="${BDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
