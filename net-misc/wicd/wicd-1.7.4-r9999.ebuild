# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9,10} )
PYTHON_REQ_USE="ncurses?,xml"

inherit eutils distutils-r1 linux-info readme.gentoo-r1 systemd git-r3

DESCRIPTION="A lightweight wired and wireless network manager for Linux"
HOMEPAGE="https://launchpad.net/wicd"
EGIT_REPO_URI="https://git.launchpad.net/wicd"
EGIT_BRANCH="python3"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ~ppc ~ppc64 x86"
IUSE="doc X +gtk ioctl libnotify ncurses nls +pm-utils gnome-shell"

DEPEND="nls? ( dev-python/Babel[${PYTHON_USEDEP}] )"
RDEPEND="${PYTHON_DEPS}
	dev-python/dbus-python[${PYTHON_USEDEP}]
	X? (
		gtk? ( dev-python/pygtk[${PYTHON_USEDEP}] )
		|| (
			x11-misc/ktsuss
			kde-apps/kdesu
			)
	)
	|| (
		net-misc/dhcpcd
		net-misc/dhcp
		net-misc/pump
	)
	net-wireless/wireless-tools
	net-wireless/wpa_supplicant
	|| (
		sys-apps/net-tools
		sys-apps/ethtool
	)
	!gtk? ( dev-python/pygobject:3[${PYTHON_USEDEP}] )
	ioctl? ( dev-python/python-iwscan[${PYTHON_USEDEP}]
	dev-python/python-wpactrl[${PYTHON_USEDEP}] )
	libnotify? ( dev-python/notify-python[${PYTHON_USEDEP}] )
	ncurses? (
		dev-python/urwid[${PYTHON_USEDEP}]
		dev-python/pygobject:2[${PYTHON_USEDEP}]
	)
	pm-utils? ( sys-power/pm-utils )
	gnome-shell? ( gnome-base/gnome-shell )
	"
PATCHES=(
	"${FILESDIR}"/${PN}-init-sve-start.patch
	# The Categories entry in the .desktop files is outdated
	"${FILESDIR}"/${PN}-1.7.2.4-fix-desktop-categories.patch
	# Upstream bug https://bugs.launchpad.net/wicd/+bug/1412413
	# Fix urwid compat again
	"${FILESDIR}"/${PN}-1.7.3-urwid-1.3.0.patch
	# Another compatibility patch from launchpad bug 1075399
	"${FILESDIR}"/${PN}-1.7.3-bitrate-property.patch
	"${FILESDIR}"/${PN}-fix-ncurses.patch
)

src_prepare() {
	CONFIG_CHECK="~CFG80211_WEXT"
	local WARNING_CFG80211_WEXT="Wireless extensions have not been \
	configured in your kernel.  Wicd will not work unless CFG80211_WEXT is set."
	check_extra_config

	default

	# get rid of opts variable to fix bug 381885
	sed -i "/opts/d" "in/init=gentoo=wicd.in" || die
	# Need to ensure that generated scripts use Python 2 at run time.
	sed -e "s:self.python = '/usr/bin/python':self.python = '/usr/bin/python2':" \
	  -i setup.py || die "sed failed"
	# Fix misc helper scripts:
	#sed -e "s:/usr/bin/env python:/usr/bin/env python2:" \
	#	-i wicd/suspend.py wicd/autoconnect.py wicd/monitor.py || die
	# fix shebang for openrc init script (bug #573846)
	sed 's@/sbin/runscript@/sbin/openrc-run@' \
		-i in/init=gentoo=wicd.in || die
	if use nls; then
	  # Asturian is faulty with PyBabel
	  # (https://bugs.launchpad.net/wicd/+bug/928589)
	  rm po/ast.po
	  # zh_CN fails with newer PyBabel (Aug 2013)
	  rm po/zh_CN.po
	else
	  # nuke translations
	  rm po/*.po
	fi

	mkdir -p ${S}/pkg

	DOC_CONTENTS="To start wicd at boot with openRC, add
		/etc/init.d/wicd to a runlevel and: (1) Remove all net.*
		initscripts (except for net.lo) from all runlevels (2) Add these
		scripts to the RC_PLUG_SERVICES line in /etc/rc.conf (For
		example, rc_hotplug=\"!net.eth* !net.wlan*\")"
}

src_configure() {
	local myconf
	use gtk || myconf="${myconf} --no-install-gtk"
	use libnotify || myconf="${myconf} --no-use-notifications"
	use ncurses || myconf="${myconf} --no-install-ncurses"
	use pm-utils || myconf="${myconf} --no-install-pmutils"
	use gnome-shell || myconf="${myconf} --no-install-gnome-shell-extensions"
	python_setup
	"${EPYTHON}" ./setup.py configure --no-install-docs \
		--resume=/usr/share/wicd/scripts/ \
		--suspend=/usr/share/wicd/scripts/ \
		--verbose ${myconf}
}

src_install() {
	distutils-r1_src_install
	keepdir /var/lib/wicd/configurations
	keepdir /etc/wicd/scripts/{postconnect,disconnect,preconnect}
	keepdir /var/log/wicd
	use nls || rm -rf "${D}"/usr/share/locale
	systemd_dounit "${S}/other/wicd.service"
	readme.gentoo_create_doc
}

pkg_postinst() {
	# Maintainer's note: the consolekit use flag short circuits a dbus rule and
	# allows the connection. Else, you need to be in the group.
	if ! has_version sys-auth/consolekit; then
		ewarn "Wicd-1.6 and newer requires your user to be in the 'users' group. If"
		ewarn "you are not in that group, then modify /etc/dbus-1/system.d/wicd.conf"
	fi
	xdg_icon_cache_update
	readme.gentoo_print_elog
}
pkg_postrm() {
	xdg_icon_cache_update
}

