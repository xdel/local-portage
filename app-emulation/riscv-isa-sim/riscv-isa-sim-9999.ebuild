EAPI="5"
inherit eutils autotools git-r3

DESCRIPTION="RISC-V ISA golden model"
HOMEPAGE="http://riscv.org/download.html#tab_spike"
EGIT_REPO_URI="https://github.com/riscv/riscv-isa-sim"
EGIT_BRANCH="master"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64"
IUSE=""

src_prepare() {
	sed -i "s/^install_libs_dir\ :=.*/install_libs_dir\ :=\ \$\(INSTALLDIR\)\/$(get_libdir)/g" \
	${S}/Makefile.in || die "Failed to fix Makefile"
}
