# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-2 lua5-3 lua5-4 )

inherit lua-single optfeature

KEYWORDS="~amd64 ~arm ~riscv ~x86"

DESCRIPTION="modern, legacy free, simple yet efficient vim-like editor (dependencies only)"
HOMEPAGE="https://github.com/martanne/vis"
SLOT="0"
IUSE="+ncurses +lua selinux static-libs test tre"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

# - Known to also work with NetBSD curses
# lpeg: https://github.com/martanne/vis-test/issues/28
DEPEND="
	dev-libs/libtermkey[static-libs?]
	sys-apps/acl[static-libs?]
	ncurses? ( sys-libs/ncurses:0=[static-libs?] )
	lua? ( ${LUA_DEPS} )
	tre? ( dev-libs/tre )
	test? (
		$(lua_gen_cond_dep 'dev-lua/lpeg[${LUA_USEDEP}]')
		$(lua_gen_cond_dep 'dev-lua/busted[${LUA_USEDEP}]')
	)"
RDEPEND="${DEPEND}
	app-eselect/eselect-vi"

update_symlinks() {
	einfo "Calling eselect vi update --if-unset"
	eselect vi update --if-unset
}

pkg_postrm() {
	update_symlinks
}

pkg_postinst() {
	update_symlinks
	optfeature "syntax highlighting support" dev-lua/lpeg
}
