TERMUX_PKG_HOMEPAGE=https://github.com/CDrummond/cantata
TERMUX_PKG_DESCRIPTION="Qt client for the music player daemon (MPD)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Yisus7u7 <dev.yisus@hotmail.com>"
TERMUX_PKG_VERSION=2.5.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/CDrummond/cantata/releases/download/v${TERMUX_PKG_VERSION}/cantata-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=eb7e00ab3f567afaa02ea2c86e2fe811a475afab93182b95922c6eb126821724
TERMUX_PKG_DEPENDS="qt5-qtbase, qt5-qtmultimedia, qt5-qtsvg, qt5-qtxmlpatterns, zlib, taglib, ffmpeg, mpg123, avahi, libcddb, libmusicbrainz, mpd"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
