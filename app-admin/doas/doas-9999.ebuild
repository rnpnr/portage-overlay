EAPI=8

inherit git-r3

DESCRIPTION="Portable OpenBSD doas"
HOMEPAGE="https://github.com/rnpnr/doas"
EGIT_REPO_URI="https://github.com/rnpnr/doas.git"

SLOT=0

src_install() {
	emake DESTDIR="${D}" PREFIX="${LOCAL_PREFIX}" install
	einstalldocs
}
