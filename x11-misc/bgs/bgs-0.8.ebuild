EAPI=7

DESCRIPTION="https://github.com/Gottox/bgs"
HOMEPAGE="https://github.com/Gottox/bgs"
SRC_URI="https://github.com/Gottox/bgs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT=0
IUSE="static"
DEPEND="
	media-libs/imlib2
	x11-libs/libX11
"

src_configure() {
	default

	if use static; then
		export LDFLAGS="${LDFLAGS} -static"
	fi
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}${LOCAL_PREFIX}" install
}
