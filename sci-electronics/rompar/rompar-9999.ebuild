# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils

DESCRIPTION="Semi-automatic extraction of data from microscopic images of Masked ROM"
HOMEPAGE="http://oamajormal.blogspot.co.uk/2013/01/fun-with-masked-roms.html"

if [[ ${PV} == 9999* ]] ; then
        EGIT_REPO_URI="https://github.com/ApertureLabsLtd/${PN}"
        inherit git-r3
fi

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-lang/python"
RDEPEND="${DEPEND}"

#S="${WORKDIR}/Fiji.app"

src_install() {
	cp -a "${FILESDIR}"/rompar.pdf "${S}"
	exeinto "/opt/${PN}"
	doexe rompar.py

	insinto "/opt/${PN}"
	for i in examples README.md rompar.pdf; do
           doins -r $i
	done

	dodir /usr/bin
	ln -s "/opt/${PN}/rompar.py" "${D}/usr/bin/rompar"
}
