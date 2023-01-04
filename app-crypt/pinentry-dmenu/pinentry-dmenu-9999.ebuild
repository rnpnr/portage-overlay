EAPI=8
inherit git-r3 savedconfig

DESCRIPTION="A pinentry program with the charm of dmenu"
HOMEPAGE="https://github.com/rnpnr/pinentry-dmenu"
EGIT_REPO_URI="https://github.com/rnpnr/pinentry-dmenu.git"

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
	>=dev-libs/libassuan-2.1
	>=dev-libs/libgpg-error-1.17
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
