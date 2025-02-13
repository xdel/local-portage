# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
inherit cmake-utils llvm llvm.org multiprocessing python-any-r1

DESCRIPTION="The LLVM linker (link editor)"
HOMEPAGE="https://llvm.org/"
LLVM_COMPONENTS=( lld )
LLVM_TEST_COMPONENTS=( llvm/utils/{lit,unittest} )
llvm.org_set_globals

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="~sys-devel/llvm-${PV}"
DEPEND="${RDEPEND}"
BDEPEND="test? ( $(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]") )"

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

python_check_deps() {
	has_version -b "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare
	default
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON

		-DLLVM_INCLUDE_TESTS=$(usex test)
	)
	use test && mycmakeargs+=(
		-DLLVM_BUILD_TESTS=ON
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="-vv;-j;${LIT_JOBS:-$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")}"
	)

	cmake-utils_src_configure
}

src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake-utils_src_make check-lld
}
