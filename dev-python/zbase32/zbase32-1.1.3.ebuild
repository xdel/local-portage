# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Base32 encoder/decoder"
HOMEPAGE="http://allmydata.org/trac/zbase32"
SRC_URI="http://pypi.python.org/packages/source/z/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools
	dev-python/pyutil"

RESTRICT_PYTHON_ABIS="3*"

src_prepare() {
    sed -i "/setup_requires.append('setuptools_darcs >= 1.0.5')/d" "${S}/setup.py"
    }

src_test() {
    testing() {
        PYTHONPATH="$(ls -d build-${PYTHON_ABI}/lib.*)" "$(PYTHON)" zbase32/test/__init__.py
    }
    python_execute_function testing
}
