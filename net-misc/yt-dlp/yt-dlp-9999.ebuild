# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1 git-r3 optfeature

DESCRIPTION="More usable youtube-dl fork"
HOMEPAGE="https://github.com/yt-dlp"
EGIT_REPO_URI="https://github.com/yt-dlp/yt-dlp.git"

LICENSE="Unlicense"
SLOT="0"
IUSE="symlink"

RDEPEND="
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	symlink? ( !net-misc/youtube-dl )
"

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	# adjust requires for pycryptodome and optional dependencies (bug #828466)
	sed -ri requirements.txt \
		-e "s/^(pycryptodome)x/\1/" \
		-e "/^(brotli.*|mutagen|websockets)/d" || die
}

python_test() {
	epytest -m 'not download' -p no:markdown
}

python_install_all() {
	# no manpage because it requires pandoc to generate

	distutils-r1_python_install_all

	use symlink && dosym -r /usr/bin/yt-dlp /usr/bin/youtube-dl
}

pkg_postinst() {
	optfeature "various features (merging tracks, streamed content)" media-video/ffmpeg
	has_version media-video/atomicparsley || # allow fallback but don't advertise
	optfeature "embedding metadata thumbnails in MP4/M4A files" media-libs/mutagen

	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog 'A wrapper using "yt-dlp --compat-options youtube-dl" was installed'
		elog 'as "youtube-dl". This is strictly for compatibility and it is'
		elog 'recommended to use "yt-dlp" directly, it may be removed in the future.'
	fi
	if has_version media-video/mpv && ! use symlink; then
		elog
		elog "To use media-video/mpv with ${PN} you may want to this to your mpv.conf:"
		elog "script-opts=ytdl_hook-ytdl_path=${PN}"
	fi
}
