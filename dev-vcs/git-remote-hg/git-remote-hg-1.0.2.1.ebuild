# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Transparent bidirectional bridge between Git and Mercurial for Git"
HOMEPAGE="https://github.com/pabs3/git-remote-hg"

if [[ "${PV}" = "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/pabs3/git-remote-hg"
	KEYWORDS=""
else
	SRC_URI="https://github.com/pabs3/git-remote-hg/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	dev-vcs/git
	dev-vcs/mercurial[${PYTHON_USEDEP}]"
BDEPEND=""
