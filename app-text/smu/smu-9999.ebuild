EAPI=8
inherit git-r3

DESCRIPTION="smu - a Simple Markup Language"
HOMEPAGE="https://github.com/karlb/smu"
EGIT_REPO_URI="https://github.com/karlb/smu.git"

LICENSE="MIT"
SLOT="0"
IUSE="+static"

src_prepare() {
	default
	
	sed	-e '/^CFLAGS/{s:=:+=:}' \
		-e '/^LDFLAGS/{s:=:+=:}' \
		-e '/^CFLAGS/{s:-g -O0::}' \
		-e '/^CFLAGS/{s:-Werror::}' \
	< config.mk > config.mk.new || die
	mv config.mk.new config.mk
	
	if use static; then
		export LDFLAGS="${LDFLAGS} -s -static"
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}${LOCAL_PREFIX}" install
}
