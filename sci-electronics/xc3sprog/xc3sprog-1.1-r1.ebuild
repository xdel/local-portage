EAPI="7"
inherit cmake-utils eutils

DESCRIPTION="Xilinx FPGA Programmer"
HOMEPAGE="https://github.com/matrix-io/xc3sprog/releases"
SRC_URI="https://github.com/matrix-io/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-embedded/libftdi
		 dev-embedded/libftd2xx
		 dev-libs/libusb-compat
		 dev-libs/wiringPi"
S="${WORKDIR}/${PN}-${P}"
DEPEND="${RDEPEND}"


src_configure() {
		if [ ${ARCH} == amd64 ] ; then
			IS_64=64
		fi
		local mycmakeargs=(
				"-DLIBFTDI_INCLUDE_DIR=$(pkg-config libftdi1 --cflags-only-I | cut -d' ' -f1 | sed 's/-I//')"
				"-DLIBFTDI_LIBRARIES=${EPREFIX}/usr/lib${IS_64}/libftdi1.so"
		)
		# eapply "${FILESDIR}"/lib64-discovery.diff
		cmake-utils_src_configure
}
