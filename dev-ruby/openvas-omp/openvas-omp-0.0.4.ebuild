# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="This Ruby gem is used for communication with OpenVAS manager over OMP"
HOMEPAGE="https://github.com/kost/openvas-omp-ruby"

CDEPEND=">=dev-ruby/jeweler-1.5.2
         dev-ruby/shoulda
	 dev-ruby/rcov"

DEPEND+=" ${CDEPEND} "

RDEPEND+=" ${CDEPEND} "


LICENSE="|| ( Ruby GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
