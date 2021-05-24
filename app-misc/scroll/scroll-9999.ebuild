EAPI=7
inherit git-r3 savedconfig

DESCRIPTION="A terminal emulator scroll back buffer"
HOMEPAGE="https://tools.suckless.org/scroll/"
EGIT_REPO_URI="https://git.suckless.org/scroll"

LICENSE="ISC"
SLOT="0"
IUSE="savedconfig +static"

src_prepare() {
	default
	
	sed	-e '/^CFLAGS/{s:=:+=:}' \
		-e '/^LDFLAGS/{s:=:+=:}' \
		-e '/^CFLAGS/{s:-Os::}' \
		-e '/^LDFLAGS/{s:-s::}' \
	< config.mk > config.mk.new || die
	mv config.mk.new config.mk
	
	if use static; then
		export LDFLAGS="${LDFLAGS} -s -static"
	fi

	restore_config config.h
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}${LOCAL_PREFIX}" install

	save_config config.h
}
