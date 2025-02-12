# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic git-r3 toolchain-funcs

DESCRIPTION="PALO : PArisc Linux Loader"
HOMEPAGE="http://parisc-linux.org/ https://parisc.wiki.kernel.org/"
EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/deller/palo.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
CDEPEND="www-client/lynx"
PATCHES=(
	"${FILESDIR}"/${PN}-9999-toolchain.patch
)

src_prepare() {
	default
	sed -i lib/common.h -e '/^#define PALOVERSION/{s|".*"|"'${PV}'"|g}' || die
}

src_compile() {
	emake AR=$(tc-getAR) CC=$(tc-getCC) LD=$(tc-getLD) -C palo
	emake AR=hppa-linux-gnu-ar CC=hppa-linux-gnu-gcc LD=hppa-linux-gnu-ld -C ipl
	emake AR=$(tc-getAR) CC=$(tc-getCC) LD=$(tc-getLD) iplboot
}

src_install() {
	into /
	dosbin palo/palo

	doman palo.8
	dodoc TODO debian/changelog README.html

	insinto /etc
	doins "${FILESDIR}"/palo.conf

	insinto /usr/share/palo
	doins iplboot

	insinto /etc/kernel/postinst.d/
	insopts -m 0744
	doins "${FILESDIR}"/99palo
}
