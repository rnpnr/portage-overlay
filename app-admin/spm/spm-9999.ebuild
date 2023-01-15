EAPI=8

inherit git-r3

DESCRIPTION="Simple PoSix password manager"
HOMEPAGE="https://github.com/rnpnr/spm"
EGIT_REPO_URI="https://github.com/rnpnr/spm.git"

LICENSE="GPL-3"
SLOT=0

RDEPEND="
	app-admin/pwgen
	app-crypt/gnupg
	app-text/tree
	x11-misc/xclip
"
src_compile() { :; }

src_install() {
	dobin spm
	doman spm.1
}
