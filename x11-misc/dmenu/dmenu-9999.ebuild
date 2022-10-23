EAPI=8
inherit git-r3 savedconfig

DESCRIPTION="a generic, highly customizable, and efficient menu for the X Window System"
HOMEPAGE="https://tools.suckless.org/dmenu/"
EGIT_REPO_URI="https://git.suckless.org/dmenu"

LICENSE="MIT"
SLOT="0"
IUSE="savedconfig static xinerama"

RDEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXft
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

src_prepare() {
	default

	if use static; then
		export CFLAGS="${CFLAGS} -static"
		export LDFLAGS="${LDFLAGS} -static"
	fi

	if ! use xinerama; then
		sed /^XINERAMA/d <config.mk >config.mk.new
		mv config.mk.new config.mk
	fi

	restore_config config.h
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}${LOCAL_PREFIX}" install

	save_config config.h
}
