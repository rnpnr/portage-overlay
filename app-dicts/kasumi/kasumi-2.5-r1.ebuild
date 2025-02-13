# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Anthy dictionary maintenance tool"
HOMEPAGE="http://kasumi.osdn.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}/41436/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm64 ppc ~riscv sparc x86"
IUSE="nls"

RDEPEND="app-i18n/anthy
	virtual/libiconv
	x11-libs/gtk+:2
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-desktop.patch
	"${FILESDIR}"/${PN}-2.5-fix-build-gcc-11.patch
)

src_configure() {
	econf $(use_enable nls)
}
