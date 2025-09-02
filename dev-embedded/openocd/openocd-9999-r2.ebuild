# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/openocd/openocd-9999.ebuild,v 1.20 2011/11/15 21:12:38 vapier Exp $

EAPI="6"

inherit eutils
if [[ ${PV} == "9999" ]] ; then
	inherit autotools git-r3
	KEYWORDS=""
	EGIT_REPO_URI="https://repo.or.cz/${PN}.git"
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.bz2"
fi

DESCRIPTION="OpenOCD - Open On-Chip Debugger"
HOMEPAGE="http://openocd.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
IUSE="blaster dummy ftd2xx ftdi minidriver parport presto segger usb versaloon"
RESTRICT="strip" # includes non-native binaries

# libftd2xx is the default because it is reported to work better.
DEPEND="dev-embedded/libjaylink
	dev-libs/hidapi
	dev-lang/jimtcl
	usb? ( virtual/libusb )
	presto? ( dev-embedded/libftd2xx )
	ftd2xx? ( dev-embedded/libftd2xx )
	ftdi? ( dev-embedded/libftdi )"
RDEPEND="${DEPEND}"

REQUIRED_USE="blaster? ( || ( ftdi ftd2xx ) ) ftdi? ( !ftd2xx )"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		sed -i -e "/@include version.texi/d" doc/${PN}.texi || die
		AT_NO_RECURSIVE=yes eautoreconf
	fi
	eapply "${FILESDIR}"/capstone.patch
	default
}

src_configure() {
	# Here are some defaults
	myconf="--enable-buspirate --enable-ioutil --disable-werror
	--enable-amtjtagaccel --enable-ep93xx --enable-at91rm9200 --enable-gw16012
	--enable-oocd_trace --enable-remote-bitbang --enable-imx_gpio
	--enable-bcm2835gpio --enable-sysfsgpio"

	if use usb; then
		myconf="${myconf} --enable-usbprog --enable-jlink --enable-rlink \
			--enable-vsllink --enable-arm-jtag-ew --enable-stlink \
			--enable-ti-icdi --enable-ulink --enable-usb-blaster-2 \
			--enable-ft232r --enable-xds110 --enable-osbdm --enable-opendous \
			--enable-aice --enable-armjtagew --enable-kitprog --enable-cmsis-dap \
			--enable-openjtag --enable-jtag_vpi --enable-zy1000-master --enable-usb-blaster \
			--disable-zy1000 --enable-xlnx-pcie-xvc"
	fi

	# add explicitely the path to libftd2xx
	use ftd2xx && LDFLAGS="${LDFLAGS} -L/opt/$(get_libdir)"

	if use blaster; then
		use ftdi && myconf="${myconf} --use_blaster_libftdi"
		use ftd2xx && myconf="${myconf} --use_blaster_ftd2xx"
	fi
	econf \
		$(use_enable dummy) \
		$(use_enable ftdi ft2232_libftdi) \
		$(use_enable ftd2xx ft2232_ftd2xx) \
		$(use_enable minidriver minidriver-dummy) \
		$(use_enable parport) \
		$(use_enable presto presto_ftd2xx) \
		$(use_enable segger jlink) \
		$(use_enable versaloon vsllink) \
		--disable-internal-libjaylink \
		${myconf}
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO || die
	prepstrip "${D}"/usr/bin
}
