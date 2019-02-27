# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# @ECLASS: mozconfig-v6.52.eclass
# @MAINTAINER:
# mozilla team <mozilla@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7
# @BLURB: the new mozilla common configuration eclass for FF33 and newer, v6
# @DESCRIPTION:
# This eclass is used in mozilla ebuilds (firefox, thunderbird, seamonkey)
# to provide a single common place for the common mozilla engine compoments.
#
# The eclass provides all common dependencies as well as common use flags.
#
# Some use flags which may be optional in particular mozilla packages can be
# supported through setting eclass variables.
#
# This eclass inherits mozconfig helper functions as defined in mozcoreconf-v3,
# and so ebuilds inheriting this eclass do not need to inherit that.

inherit flag-o-matic toolchain-funcs mozcoreconf-v5

# @ECLASS-VARIABLE: MOZCONFIG_OPTIONAL_GTK3
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this variable before the inherit line, when an ebuild can provide
# optional gtk3 support via IUSE="force-gtk3".  Currently this would include
# thunderbird and seamonkey in the future, once support is ready for testing.
#
# Leave the variable UNSET if gtk3 support should not be optionally available.
# Set the variable to "enabled" if the use flag should be enabled by default.
# Set the variable to any value if the use flag should exist but not be default-enabled.
# If gtk+:3 is to be the standard toolkit, do not use this and instead use
# MOZCONFIG_OPTIONAL_GTK2ONLY.

# @ECLASS-VARIABLE: MOZCONFIG_OPTIONAL_GTK2ONLY
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this variable before the inherit line, when an ebuild can provide
# optional gtk2-only support via IUSE="gtk2".
#
# Note that this option conflicts directly with MOZCONFIG_OPTIONAL_GTK3, both
# variables cannot be set at the same time and this variable will be ignored if
# MOZCONFIG_OPTIONAL_GTK3 is set.
#
# Leave the variable UNSET if gtk2-only support should not be available.
# Set the variable to "enabled" if the use flag should be enabled by default.
# Set the variable to any value if the use flag should exist but not be default-enabled.

# use-flags common among all mozilla ebuilds
IUSE="${IUSE} debug neon pulseaudio selinux startup-notification system-cairo
	system-harfbuzz system-icu system-jpeg system-libevent system-sqlite system-libvpx"

# some notes on deps:
# gtk:2 minimum is technically 2.10 but gio support (enabled by default) needs 2.14
# media-libs/mesa needs to be 10.2 or above due to a bug with flash+vdpau

RDEPEND=">=app-text/hunspell-1.2:=
	dev-libs/atk
	dev-libs/expat
	>=x11-libs/cairo-1.10[X]
	>=x11-libs/gtk+-2.18:2
	x11-libs/gdk-pixbuf
	>=x11-libs/pango-1.22.0
	>=media-libs/libpng-1.6.25:0=[apng]
	>=media-libs/mesa-10.2:*
	media-libs/fontconfig
	>=media-libs/freetype-2.4.10
	kernel_linux? ( !pulseaudio? ( media-libs/alsa-lib ) )
	pulseaudio? ( || ( media-sound/pulseaudio
		>=media-sound/apulse-0.1.9 ) )
	virtual/freedesktop-icon-theme
	startup-notification? ( >=x11-libs/startup-notification-0.8 )
	>=dev-libs/glib-2.26:2
	>=sys-libs/zlib-1.2.3
	>=virtual/libffi-3.0.10
	virtual/ffmpeg
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXt
	system-cairo? ( >=x11-libs/cairo-1.12[X,xcb] >=x11-libs/pixman-0.19.2 )
	system-icu? ( >=dev-libs/icu-58.1:= )
	system-jpeg? ( >=media-libs/libjpeg-turbo-1.2.1 )
	system-libevent? ( >=dev-libs/libevent-2.0:0= )
	system-sqlite? ( >=dev-db/sqlite-3.17.0:3[secure-delete,debug=] )
	system-libvpx? ( >=media-libs/libvpx-1.5.0:0=[postproc] )
	system-harfbuzz? ( >=media-libs/harfbuzz-1.3.3:0= >=media-gfx/graphite2-1.3.8 )
