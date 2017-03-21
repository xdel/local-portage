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

DESCRIPTION="The Ruby Exploitation (rex) Core Gem"
HOMEPAGE="https://github.com/rapid7/rex-core"

LICENSE="BSD"


CDEPEND=">=dev-ruby/rspec-3.5.0
         >=dev-ruby/rake-10.0"

DEPEND="${CDEPEND}"

RDEPEND="${CDEPEND}"

SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""
