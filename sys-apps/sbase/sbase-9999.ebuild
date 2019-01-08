EAPI=7

inherit git-r3

DESCRIPTION="Suckless unix tools"
HOMEPAGE="https://core.suckless.org/sbase"
EGIT_REPO_URI="https://git.suckless.org/sbase"

LICENSE="MIT-with-advertising"
SLOT=0
IUSE="+static"

src_configure() {
	default

	sed \
		-e '/^CC/d' \
		-e '/^CFLAGS/{s:=:+=:}' \
		-e '/^LDFLAGS/{s:=:+=:}' \
		< config.mk > config.mk.new || die
		mv config.mk.new config.mk

	if use static ; then
		export LDFLAGS="${LDFLAGS} -s -static"
	fi
}

src_install() {
	emake DESTDIR="${D}" CC=${CC} PREFIX=${EPREFIX}${LOCAL_PREFIX} install
	einstalldocs
}