"

if [[ -n ${MOZCONFIG_OPTIONAL_GTK3} ]]; then
	MOZCONFIG_OPTIONAL_GTK2ONLY=
	if [[ ${MOZCONFIG_OPTIONAL_GTK3} = "enabled" ]]; then
		IUSE+=" +force-gtk3"
	else
		IUSE+=" force-gtk3"
	fi
	RDEPEND+=" force-gtk3? ( >=x11-libs/gtk+-3.4.0:3 )"
elif [[ -n ${MOZCONFIG_OPTIONAL_GTK2ONLY} ]]; then
	if [[ ${MOZCONFIG_OPTIONAL_GTK2ONLY} = "enabled" ]]; then
		IUSE+=" +gtk2"
	else
		IUSE+=" gtk2"
	fi
	RDEPEND+=" !gtk2? ( >=x11-libs/gtk+-3.4.0:3 )"
fi

DEPEND="app-arch/zip
	app-arch/unzip
	>=sys-devel/binutils-2.16.1
	sys-apps/findutils
	pulseaudio? ( media-sound/pulseaudio )
	${RDEPEND}"

RDEPEND+="
	pulseaudio? ( || ( media-sound/pulseaudio
		>=media-sound/apulse-0.1.9 ) )
	selinux? ( sec-policy/selinux-mozilla )"

# @FUNCTION: mozconfig_config
# @DESCRIPTION:
# Set common configure options for mozilla packages.
# Call this within src_configure() phase, after mozconfig_init
#
# Example:
#
# inherit mozconfig-v6.46
#
# src_configure() {
# 	mozconfig_init
# 	mozconfig_config
#	# ... misc ebuild-unique settings via calls to
#	# ... mozconfig_{annotate,use_with,use_enable}
#	mozconfig_final
# }

