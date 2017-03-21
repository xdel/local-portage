# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="WindowsError gem provides an easily accessible reference for standard Windows API Error Codes"
HOMEPAGE="https://github.com/rapid7/windows_error"

CDEPEND="dev-ruby/fivemat
         dev-ruby/yard"

DEPEND+=" ${CDEPEND} "

RDEPEND+=" ${CDEPEND} "

LICENSE="|| ( Ruby GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
