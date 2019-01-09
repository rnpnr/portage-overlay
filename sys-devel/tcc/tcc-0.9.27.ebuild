EAPI=7

DESCRIPTION="A very small C compiler for ix86/amd64"
HOMEPAGE="http://bellard.org/tcc/"
SRC_URI="http://download.savannah.gnu.org/releases/tinycc/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"

IUSE="+static"

src_configure() {
	econf --cc=${CC} \
		--prefix="${EPREFIX}${LOCAL_PREFIX}" \
		--config-musl \
		$(use_enable static)
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}
