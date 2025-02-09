# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Normally you need only one version of this.
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="sqlite,ssl?"

inherit distutils-r1

DESCRIPTION="Powerful IMAP/Maildir synchronization and reader support"
HOMEPAGE="https://www.offlineimap.org/"
SRC_URI="https://github.com/OfflineIMAP/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc kerberos ssl"

DEPEND="doc? ( app-text/asciidoc )"
RDEPEND="
	dev-python/certifi
	dev-python/distro
	>=dev-python/imaplib2-2.57
	dev-python/pyyaml
	dev-python/rfc6555
	>=dev-python/urllib3-1.25.9
	kerberos? ( dev-python/gssapi )
"
BDEPEND=""

src_compile() {
	distutils-r1_src_compile
	use doc && emake -C docs man
}

src_install() {
	distutils-r1_src_install
	dodoc offlineimap.conf offlineimap.conf.minimal
	use doc && doman docs/{offlineimap.1,offlineimapui.7}
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "You will need to configure offlineimap by creating ~/.offlineimaprc"
		elog "Sample configurations are in /usr/share/doc/${PF}/"
		elog ""
		elog "If you connect via ssl/tls and don't use CA cert checking, it will"
		elog "display the server's cert fingerprint and require you to add it to the"
		elog "configuration file to be sure it connects to the same server every"
		elog "time. This serves to help fixing CVE-2010-4532 (offlineimap doesn't"
		elog "check SSL server certificate) in cases where you have no CA cert."
	fi
}
