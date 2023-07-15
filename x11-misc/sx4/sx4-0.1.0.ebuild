EAPI=8

inherit toolchain-funcs

DESCRIPTION="simple X11 rectangle selection tool"
HOMEPAGE="https://codeberg.org/NRK/sx4"

SRC_URI="https://codeberg.org/NRK/sx4/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

KEYWORDS="~amd64"
LICENSE="GPL-3+"
SLOT=0
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="${RDEPEND}"

src_compile() {
	$(tc-getCC) -o sx4 sx4.c ${CFLAGS} ${LDFLAGS} -l X11 -l Xext
}

src_install() {
	dobin sx4
	doman sx4.1
}
