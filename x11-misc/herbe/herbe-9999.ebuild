EAPI=7
inherit git-r3 savedconfig

DESCRIPTION="Daemon-less notifications without D-Bus"
HOMEPAGE="https://github.com/dudik/herbe"
EGIT_REPO_URI="https://github.com/dudik/herbe.git"

LICENSE="MIT"
SLOT="0"
IUSE="savedconfig static"

DEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	x11-libs/libXft
"

src_prepare() {
	default

	sed -e '/^CFLAGS/{s:=:+=:}' \
	< Makefile > Makefile.new || die
	mv Makefile.new Makefile
	
	if use static; then
		export CFLAGS="${CFLAGS} -s -static"
		export LDFLAGS="${LDFLAGS} -s -static"
	fi
	
	restore_config config.h
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}${LOCAL_PREFIX}" install

	save_config config.h
}
