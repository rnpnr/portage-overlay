# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 savedconfig

DESCRIPTION="simple terminal implementation for X"
HOMEPAGE="https://st.suckless.org/"
EGIT_REPO_URI="https://git.suckless.org/st"

LICENSE="MIT-with-advertising"
SLOT="0"
IUSE="savedconfig +static"

RDEPEND="
	>=sys-libs/ncurses-6.0:0=
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXft
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"

src_prepare() {
	default

	sed	-e '/^X11INC/{s:X11R6/include:include/X11:}' \
		-e '/^X11LIB/{s:X11R6/lib:lib/X11:}' \
		< config.mk > config.mk.new || die
		mv config.mk.new config.mk

	if uses static; then
		export CFLAGS="${CFLAGS} -static"
		export LDFLAGS="${LDFLAGS} -static"
	fi

	restore_config config.h
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}${LOCAL_PREFIX}" install
	dodoc TODO

	save_config config.h
}
