EAPI=7	

inherit git-r3

DESCRIPTION="RSS and Atom parser"
HOMEPAGE="https://git.codemadness.org/sfeed/"
EGIT_REPO_URI="git://git.codemadness.org/sfeed"

LICENSE="ISC"
SLOT=0
IUSE="+static"

src_configure() {
	default

	if use static ; then
		export CFLAGS="${CFLAGS} -static"
		export LDFLAGS="${LDFLAGS} -s -static"
	fi
}

src_install() {
	emake	DESTDIR="${D}" \
		PREFIX="${EPREFIX}${LOCAL_PREFIX}" \
		MANPREFIX="${EPREFIX}${LOCAL_PREFIX}/share/man" \
		install
	einstalldocs
}
