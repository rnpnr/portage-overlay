# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 git-r3 readme.gentoo-r1

DESCRIPTION="More usable youtube-dl fork"
HOMEPAGE="https://github.com/yt-dlp"
EGIT_REPO_URI="https://github.com/yt-dlp/yt-dlp.git"

LICENSE="public-domain"
SLOT="0"
IUSE="symlink"

RDEPEND="
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	symlink? ( !net-misc/youtube-dl )
"

distutils_enable_tests nose

src_prepare() {
	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
}

python_test() {
	emake offlinetest
}

python_install_all() {
	# no manpage because it requires pandoc to generate

	distutils-r1_python_install_all

	use symlink && dosym -r /usr/bin/yt-dlp /usr/bin/youtube-dl
}

pkg_postinst() {
	if ! has_version media-video/ffmpeg; then
		elog "${PN} works fine on its own on most sites. However, if you want"
		elog "to convert video/audio, you'll need media-video/ffmpeg."
		elog "On some sites - most notably YouTube - videos can be retrieved in"
		elog "a higher quality format without sound. ${PN} will detect whether"
		elog "ffmpeg is present and automatically pick the best option."
	fi
	if ! has_version media-video/rtmpdump; then
		elog
		elog "Videos or video formats streamed via RTMP protocol can only be"
		elog "downloaded when media-video/rtmpdump is installed."
	fi
	if ! has_version media-video/mplayer && ! has_version media-video/mpv; then
		elog
		elog "Downloading MMS and RTSP videos requires either media-video/mplayer"
		elog "or media-video/mpv to be installed."
	fi
	if ! has_version media-video/atomicparsley; then
		elog
		elog "Install media-video/atomicparsley if you want ${PN} to embed thumbnails"
		elog "from the metadata into the resulting MP4/M4A files."
	fi
	if has_version media-video/mpv && ! use symlink; then
		elog
		elog "To use media-video/mpv with ${PN} you may want to this to your mpv.conf:"
		elog "script-opts=ytdl_hook-ytdl_path=${PN}"
	fi
}
