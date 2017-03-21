# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

FP_GUI=fingerprint-gui-1.03
MY_PN=${PN/bsapi-bin/}
DESCRIPTION="UPEK Biometric Services SDK for PC"
HOMEPAGE="http://www.upek.com/solutions/eikon/default.asp"
SRC_URI="http://www.n-view.net/Appliance/fingerprint/download/${FP_GUI}.tar.gz"

LICENSE="UPEK_EULA"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="+headers"

DEPEND=""
RDEPEND="${DEPEND}"

S=${FP_GUI}/${MY_PN}

src_unpack() {
	unpack ${FP_GUI}.tar.gz
}

src_install() {
	cd "${S}"/
	if use headers; then
		insinto /usr/include
		doins include/bsapi.h
		doins include/bserror.h
		doins include/bstypes.h
	fi
	if use x86; then
		dolib lib/libbsapi.so
	elif use amd64; then
		dolib lib64/libbsapi.so
	fi
	insinto /etc/udev/rules.d
	doins 91-fingerprint-gui-upek.rules
	dodir /var/lib/${MY_PN}_data
	fperms 777 /var/lib/${MY_PN}_data
	echo "nvmprefix=\"/var/lib/${MY_PN}_data/.NVM\" dualswipe=0" > ${MY_PN}.cfg
	insinto /etc
	doins ${MY_PN}.cfg
}
