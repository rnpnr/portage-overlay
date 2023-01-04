# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 savedconfig

DESCRIPTION="a dynamic window manager for X11"
HOMEPAGE="https://dwm.suckless.org/"
EGIT_REPO_URI="https://github.com/rnpnr/dwm.git"

LICENSE="MIT"
SLOT="0"
IUSE="xinerama savedconfig static"

RDEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXft
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	xinerama? ( x11-base/xorg-proto )
"

src_prepare() {
	default

	sed	-e '/^CC/d' \
		-e '/^X11INC/{s:X11R6/include:include/X11:}' \
		-e '/^X11LIB/{s:/X11R6::}' \
		-e '/^CFLAGS/{s:=:+=:}' \
		-e '/^LDFLAGS/{s:=:+=:}' \
		< config.mk > config.mk.new || die
		mv config.mk.new config.mk

	if ! use xinerama; then
		sed	-e '/^XINERAMALIBS/d' \
			-e '/^XINERAMAFLAGS/d' \
			< config.mk > config.mk.new || die
			mv config.mk.new config.mk
	fi

	if use static; then
		export LDFLAGS="${LDFLAGS} -static"
	fi

	restore_config config.h
}

src_compile() {
		emake CC=${CC} dwm
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}${LOCAL_PREFIX}" install

	save_config config.h
}
