# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_PEP517=no
DISTUTILS_USE_SETUPTOOLS=bdepend
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1 git-r3

DESCRIPTION="Threaded Python IMAP4 client."
HOMEPAGE="https://github.com/jazzband/imaplib2"
EGIT_REPO_URI="https://github.com/jazzband/${PN}.git"
EGIT_COMMIT="11dbeb04866fc34abed62dbff89642ee24dcc9d6"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	sed -i "/version=/ s/\"\(.*\)\"/\"${PV}\"/" setup.py
	distutils-r1_src_prepare
}
