# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils fdo-mime

DESCRIPTION="XnConvert is a powerful and free cross-platform batch image processor"
HOMEPAGE="http://www.xnview.com/"

#MY_V=${PV/./}
SRC_URI="amd64? ( http://download.xnview.com/old_versions/XnConvert/XnConvert-${PV}-linux-x64.tgz )"

SLOT="0"
LICENSE="freedist"
KEYWORDS="~amd64"
IUSE="+bundled-libs sensors"
REQUIRED_USE="bundled-libs? ( !sensors )"
RESTRICT="strip"

# not removing liblibraw.so
BUNDLED_LIBS="
lib/libicudata.so lib/generic/libqtuiotouchplugin.so lib/sensors/libqtsensors_linuxsys.so
lib/libQt5Svg.so.5 lib/generic/libqevdevtabletplugin.so lib/sensors/libqtsensors_generic.so
lib/libicutest.so.56.1 lib/generic/libqevdevkeyboardplugin.so lib/sensors/libqtsensors_iio-sensor-proxy.so
lib/libQt5DBus.so.5.15.15 lib/generic/libqevdevmouseplugin.so lib/libQt5Xml.so.5
lib/libQt5Network.so.5 lib/generic/libqevdevtouchplugin.so lib/libicui18n.so.56
lib/libQt5Concurrent.so.5.15.15 lib/libicudata.so.56 lib/libQt5XcbQpa.so.5
lib/libQt5Svg.so.5.15.15 lib/libsharpyuv.so lib/libicutu.so
lib/platforms/libqwayland-xcomposite-glx.so lib/libdbus-1.so Plugins/libwebpdemux.so.2
lib/platforms/libqvnc.so lib/libicuio.so.56 Plugins/libIlmThread-3_2.so.29
lib/platforms/libqoffscreen.so lib/libdbus-1.so.3 Plugins/libImath-3_2.so.29
lib/platforms/libqwayland-egl.so lib/libQt5Concurrent.so.5 Plugins/libwebpmux.so
lib/platforms/libqwayland-generic.so lib/libicui18n.so Plugins/libwebp.so.7
lib/platforms/libqwayland-xcomposite-egl.so lib/libicule.so Plugins/openjp2.so
lib/platforms/libqminimal.so lib/libQt5Sensors.so.5 Plugins/libwebpdecoder.so.3.1.8
lib/platforms/libqminimalegl.so lib/libsharpyuv.so.0 Plugins/libsharpyuv.so.0.0.1
lib/platforms/libqlinuxfb.so lib/libQt5Widgets.so.5 Plugins/libwebpmux.so.3
lib/platforms/libqxcb.so Plugins/libsharpyuv.so
lib/libQt5XcbQpa.so.5.15.15 lib/libicuuc.so Plugins/libwebp.so.7.1.8
lib/libQt5DBus.so.5 lib/libicui18n.so.56.1 Plugins/libsharpyuv.so.0
lib/libicutu.so.56.1 lib/libicutest.so.56 Plugins/libIlmThread-3_2.so
lib/libicuio.so.56.1 lib/libQt5Xml.so.5.15.15 Plugins/libwebpdemux.so.2.0.14
lib/libQt5Gui.so.5.15.15 lib/libQt5Widgets.so.5.15.15 Plugins/libOpenEXRCore-3_2.so
lib/libsharpyuv.so.0.0.1 lib/libiculx.so.56 Plugins/libIex-3_2.so.29
lib/libicutu.so.56 lib/libQt5Core.so.5.15.15 Plugins/libOpenEXR.so
lib/libQt5Sensors.so.5.15.15 lib/libicule.so.56 Plugins/libwebpdecoder.so
lib/libicuuc.so.56 lib/libQt5Core.so.5 Plugins/libwebpdemux.so
lib/libQt5Network.so.5.15.15 lib/libiculx.so.56.1 Plugins/libOpenEXRUtil-3_2.so
lib/libicudata.so.56.1 lib/platformthemes/libqgtk3.so Plugins/libwebp.so
lib/libicuuc.so.56.1 lib/platformthemes/libqxdgdesktopportal.so Plugins/libwebpmux.so.3.0.13
lib/libiculx.so lib/libQt5Gui.so.5 Plugins/libwebpdecoder.so.3
lib/libicutest.so lib/libicuio.so Plugins/libIex-3_2.so
lib/libicule.so.56.1 Plugins/libImath-3_2.so
"

BUNDLED_LIBS_DEPEND="dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[widgets]
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	sensors? ( dev-qt/qtsensors:5 )
	dev-qt/qtsvg:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	dev-qt/qtdbus:5
	dev-libs/icu
	media-libs/libwebp
	media-libs/openjpeg:2
	media-libs/openexr"

RDEPEND=">=dev-libs/glib-2
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXt
	!bundled-libs? ( ${BUNDLED_LIBS_DEPEND} )
	"
DEPEND=""

S="${WORKDIR}/XnConvert"

src_prepare() {
	default

	if ! use bundled-libs ; then
		einfo Removing bundled libraries
		for libname in ${BUNDLED_LIBS} ; do
			rm -rv "${S}"/${libname} || die "Failed while removing bundled ${libname}"
		done
	fi
	if use bundled-libs ; then
		einfo Patching rpaths of bundled libraries
		for libname in $(find lib/ Plugins/ -name 'lib*so*' -exec chrpath {} \; | grep -v ORIGIN | \
		 cut -d : -f 1 ) ; do 
			patchelf --set-rpath '$ORIGIN' ${libname} || die "Failed to set runpath for ${libname}"
		done
		# special treatment for liblibraw
		chrpath -r '$ORIGIN' lib/liblibraw.so
	fi
}

src_install() {
	declare XNCONV_HOME=/opt/XnConvert

	# Install XnConvert in /opt
	dodir ${XNCONV_HOME%/*}
	mv "${S}" "${D}"${XNCONV_HOME} || die "Unable to install XnConvert folder"

	# Create /opt/bin/xnconvert
	dodir /opt/bin/
	dosym ${XNCONV_HOME}/xnconvert.sh /opt/bin/xnconvert

	# Install icon and .desktop for menu entry
	newicon "${D}"${XNCONV_HOME}/xnconvert.png ${PN}.png
	make_desktop_entry xnconvert XnConvert ${PN} "Graphics" || die "desktop file sed failed"
}

pkg_postinst(){
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
}
