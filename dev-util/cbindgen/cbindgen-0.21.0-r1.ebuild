# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.5.0

EAPI=8

CRATES="
	atty-0.2.14
	autocfg-1.0.1
	bitflags-1.2.1
	cfg-if-0.1.10
	clap-3.1.6
	cloudabi-0.0.3
	getrandom-0.1.15
	hashbrown-0.9.1
	heck-0.4.0
	hermit-abi-0.1.16
	indexmap-1.6.0
	itoa-0.4.6
	lazy_static-1.4.0
	libc-0.2.77
	lock_api-0.3.4
	log-0.4.11
	memchr-2.4.1
	os_str_bytes-6.0.0
	parking_lot-0.10.2
	parking_lot_core-0.7.2
	ppv-lite86-0.2.9
	proc-macro2-1.0.21
	quote-1.0.7
	rand-0.7.3
	rand_chacha-0.2.2
	rand_core-0.5.1
	rand_hc-0.2.0
	redox_syscall-0.1.57
	remove_dir_all-0.5.3
	ryu-1.0.5
	scopeguard-1.1.0
	serde-1.0.116
	serde_derive-1.0.116
	serde_json-1.0.57
	serial_test-0.5.0
	serial_test_derive-0.5.0
	smallvec-1.4.2
	strsim-0.10.0
	syn-1.0.41
	tempfile-3.1.0
	termcolor-1.1.3
	textwrap-0.15.0
	toml-0.5.6
	unicode-xid-0.2.1
	wasi-0.9.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="A tool for generating C bindings to Rust code"
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/eqrion/cbindgen/"
SRC_URI="$(cargo_crate_uris)
	https://github.com/eqrion/cbindgen/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 Boost-1.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
RESTRICT="test"

QA_FLAGS_IGNORED="usr/bin/cbindgen"

# Ugly hack for older rust preserved for firefox-esr 78
src_prepare() {
	grep -r "include_str.*../README.md" "${WORKDIR}" | awk -F\: '{print $1}' \
		| xargs sed -i '/include_str.*..\/README.md/d'
	default
}
