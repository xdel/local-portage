# Distributed under the terms of the GNU General Public License v2+

EAPI=6
inherit multilib elisp-common

MY_P="${P}"g
DESCRIPTION="X11 waveform viewer"
HOMEPAGE="https://www.veripool.org/wiki/dinotrace"
SRC_URI="http://www.veripool.org/ftp/${MY_P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+doc emacs"

DEPEND="
	x11-libs/libX11
	doc? ( sys-apps/texinfo )
	emacs? ( virtual/emacs )
	x11-libs/motif
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_compile() {
	emake
	if use emacs; then
		pushd lisp > /dev/null
		elisp-compile *.el
		popd > /dev/null
	fi
}

src_install() {
	emake DESTDIR="${D}" dinotrace.dvi install || die "emake install failed"
	use doc && dodoc dinotrace.dvi dinotrace.txt
	if use emacs; then
		elisp-install ${PN} lisp/*.{el,elc}
	fi
}
pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		mktexlsr
	fi
}

