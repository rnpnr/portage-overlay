EAPI=8

inherit git-r3

DESCRIPTION="Portable OpenBSD ksh, based on the Public Domain Korn Shell (pdksh)"
HOMEPAGE="https://github.com/ibara/oksh"
EGIT_REPO_URI="https://github.com/ibara/oksh.git"

LICENSE="public-domain"
SLOT=0
IUSE="+static +ksh curses"

src_configure() {
	econf CC=${CC} \
		$(use_enable static) \
		$(use_enable ksh) \
		$(use_enable curses) \
		--prefix=/ \
		--bindir=/bin \
		--mandir=/usr/share/man
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}

pkg_postinst() {
	if ! grep -q '^/bin/ksh$' "${EROOT}"/etc/shells ; then
		ebegin "Updating /etc/shells"
		echo "/bin/ksh" >> "${EROOT}"/etc/shells
		eend $?
	fi
}
