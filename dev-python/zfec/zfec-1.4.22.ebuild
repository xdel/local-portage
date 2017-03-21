# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A fast erasure codec which can be used with the command-line, C, Python, or Haskell"
HOMEPAGE="http://allmydata.org/trac/zfec"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools
	dev-python/argparse
	dev-python/pyutil"

RESTRICT_PYTHON_ABIS="3*"

src_prepare() {
	sed -i "s/darcsver --count-all-patches//g" "${S}/setup.cfg"
	sed -i "/setup_requires.append('darcsver >= 1.2.0')/d" "${S}/setup.py"
	sed -i "/setup_requires.append('setuptools_darcs >= 1.1.0')/d" "${S}/setup.py"
	sed -i "/if False:/d" "${S}/setup.py"
}

src_test() {
	testing() {
		PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" zfec/test/__init__.py
	}
	python_execute_function testing
}