mozconfig_config() {
	# Migrated from mozcoreconf-2
	mozconfig_annotate 'system_libs' \
		--with-system-zlib \
		--with-system-bz2

	if has bindist ${IUSE}; then
		mozconfig_use_enable !bindist official-branding
		if [[ ${PN} == firefox ]] && use bindist ; then
			mozconfig_annotate '' --with-branding=browser/branding/aurora
		fi
	fi

	# Enable position independent executables
	mozconfig_annotate 'enabled by Gentoo' --enable-pie
	mozconfig_use_enable debug
	mozconfig_use_enable debug tests

	if ! use debug ; then
		mozconfig_annotate 'disabled by Gentoo' --disable-debug-symbols
	else
		mozconfig_annotate 'enabled by Gentoo' --enable-debug-symbols
	fi

	mozconfig_use_enable startup-notification

	# These are enabled by default in all mozilla applications
	mozconfig_annotate '' --with-system-nspr --with-nspr-prefix="${SYSROOT}${EPREFIX}"/usr
	mozconfig_annotate '' --with-system-nss --with-nss-prefix="${SYSROOT}${EPREFIX}"/usr
	mozconfig_annotate '' --x-includes="${SYSROOT}${EPREFIX}"/usr/include --x-libraries="${SYSROOT}${EPREFIX}"/usr/$(get_libdir)
	if use system-libevent; then
		mozconfig_annotate '' --with-system-libevent="${SYSROOT}${EPREFIX}"/usr
	fi
	mozconfig_annotate '' --prefix="${EPREFIX}"/usr
	mozconfig_annotate '' --libdir="${EPREFIX}"/usr/$(get_libdir)
	mozconfig_annotate 'Gentoo default' --enable-system-hunspell
	mozconfig_annotate '' --disable-gnomeui
	mozconfig_annotate '' --enable-gio
	mozconfig_annotate '' --disable-crashreporter
	mozconfig_annotate 'Gentoo default' --with-system-png
	mozconfig_annotate '' --enable-system-ffi
	mozconfig_annotate 'Gentoo default to honor system linker' --disable-gold
	mozconfig_annotate '' --disable-gconf

	# default toolkit is cairo-gtk2, optional use flags can change this
	local toolkit="cairo-gtk2"
	local toolkit_comment=""
	if [[ -n ${MOZCONFIG_OPTIONAL_GTK3} ]]; then
		if use force-gtk3; then
			toolkit="cairo-gtk3"
			toolkit_comment="force-gtk3 use flag"
		fi
	fi
	if [[ -n ${MOZCONFIG_OPTIONAL_GTK2ONLY} ]]; then
		if ! use gtk2 ; then
			toolkit="cairo-gtk3"
		else
			toolkit_comment="gtk2 use flag"
		fi
	fi
	mozconfig_annotate "${toolkit_comment}" --enable-default-toolkit=${toolkit}

	# Disable malloc wrappers
	mozconfig_annotate '' --disable-jemalloc
	mozconfig_annotate '' --disable-replace-malloc

	mozconfig_annotate '' --disable-elf-hack

	# Disable bad features
	mozconfig_annotate '' --disable-webrtc
	mozconfig_annotate '' --disable-necko-wifi
	mozconfig_annotate '' --disable-dbus

	# Instead of the standard --build= and --host=, mozilla uses --host instead
	# of --build, and --target intstead of --host.
	# Note, mozilla also has --build but it does not do what you think it does.
	# Set both --target and --host as mozilla uses python to guess values otherwise
	mozconfig_annotate '' --target="${CHOST}"
	mozconfig_annotate '' --host="${CBUILD:-${CHOST}}"

	mozconfig_use_enable pulseaudio
	# force the deprecated alsa sound code if pulseaudio is disabled
	if use kernel_linux && ! use pulseaudio ; then
		mozconfig_annotate '-pulseaudio' --enable-alsa
	fi

	mozconfig_use_enable system-cairo
	mozconfig_use_enable system-sqlite
	mozconfig_use_with system-jpeg
	mozconfig_use_with system-icu
	mozconfig_use_with system-libvpx
	mozconfig_use_with system-harfbuzz
	mozconfig_use_with system-harfbuzz system-graphite2

	# Modifications to better support ARM, bug 553364
	if use neon ; then
		mozconfig_annotate '' --with-fpu=neon
		mozconfig_annotate '' --with-thumb=yes
		mozconfig_annotate '' --with-thumb-interwork=no
	fi
	if [[ ${CHOST} == armv* ]] ; then
		mozconfig_annotate '' --with-float-abi=hard
		if ! use system-libvpx ; then
			sed -i -e "s|softfp|hard|" \
				"${S}"/media/libvpx/moz.build
		fi
	fi
}

# @FUNCTION: mozconfig_install_prefs
# @DESCRIPTION:
# Set preferences into the prefs.js file specified as a parameter to
# the function.  This sets both some common prefs to all mozilla
# packages, and any prefs that may relate to the use flags administered
# by mozconfig_config().
#
# Call this within src_install() phase, after copying the template
# prefs file (if any) from ${FILESDIR}
#
# Example:
#
# inherit mozconfig-v6.46
#
# src_install() {
# 	cp "${FILESDIR}"/gentoo-default-prefs.js \
#	"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js"  \
#	|| die
#
# 	mozconfig_install_prefs \
#	"${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js"
#
#	...
# }

mozconfig_install_prefs() {
	local prefs_file="${1}"

	einfo "Adding prefs from mozconfig to ${prefs_file}"

	# set dictionary path, to use system hunspell
	echo "pref(\"spellchecker.dictionary_path\", \"${EPREFIX}/usr/share/myspell\");" \
		>>"${prefs_file}" || die

	# force the graphite pref if system-harfbuzz is enabled, since the pref cant disable it
	if use system-harfbuzz ; then
		echo "sticky_pref(\"gfx.font_rendering.graphite.enabled\",true);" \
			>>"${prefs_file}" || die
	fi
}
