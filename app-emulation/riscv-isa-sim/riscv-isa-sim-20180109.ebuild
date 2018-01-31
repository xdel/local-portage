EAPI="5"
inherit eutils autotools git-r3

DESCRIPTION="RISC-V ISA golden model"
HOMEPAGE="http://riscv.org/download.html#tab_spike"
EGIT_REPO_URI="git://github.com/riscv/riscv-isa-sim"
EGIT_COMMIT="fd0dbf46c3d9f8b005d35dfed79dbd4b4b0f974a"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64"
IUSE=""

DEPEND="sys-libs/riscv-fesvr"
