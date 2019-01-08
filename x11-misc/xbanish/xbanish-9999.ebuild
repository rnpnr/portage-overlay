EAPI=7
inherit git-r3

DESCRIPTION="banish the mouse cursor when typing, show it again when the mouse moves"
HOMEPAGE="https://github.com/jcs/xbanish"
EGIT_REPO_URI="https://github.com/jcs/xbanish.git"

SLOT="0"
IUSE="static"

RDEPEND="x11-libs/libX11"

src_prepare() {
	default

	sed	-e '/^X11BASE/{s:X11R6:X11:}' \
		-e '/^MANDIR/{s:man:share/man:}' \
		< Makefile > Makefile.new || die
	mv Makefile.new Makefile || die

	if uses static; then
		export LDFLAGS="${LDFLAGS} -static"
	fi
}

src_install() {
	emake DESTDIR="${D}" install
}
