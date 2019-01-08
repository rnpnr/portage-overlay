# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 savedconfig

DESCRIPTION="Simple generic tabbed fronted to xembed aware applications"
HOMEPAGE="https://tools.suckless.org/tabbed"
EGIT_REPO_URI="https://git.suckless.org/tabbed"

SLOT="0"
IUSE="static"

RDEPEND="x11-libs/libX11"
DEPEND="
	x11-base/xorg-proto
	${RDEPEND}
"


src_prepare() {
	default

	if uses static; then
		export LDFLAGS="${LDFLAGS} -static"
	fi

	restore_config config.h
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}${LOCAL_PREFIX}" install

	save_config config.h
}
