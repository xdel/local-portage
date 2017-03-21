# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/vimprobable2/vimprobable2-1.3.0.ebuild,v 1.1 2013/05/26 09:53:29 radhermit Exp $

EAPI=5

inherit toolchain-funcs eutils

DESCRIPTION="A minimal web browser that behaves like the Vimperator plugin for Firefox"
HOMEPAGE="http://www.vimprobable.org/"
SRC_URI="mirror://sourceforge/vimprobable/${PN}_${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="net-libs/libsoup:2.4
	net-libs/webkit-gtk:2
	x11-libs/gtk+:2
	x11-libs/libX11"
DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig"

S=${WORKDIR}/${PN}

src_prepare() {
	tc-export CC
	epatch "${FILESDIR}/patches-since-1.4.2/0001-Switch-to-inputmode-also-for-input-type-search.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0002-bugfix-prevent-externally-edited-textarea-to-remain-.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0003-make-popup-policy-configurable-and-have-them-load-th.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0004-bugfix-only-trigger-a-download-when-status-code-is-i.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0005-documenting-popups-setting-in-man-page.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0006-introduction-of-private-mode-which-will-disable-writ.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0007-settings-for-HTML5-local-storage-and-database-defaul.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0008-default-settings.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0009-bugfix-if-the-status-bar-is-hidden-don-t-make-it-app.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0010-Add-support-for-l-to-show-a-link-destination-in-the-.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0011-Fixed-none-working-hints-in-frames.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0012-Qx-to-open-quickmark-in-a-new-window.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0013-View-edit-HTML-source-in-external-editor.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0014-whitespace-fixes-by-Matthew-Carter-jehiva-gmail.com.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0015-contributors-list.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0016-bugfix-re-enable-downloading-of-files-by-setting-cor.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0017-Clean-up-a-few-warnings-and-const-correctness-issues.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0018-Preserve-hint-numbering-across-f-l-and-y-hint-modes.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0019-Add-hi-history-setting-for-command-history-length.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0020-Add-the-clear-command-for-deleting-command-history.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0021-set-popups-variable-to-default-to-TRUE-in-order-to-r.patch"
	epatch "${FILESDIR}/patches-since-1.4.2/0022-bugfix-for-segmentation-fault-when-opening-a-link-in.patch"
	epatch "${FILESDIR}/0001-fixup-makefile.patch"
	epatch "${FILESDIR}/0002-use-Downloads-dir.patch"
	epatch "${FILESDIR}/add-search-engines.patch"
	epatch "${FILESDIR}/add-lp-search.patch"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1 vimprobablerc.5
}
