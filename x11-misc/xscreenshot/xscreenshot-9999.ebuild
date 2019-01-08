EAPI=7	

inherit git-r3

DESCRIPTION="xscreenshot - take a screenshot"
HOMEPAGE="https://git.2f30.org/xscreenshot/log.html"
EGIT_REPO_URI="git://git.2f30.org/xscreenshot.git"

LICENSE="MIT-with-advertising"
SLOT=0
IUSE="static"

DEPEND="x11-libs/libX11"

src_configure() {
	default

	sed	-e '/^X11INC/{s:X11R6/include:include/X11:}' \
		-e '/^X11LIB/{s:/X11R6::}' \
		-e '/^CFLAGS/{s:=:+=:;s:-O0 -g::}' \
		-e '/^LDFLAGS/{s:=:+=:}' \
		-e '/^CC/d' \
		< config.mk > config.mk.new || die
	mv config.mk.new config.mk || die

	use static && export LDFLAGS="${LDFLAGS} -s -static"
}

src_install() {
	emake DESTDIR="${D}" CC=${CC} PREFIX="${EPREFIX}${LOCAL_PREFIX}" install
	einstalldocs
}
