#!/bin/bash
# The realme 8i's firmware, out of YOUR phone's Android, into fw-*/ (at the top of the HakiOS tree, or next to this repository's mtkloader/)
# (git ignores them: they are the vendor's, and nothing of the vendor's is in the repository).
#
#   fw-touch/FW_NF_ILI7807S_*.bin   the touch controller's (Ilitek ILI7807S, no flash: it is sent at every reset). The
#                                   file for the phone's own panel maker (BOE or HLT), as /proc/devinfo/tp names it
#   fw-connsys/                     CONNSYS's (soc2_2), for Wi-Fi and Bluetooth: the set for the MT6631 A-die (*_2_1*;
#                                   the *_2a_1* set beside it is the MT6635's)
#
# Android keeps them where the shell user cannot read (SELinux), so this needs root on the phone
# (Magisk's su): they are copied to a temporary folder, pulled, and the folder is removed. Read only:
# nothing on the phone is changed.
set -e
S=${HAKIOS_SERIAL:?set HAKIOS_SERIAL to the serial of your phone, as adb devices shows it}
# into the top of the HakiOS tree this repository is synced into (devices/spaced/), where mtk/loader looks; else (or with a
# directory given) next to this repository's own mtkloader/
HERE="$(cd "$(dirname "$0")" && pwd)"
if [ -z "${1:-}" ] && [ -d "$HERE/../../mtk/loader" ]; then OUT="$(cd "$HERE/../.." && pwd)"; else OUT="${1:-$HERE}"; fi
TMP=/data/local/tmp/hakios-fw
CONNSYS="soc2_2_ram_mcu_2_1_hdr.bin soc2_2_ram_wifi_2_1_hdr.bin soc2_2_ram_bt_2_1_hdr.bin
	WIFI_RAM_CODE_soc2_2_2_1.bin WMT_SOC.cfg BT_FW.cfg"

# su reads the commands on stdin; /proc/devinfo/tp has "Device fw_path: tp/21684/FW_NF_ILI7807S_BOE.bin"
adb -s "$S" shell su <<EOF
set -e
rm -rf $TMP; mkdir -p $TMP/touch $TMP/connsys
for f in $(echo $CONNSYS); do cp /vendor/firmware/\$f $TMP/connsys/; done
cp /odm/firmware/\$(sed -n 's/.*fw_path:[[:space:]]*//p' /proc/devinfo/tp) $TMP/touch/
chmod 644 $TMP/*/*
EOF
mkdir -p "$OUT/fw-touch" "$OUT/fw-connsys"
adb -s "$S" pull "$TMP/touch/." "$OUT/fw-touch/" >/dev/null
adb -s "$S" pull "$TMP/connsys/." "$OUT/fw-connsys/" >/dev/null
echo "rm -rf $TMP" | adb -s "$S" shell su
ls -l "$OUT/fw-touch" "$OUT/fw-connsys"
