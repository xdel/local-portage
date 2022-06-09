# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_8 python3_9 )

inherit eutils git-r3 python-any-r1

ABCREV="3709744c60696c5e3f4cc123939921ce8107fe04"
DESCRIPTION="Yosys - Yosys Open SYnthesis Suite"
HOMEPAGE="http://www.clifford.at/icestorm/"
LICENSE="ISC"
EGIT_REPO_URI="https://github.com/cliffordwolf/yosys.git"
SRC_URI="https://github.com/berkeley-abc/abc/archive/${ABCREV}.tar.gz -> abc-${ABCREV}.tar.gz"


SLOT="0"
KEYWORDS=""
IUSE="abc"

RDEPEND="
	sys-libs/readline:=
	virtual/libffi
	dev-vcs/git
	dev-lang/tcl:=
	dev-vcs/mercurial"

DEPEND="
	${PYTHON_DEPS}
	sys-devel/bison
	sys-devel/flex
	sys-apps/gawk
	virtual/pkgconfig
	${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-path-fix.patch
	eapply_user
	if use abc ; then
		unpack ${A}
		mv "${S}/abc-${ABCREV}" "${S}/abc" || die "Couldn't find Berkeley ABC sources!"
	fi
}

src_configure() {
	emake config-gcc
	echo "ENABLE_ABC := $(usex abc 1 0)" >> "${S}/Makefile.conf"
}

src_compile() {
	emake ABCREV=default PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake ABCREV=default PREFIX="${ED}/usr" STRIP=true install
}
