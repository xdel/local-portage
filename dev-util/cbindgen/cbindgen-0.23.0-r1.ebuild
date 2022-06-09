# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.5.1

EAPI=8

CRATES="
	atty-0.2.14
	autocfg-1.1.0
	bitflags-1.3.2
	cfg-if-1.0.0
	clap-3.1.6
	fastrand-1.7.0
	hashbrown-0.11.2
	heck-0.4.0
	hermit-abi-0.1.19
	indexmap-1.8.0
	instant-0.1.12
	itoa-1.0.1
	lazy_static-1.4.0
	libc-0.2.121
	lock_api-0.4.6
	log-0.4.16
	memchr-2.4.1
	os_str_bytes-6.0.0
	parking_lot-0.11.2
	parking_lot_core-0.8.5
	proc-macro2-1.0.36
	quote-1.0.17
	redox_syscall-0.2.12
	remove_dir_all-0.5.3
	ryu-1.0.9
	scopeguard-1.1.0
	serde-1.0.136
	serde_derive-1.0.136
	serde_json-1.0.79
	serial_test-0.5.1
	serial_test_derive-0.5.1
	smallvec-1.8.0
	strsim-0.10.0
	syn-1.0.89
	tempfile-3.3.0
	termcolor-1.1.3
	textwrap-0.15.0
	toml-0.5.8
	unicode-xid-0.2.2
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="A tool for generating C bindings to Rust code."
# Double check the homepage as the cargo_metadata crate
# does not provide this value so instead repository is used
HOMEPAGE="https://github.com/eqrion/cbindgen/"
SRC_URI="https://github.com/eqrion/cbindgen/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris)"

# License set may be more restrictive as OR is not respected
# use cargo-license for a more accurate license picture
LICENSE="Apache-2.0 BSD Boost-1.0 MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

QA_FLAGS_IGNORED="usr/bin/cbindgen"

RESTRICT="test"

# Ugly hack for older rust preserved for firefox-esr 78
src_prepare() {
	grep -r "include_str.*../README.md" "${WORKDIR}" | awk -F\: '{print $1}' \
		| xargs sed -i '/include_str.*..\/README.md/d'
	default
}
