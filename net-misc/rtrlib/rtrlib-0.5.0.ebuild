# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/rtrlib/rtrlib"
fi

DESCRIPTION="An open-source C implementation of the RPKI/Router Protocol client"
HOMEPAGE="https://github.com/rtrlib/rtrlib"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/rtrlib/rtrlib/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-util/cmake
		net-libs/libssh"

RDEPEND="${DEPEND}"

src_configure() {
	# Hacking around library suffix 
	case ${ARCH} in
		amd64) mycmakeargs="${mycmakeargs} -DLIB_SUFFIX=64";;
	esac
	cmake-utils_src_configure
}
