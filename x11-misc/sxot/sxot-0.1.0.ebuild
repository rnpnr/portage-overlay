EAPI=8

inherit toolchain-funcs

DESCRIPTION="simple X11 screenshot tool"
HOMEPAGE="https://codeberg.org/NRK/sxot"

SRC_URI="https://codeberg.org/NRK/sxot/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

KEYWORDS="~amd64"
LICENSE="GPL-3+"
SLOT=0
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXfixes
"
DEPEND="${RDEPEND}"

src_compile() {
	$(tc-getCC) -o sxot sxot.c ${CFLAGS} ${LDFLAGS} -l X11 -l Xfixes
}

src_install() {
	dobin sxot
	dobin etc/optipng-pipe
}
