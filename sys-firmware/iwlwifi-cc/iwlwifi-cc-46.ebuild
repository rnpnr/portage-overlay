EAPI=7

DESCRIPTION="Intel® Wi-Fi 6 AX200 160MHz Firmware"
HOMEPAGE="https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi"
SRC_URI="https://wireless.wiki.kernel.org/_media/en/users/drivers/iwlwifi/${P}.3cfab8da.0.tgz"

LICENSE="ipw3945"
SLOT=0

src_unpack() {
	if [[ -n ${A} ]]; then
		unpack ${A}
	fi
	mv ${P}.3cfab8da.0 iwlwifi-cc-46
}

src_compile() { :; }

src_install() {
	insinto /lib/firmware
	doins iwlwifi-cc-a0-46.ucode || die
}
