# Copyright 2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic linux-mod git-r3

DESCRIPTION="GPIO kernel driver for VIA VT1211 chipset"
HOMEPAGE="https://github.com/manfredmann/vt1211_gpio_k.git"
EGIT_REPO_URI="https://github.com/manfredmann/vt1211_gpio_k.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

pkg_setup() {
	CONFIG_CHECK="~GPIOLIB"
	MODULE_NAMES="vt1211_gpio(extra:)"
	linux-mod_pkg_setup
}

src_prepare() {
	eapply_user
	epatch "${FILESDIR}"/makefile-install.patch
}

src_compile() {
	set_arch_to_kernel
	emake
}

src_install() {
	set_arch_to_kernel
	linux-mod_src_install
}
