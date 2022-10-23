EAPI=8

inherit git-r3

DESCRIPTION="Suckless unix tools"
HOMEPAGE="https://core.suckless.org/sbase"
EGIT_REPO_URI="https://git.suckless.org/sbase"

LICENSE="MIT"
SLOT=0
IUSE="+static"

src_configure() {
	default

	if use static ; then
		export LDFLAGS="${LDFLAGS} -s -static"
	fi
}

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=${EPREFIX}${LOCAL_PREFIX} install
	einstalldocs
}
