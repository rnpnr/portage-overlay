EAPI=8
inherit git-r3 savedconfig

DESCRIPTION="simple generic tabbed frontend for xembed aware applications"
HOMEPAGE="https://tools.suckless.org/tabbed"
EGIT_REPO_URI="https://git.suckless.org/tabbed"

LICENSE="MIT-with-advertising"
SLOT="0"
IUSE="savedconfig static"

RDEPEND="x11-libs/libX11"
DEPEND="
	x11-base/xorg-proto
	${RDEPEND}
"

src_prepare() {
	default

	if use static; then
		export CFLAGS="${CFLAGS} -static"
		export LDFLAGS="${LDFLAGS} -static"
	fi

	restore_config config.h
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}${LOCAL_PREFIX}" install

	save_config config.h
}
