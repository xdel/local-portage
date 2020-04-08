# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6} )

inherit git-r3 distutils-r1

DESCRIPTION="The command-line client for the patchwork patch tracking tool"
HOMEPAGE="https://github.com/getpatchwork/pwclient"
SRC_URI=""

EGIT_REPO_URI="git://github.com/getpatchwork/pwclient"
EGIT_COMMIT="698fa7f2b36e786a05220b9a7e13c40016a0511a"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""
