# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/occipital/openni2"
fi

inherit ${SCM} flag-o-matic toolchain-funcs java-pkg-opt-2

if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
else
	KEYWORDS="amd64 ~arm"
	SRC_URI="https://github.com/occipital/OpenNI2/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${P/_/-}"
fi

DESCRIPTION="OpenNI2 SDK"
HOMEPAGE="https://structure.io/openni"
LICENSE="Apache-2.0"
SLOT="0"
IUSE="cpu_flags_arm_neon doc java opengl static-libs"

RDEPEND="
	media-libs/libjpeg-turbo:=
	virtual/libusb:1
	virtual/libudev
	opengl? ( media-libs/freeglut )
	java? ( virtual/jre:1.8 )
"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	java? ( virtual/jdk:1.8 )"

PATCHES=(
	"${FILESDIR}/jpeg.patch"
	"${FILESDIR}/rpath.patch"
	"${FILESDIR}/soname.patch"
	"${FILESDIR}/pthread.patch"
	"${FILESDIR}/c++14.patch"
	"${FILESDIR}/noglvnd.patch"
)

src_prepare() {
	default

	rm -rf ThirdParty/LibJPEG
	for i in ThirdParty/PSCommon/BuildSystem/Platform.* ; do
		echo "" > ${i}
	done
}

src_compile() {
	if ! use elibc_glibc ; then
		# Build system doesn't respect CPPFLAGS.
		# bug #716346
		append-flags -DXN_PLATFORM_LINUX_NO_GLIBC -DXN_PLATFORM_HAS_NO_SCHED_PARAM
	fi

	use cpu_flags_arm_neon && export CFLAGS="${CFLAGS} -DXN_NEON"
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		ALLOW_WARNINGS=1 \
		GLUT_SUPPORTED="$(usex opengl 1 0)" \
		$(usex java "" ALL_WRAPPERS="") \
		$(usex java "" JAVA_SAMPLES="")

	if use doc ; then
		cd "${S}/Source/Documentation"
		doxygen || die
	fi
}

src_install() {
	dolib.so "${S}/Bin/"*Release/*.so
	cp -a "${S}/Bin/"*Release/OpenNI2 "${ED}/usr/$(get_libdir)"

	use static-libs && dolib.a "${S}/Bin/"*Release/*.a

	insinto /usr/include/openni2
	doins -r Include/*

	dobin "${S}/Bin/"*Release/{PS1080Console,PSLinkConsole,SimpleRead,EventBasedRead,MultipleStreamRead,MWClosestPointApp}
	use opengl && dobin "${S}/Bin/"*Release/{NiViewer,SimpleViewer,MultiDepthViewer,ClosestPointViewer}

	if use java ; then
		java-pkg_dojar "${S}/Bin/"*Release/*.jar
		echo "java -jar ${JAVA_PKG_JARDEST}/org.openni.Samples.SimpleViewer.jar" > org.openni.Samples.SimpleViewer
		dobin org.openni.Samples.SimpleViewer
	fi

	dodoc CHANGES.txt NOTICE README ReleaseNotes.txt Source/Documentation/Text/*.txt

	if use doc ; then
		docinto html
		dodoc -r "${S}/Source/Documentation/html/"*
	fi

	dodir /usr/$(get_libdir)/pkgconfig
	sed \
		-e "s/@libdir@/$(get_libdir)/" \
		-e "s/@version@/${PV}/" \
		"${FILESDIR}/libopenni2.pc.in" > "${ED}/usr/$(get_libdir)/pkgconfig/libopenni2.pc" || die
}
