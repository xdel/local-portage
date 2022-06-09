# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools git-r3

DESCRIPTION="systray-applet that allows you to control some of PulseAudio's features."
HOMEPAGE="https://github.com/michaelmyc/pa-applet"
EGIT_REPO_URI="https://github.com/michaelmyc/pa-applet.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="x11-libs/gtk+:3
	dev-libs/glib:2
	media-sound/pulseaudio[glib]
	x11-libs/libnotify
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i -e 's| -Werror||' src/Makefile.am || die
	./autogen.sh || die
}
