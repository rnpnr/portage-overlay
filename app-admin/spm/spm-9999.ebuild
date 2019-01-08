EAPI=7

inherit git-r3

DESCRIPTION="Simple PoSix password manager"
HOMEPAGE="https://notabug.org/kl3/spm/"
EGIT_REPO_URI="https://notabug.org/kl3/spm.git"

LICENSE="GPL-3"
SLOT=0

RDEPEND="
	app-admin/pwgen
	app-crypt/gnupg
	app-text/tree
	x11-misc/xclip
"
src_configure() {
	default
	eapply "${FILESDIR}"/local.patch
}

src_compile() { :; }

src_install() {
	emake DESTDIR=${D} PREFIX=${EPREFIX}${LOCAL_PREFIX} install
	einstalldocs
}
