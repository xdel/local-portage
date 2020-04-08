EAPI="5"
inherit eutils autotools git-r3

DESCRIPTION="RISC-V proxy kernel"
HOMEPAGE="http://riscv.org/download.html#tab_pk"
EGIT_REPO_URI="git://github.com/riscv/riscv-pk"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="riscv"
IUSE=""

DEPEND=""

src_configure() {
	mkdir build
	cd build
	export ECONF_SOURCE=".."
	export CHOST="riscv64-unknown-linux-gnu"
	export CFLAGS="-U_FORTIFY_SOURCE -fno-stack-protector"
	econf
}

src_compile() {
	cd build
	emake
}

src_install() {
	cd build
	emake DESTDIR="${D}" install
}
