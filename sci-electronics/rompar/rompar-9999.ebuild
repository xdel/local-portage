# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python3_{5,6,7} pypy3 )

inherit eutils distutils-r1

DESCRIPTION="Semi-automatic extraction of data from microscopic images of Masked ROM"
HOMEPAGE="http://oamajormal.blogspot.co.uk/2013/01/fun-with-masked-roms.html"

if [[ ${PV} == 9999* ]] ; then
        EGIT_REPO_URI="https://github.com/AdamLaurie/${PN}"
        inherit git-r3
fi

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/pyflakes
	dev-python/virtualenv
	>=dev-python/pep8-1.5.7"

python_install_all() {
	cp -a "${FILESDIR}"/rompar.pdf "${S}"

	for i in examples rompar.pdf; do
           dodoc -r $i
	done

#	dodir /usr/bin
#	ln -s "/opt/${PN}/rompar.py" "${D}/usr/bin/rompar"
	distutils-r1_python_install_all
}
