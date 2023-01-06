EAPI=8

DESCRIPTION="A minimal Linux console hex editor"
HOMEPAGE="https://yx7.cc/code"
SRC_URI="https://yx7.cc/code/hyx/${P}.tar.xz"

SLOT=0
IUSE="+static"

src_configure() {
	default

	if use static; then
		export CFLAGS="${CFLAGS} -static"
	fi
}

src_install() {
	emake DESTDIR="${D}"
	into ${EPREFIX}${LOCAL_PREFIX}
		dobin hyx
}
