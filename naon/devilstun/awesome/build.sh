TERMUX_PKG_HOMEPAGE=https://github.com/awesomeWM/awesome
TERMUX_PKG_DESCRIPTION="A highly configurable, next generation framework window manager for X"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# Latest release version 4.3 does not support Lua 5.4.
_COMMIT=5077c8381b6bf7fb8215d24d1f0c683816e27a55
TERMUX_PKG_VERSION=2022.10.31
TERMUX_PKG_SRCURL=https://github.com/awesomeWM/awesome.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="dbus, gdk-pixbuf, glib, libcairo, liblua54, libx11, libxcb, libxdg-basedir, libxkbcommon, lua-lgi, pango, startup-notification, xcb-util, xcb-util-cursor, xcb-util-keysyms, xcb-util-wm, xcb-util-xrm"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DLUA_MATH_LIBRARY=
"
TERMUX_PKG_HOSTBUILD=true

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}

termux_step_host_build() {
	local prefix="$TERMUX_PKG_HOSTBUILD_DIR/_prefix"

	local IMAGEMAGICK_BUILD_SH=$TERMUX_SCRIPTDIR/packages/imagemagick/build.sh
	local IMAGEMAGICK_SRCURL=$(bash -c ". $IMAGEMAGICK_BUILD_SH; echo \$TERMUX_PKG_SRCURL")
	local IMAGEMAGICK_SHA256=$(bash -c ". $IMAGEMAGICK_BUILD_SH; echo \$TERMUX_PKG_SHA256")
	local IMAGEMAGICK_TARFILE=$TERMUX_PKG_CACHEDIR/$(basename $IMAGEMAGICK_SRCURL)
	termux_download $IMAGEMAGICK_SRCURL $IMAGEMAGICK_TARFILE $IMAGEMAGICK_SHA256
	mkdir -p imagemagick
	cd imagemagick
	tar xf $IMAGEMAGICK_TARFILE --strip-components=1
	./configure --prefix="$prefix" --with-png
	make -j $TERMUX_MAKE_PROCESSES
	make install
}

termux_step_pre_configure() {
	export PATH="$TERMUX_PKG_HOSTBUILD_DIR/_prefix/bin:$PATH"

	local bin="$TERMUX_PKG_BUILDDIR/_bin"
	mkdir -p "$bin"
	sed -e "s|@PREGEN_DIR@|$TERMUX_PKG_BUILDER_DIR/pregen|g" \
		"$TERMUX_PKG_BUILDER_DIR/lua-wrapper.in" > "$bin/lua"
	chmod 0700 "$bin/lua"
	touch "$bin/lgi-check"
	chmod 0700 "$bin/lgi-check"
	export PATH="$bin:$PATH"
}
