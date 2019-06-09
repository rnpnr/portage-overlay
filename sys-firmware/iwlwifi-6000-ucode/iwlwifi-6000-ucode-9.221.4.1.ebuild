EAPI=7

DESCRIPTION="Intel Corporation Centrino Ultimate-N 6300 Firmware"
HOMEPAGE="https://wireless.wiki.kernel.org/en/users/Drivers/iwlwifi"
SRC_URI="https://wireless.wiki.kernel.org/_media/en/users/drivers/${P}.tgz"

LICENSE="ipw3945"
SLOT=0

src_compile() { :; }

src_install() {
	insinto /lib/firmware
	doins iwlwifi-6000-4.ucode || die
}
