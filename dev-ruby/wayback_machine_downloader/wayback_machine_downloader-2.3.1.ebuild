# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Download an entire website from the Internet Archive Wayback Machine"
HOMEPAGE="https://github.com/hartator/wayback-machine-downloader"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
LICENSE="MIT"
SLOT="$(ver_cut 1)"
IUSE=""

PATCHES=( "${FILESDIR}/01-http-rl.patch" "${FILESDIR}/03-http-rl.patch" )

ruby_add_bdepend "test? ( dev-ruby/minitest:5 )"

all_ruby_install() {
	all_fakegem_install
	ruby_fakegem_binwrapper wayback_machine_downloader /usr/bin/wayback_machine_downloader
}
