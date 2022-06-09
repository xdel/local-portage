# Copyright 2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit vala
inherit autotools
inherit ltprune

DESCRIPTION="Set of programs to inspect and build Windows Installer (.MSI) files"
HOMEPAGE="https://wiki.gnome.org/msitools"
LICENSE="LGPL-2+"

SLOT="0"
#SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
SRC_URI="http://ftp.gnome.org/pub/GNOME/sources/${PN}/${PV}/${P}.tar.xz"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE='nls rpath gnu-ld'

#       sys-apps/util-linux[libuuid]
#       app-arch/gcab[vala]
RDEPEND=(
        "dev-libs/glib:2
        dev-libs/libxml2
        gnome-extra/libgsf[introspection]
        $(vala_depend)
        sys-apps/util-linux
        app-arch/gcab[vala]
        gnome-extra/libgsf"
)
DEPEND_A="$RDEPEND"

src_prepare() {
        eapply_user
        vala_src_prepare
        eautoreconf
}

src_configure() {
        local my_econf_args=(
        --enable-shared
        --disable-static
        $(use_enable nls)
        $(use_enable rpath)
        )
        econf "${my_econf_args[@]}"
}

src_install() {
        default
        prune_libtool_files
}
