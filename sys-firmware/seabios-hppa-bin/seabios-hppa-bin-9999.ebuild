# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="PA-RISC binary firmware"
HOMEPAGE="https://www.seabios.org/"
SRC_URI="http://xdel.ru/downloads/hppa-firmware.img.gz"
S="${WORKDIR}"

LICENSE="LGPL-3 GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="!sys-firmware/seabios-hppa"

src_unpack() {
	gzip -c -d "${DISTDIR}/hppa-firmware.img.gz" > "${S}"/hppa-firmware.img || die "unpacking binpkg failed"
}

src_install() {
	mkdir -p "${ED}"/usr/share/qemu/ || die
	install --mode=0644 hppa-firmware.img "${ED}"/usr/share/qemu/hppa-firmware.img || die
}
