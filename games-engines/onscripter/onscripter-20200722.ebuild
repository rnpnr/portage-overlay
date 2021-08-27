EAPI=7

DESCRIPTION="Engine for japanese Visual Novels."
HOMEPAGE="https://onscripter.osdn.jp/onscripter.html"
SRC_URI="https://onscripter.osdn.jp/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

REQUIRED_USE=${LUA_REQUIRED_USE}

LUA_COMPAT=(lua5-1)

inherit cmake lua-single

RDEPEND="
	${LUA_DEPS}
	>=media-libs/libsdl-1.2.6
	>=media-libs/sdl-image-1.2.3
	>=media-libs/sdl-mixer-1.2.5
	>=media-libs/sdl-sound-1.0.3
	>=media-libs/sdl-ttf-2.0.6
	>=media-libs/smpeg-0.4.4
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/0001-fix-smpeg-header-name.patch
	"${FILESDIR}"/0002-fix-lua-header-name.patch
	"${FILESDIR}"/0003-CMakeLists.patch
)

src_configure() {
	default
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}${LOCAL_PREFIX}"
	)
	cmake_src_configure
}
