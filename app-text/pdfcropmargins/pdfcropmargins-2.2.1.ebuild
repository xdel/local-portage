# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_{9,10,11} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml

inherit distutils-r1

DESCRIPTION="A command-line program to crop the margins of PDF files, with many options"
HOMEPAGE="https://github.com/abarker/pdfCropMargins"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RDEPEND="
		${PYTHON_DEPS}
		dev-python/setuptools[${PYTHON_USEDEP}]
		>=app-text/mupdf-1.19.6[${PYTHON_USEDEP}]
		>=dev-python/pillow-10.1.0[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
	"
BDEPEND="${RDEPEND}"

src_prepare() {
	default
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
}
