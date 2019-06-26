# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python3_6 )

inherit cmake-utils python-single-r1

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/teeshop/rexgen"
fi

DESCRIPTION="Poweful regexp-based wordlist generator"
HOMEPAGE="https://github.com/teeshop/rexgen"
if [[ "${PV}" == "9999" ]]; then
	SRC_URI=""
else
	SRC_URI="https://github.com/teeshop/rexgen/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python lua"

DEPEND="sys-devel/flex
		dev-util/cmake
		dev-libs/icu
		>=sys-devel/bison-3.3
		python? ( ${PYTHON_DEPS} )
		lua? ( dev-lang/lua:= )"

RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}/src"

src_configure() {
	epatch "${FILESDIR}/add-missing-lib-prefix-${PV}.patch"
	# epatch "${FILESDIR}/glibc-2.26.patch"
	local mycmakeargs=(
		$(cmake-utils_use python USE_PYTHON)
		$(cmake-utils_use lua USE_LUA)
	)
	# Hacking around library suffix 
	case ${ARCH} in
		amd64) mycmakeargs="${mycmakeargs} -DLIB_SUFFIX=64";;
	esac
	cmake-utils_src_configure
}
