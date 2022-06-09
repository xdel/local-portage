# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit elisp-common eutils flag-o-matic

MY_P="${PN}-Version_2_6_13pre90"
OLD_P="${PN}-2.6.12"
DESCRIPTION="GNU Common Lisp"
HOMEPAGE="https://www.gnu.org/software/gcl/gcl.html"
SRC_URI="http://git.savannah.gnu.org/cgit/gcl.git/snapshot/${MY_P}.tar.gz
	https://dev.gentoo.org/~grozin/${OLD_P}-fedora.tar.bz2"

LICENSE="LGPL-2 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"
IUSE="+ansi athena emacs +readline tk X"

# See bug #205803
RESTRICT="strip"

RDEPEND="emacs? ( >=app-editors/emacs-23.1:* )
	readline? ( sys-libs/readline:= )
	athena? ( x11-libs/libXaw )
	>=dev-libs/gmp-4.1:=
	tk? ( dev-lang/tk:= )
	X? ( x11-libs/libXt x11-libs/libXext x11-libs/libXmu x11-libs/libXaw )
	virtual/latex-base"
DEPEND="${RDEPEND}
	virtual/texi2dvi
	>=app-text/texi2html-1.64
	>=sys-devel/autoconf-2.52"

S="${WORKDIR}"/${PN}

src_unpack() {
	tar --strip-components=1 -xaf "${DISTDIR}/${MY_P}.tar.gz" || die
	tar -xaf "${DISTDIR}/${OLD_P}-fedora.tar.bz2" || die
}

src_prepare() {
	mv "${WORKDIR}"/fedora/info/* info/
	cp -p /usr/share/texmf-dist/tex/texinfo/texinfo.tex info/
	find . -type f -perm /0111 | xargs chmod a-x
	chmod a+x add-defs add-defs1 config.guess config.sub configure install.sh
	chmod a+x bin/info bin/info1 gcl-tk/gcltksrv.in gcl-tk/ngcltksrv mp/gcclab
	chmod a+x o/egrep-def utils/replace xbin/*

	# fedora patches
	epatch "${FILESDIR}"/fd-leak.patch
	epatch "${FILESDIR}"/latex.patch
	epatch "${FILESDIR}"/texinfo.patch
	epatch "${FILESDIR}"/elisp.patch
	epatch "${FILESDIR}"/selinux.patch
	epatch "${FILESDIR}"/plt.patch
	epatch "${FILESDIR}"/ellipsis.patch
	epatch "${FILESDIR}"/infrastructure.patch
	epatch "${FILESDIR}"/extension.patch
	epatch "${FILESDIR}"/unrandomize.patch
	epatch "${FILESDIR}"/asm-signal-h.patch
	epatch "${FILESDIR}"/largefile.patch
	epatch "${FILESDIR}"/arm.patch
	epatch "${FILESDIR}"/0001-Fix-invalid-error-checking-to-not-crash-with-glibc-2.patch

	epatch_user

	sed -e 's|"-fomit-frame-pointer"|""|' -i configure
}

src_configure() {
	strip-flags
	filter-flags -fstack-protector -fstack-protector-all
	# breaks linking on multiple defined syms
	#append-cflags $(test-flags-CC -fgnu89-inline)

	local tcl=""
	if use tk; then
		tcl="--enable-tclconfig=/usr/lib --enable-tkconfig=/usr/lib"
	fi

	econf --enable-dynsysgmp \
		--disable-xdr \
		--enable-emacsdir=/usr/share/emacs/site-lisp/gcl \
		--enable-infodir=/usr/share/info \
		$(use_enable readline) \
		$(use_enable ansi) \
		$(use_enable athena xgcl) \
		$(use_with X x) \
		${tcl}
}

src_compile() {
	emake -j1
	VARTEXFONTS="${T}"/fonts emake -C info gcl.info
	if use athena; then
		pushd xgcl-2 > /dev/null
		pdflatex dwdoc.tex
		popd > /dev/null
	fi
}

src_test() {
	local make_ansi_tests_clean="rm -f test.out *.fasl *.o *.so *~ *.fn *.x86f *.fasl *.ufsl"
	if use ansi; then
		cd ansi-tests

		( make clean && make test-unixport ) \
			|| die "make ansi-tests failed!"

		cat "${FILESDIR}/bootstrap-gcl" \
			| ../unixport/saved_ansi_gcl

		cat "${FILESDIR}/bootstrap-gcl" \
			|sed s/bootstrapped_ansi_gcl/bootstrapped_r_ansi_gcl/g \
			| ./bootstrapped_ansi_gcl

		( ${make_ansi_tests_clean} && \
			echo "(load \"gclload.lsp\")" \
			| ./bootstrapped_r_ansi_gcl ) \
			|| die "Phase 2, bootstraped compiler failed in tests"
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	rm -rf "${D}"usr/share/doc
	rm -rf "${D}"usr/share/emacs

	rm elisp/add-defaults.el
	dodoc readme* RELEASE* ChangeLog* doc/*
	doman man/man1/gcl.1
	doinfo info/*.info*
	dohtml -r info/gcl-si info/gcl-tk

	if use emacs; then
		elisp-site-file-install "${FILESDIR}"/64${PN}-gentoo.el
		elisp-install ${PN} elisp/*.el
	fi

	insinto /usr/share/doc/${PF}
	doins info/*.pdf
	if use athena; then
		pushd xgcl-2 > /dev/null
		insinto /usr/share/doc/${PF}
		doins *.pdf
		popd > /dev/null
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
