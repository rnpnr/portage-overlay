EAPI=8

inherit git-r3

DESCRIPTION="Portable OpenBSD ksh, based on the Public Domain Korn Shell (pdksh)"
HOMEPAGE="https://github.com/ibara/oksh"
EGIT_REPO_URI="https://github.com/ibara/oksh.git"

LICENSE="public-domain"
SLOT=0
IUSE="+static +ksh curses"

RDEPEND="ksh? ( !app-shells/ksh )"

src_configure() {
	econf CC=${CC} \
		$(use_enable static) \
		$(use_enable curses) \
		--prefix="${EPREFIX}"/ \
		--bindir="${EPREFIX}"/bin \
		--mandir="${EPREFIX}"/usr/share/man
}

src_install() {
	emake DESTDIR="${D}" install
	use ksh && dosym oksh /bin/ksh || die
	einstalldocs
	use ksh && dosym oksh.1.gz "${EPREFIX}"/usr/share/man/man1/ksh.1.gz || die
}

pkg_postinst() {
	if ! grep -q '^/bin/oksh$' "${EROOT}"/etc/shells ; then
		ebegin "Updating /etc/shells"
		echo "/bin/oksh" >> "${EROOT}"/etc/shells
		eend $?
	fi
	if use ksh && ! grep -q '^/bin/ksh$' "${EROOT}"/etc/shells ; then
		ebegin "Updating /etc/shells"
		echo "/bin/ksh" >> "${EROOT}"/etc/shells
		eend $?
	fi
}
