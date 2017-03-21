# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Setuptools plugin that makes unit tests execute with trial instead of pyunit."
HOMEPAGE="http://tahoe-lafs.org/trac/setuptools_trial"
SRC_URI="http://pypi.python.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools
	dev-python/twisted"

RESTRICT_PYTHON_ABIS="3*"

src_prepare() {
	sed -i "/setup_requires.append('setuptools_darcs >= 1.1.0')/d" "${S}/setup.py"
	sed -i "/if False:/d" "${S}/setup.py"
	}
