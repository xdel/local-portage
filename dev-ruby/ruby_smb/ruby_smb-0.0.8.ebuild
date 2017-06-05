# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22 ruby23"

# Specs are not bundled in the gem and upstream source is not tagged
RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="A message creator and parser for the SMB protocol family"
HOMEPAGE="http://www.metasploit.com/"

CDEPEND="dev-ruby/rubyntlm
         dev-ruby/bit-struct
         dev-ruby/bindata
		 dev-ruby/windows_error"

DEPEND+=" ${CDEPEND} "

RDEPEND+=" ${CDEPEND} "

LICENSE="BSD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
