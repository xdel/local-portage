# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PATCH_VER="1.6"
UCLIBC_VER="1.0"

inherit toolchain

KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~m68k ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

RDEPEND=""
DEPEND="${RDEPEND}
	ppc? ( >=${CATEGORY}/binutils-2.17 )
	ppc64? ( >=${CATEGORY}/binutils-2.17 )
	>=${CATEGORY}/binutils-2.15.94"

#src_prepare() {
#	# Fixing newer eclass patching
#	sed -i -e 's/--- gcc/--- a\/gcc/g' -e 's/+++ gcc/+++ b\/gcc/g' \
#		"${WORKDIR}"/patch/*.patch
#}
