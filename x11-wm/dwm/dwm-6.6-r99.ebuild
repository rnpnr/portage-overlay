# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="a dynamic window manager for X11 (dependencies only)"
HOMEPAGE="https://dwm.suckless.org/"

KEYWORDS="amd64 ~arm arm64 ppc ppc64 ~riscv x86"

LICENSE="MIT"
SLOT="0"
IUSE="xinerama static-libs"

RDEPEND="
	media-libs/fontconfig
	x11-libs/libX11
	>=x11-libs/libXft-2.3.5
	xinerama? ( x11-libs/libXinerama )
"
DEPEND="
	${RDEPEND}
	xinerama? ( x11-base/xorg-proto )
"
