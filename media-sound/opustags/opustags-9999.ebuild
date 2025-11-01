EAPI=8

inherit git-r3 cmake

DESCRIPTION="View and edit opus tags"
HOMEPAGE="https://github.com/fmang/opustags"
EGIT_REPO_URI="https://github.com/fmang/opustags.git"

LICENSE="BSD"
SLOT=0
IUSE="+static" 

DEPENDS="media-libs/libogg"

src_configure() {
	default
	
	use static && LDFLAGS="${LDFLAGS} -s -static"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${LOCAL_PREFIX}"
	)
	cmake_src_configure
}
