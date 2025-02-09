# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

MY_PV="$(ver_cut 1-2)"

DESCRIPTION="A collection of profiles for the AppArmor application security system"
HOMEPAGE="https://gitlab.com/apparmor/apparmor/wikis/home"
EGIT_REPO_URI="https://gitlab.com/apparmor/apparmor.git"
EGIT_TAG="v2.13.11"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="minimal"

RESTRICT="test"

S=${WORKDIR}/${P}/profiles

src_install() {
	if use minimal ; then
		insinto /etc/apparmor.d
		doins -r apparmor.d/{abstractions,tunables}
	else
		default
	fi
}
