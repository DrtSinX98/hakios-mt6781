# hakios-mt6781

HakiOS for the **realme 8i (spaced)**: MediaTek Helio G96 (**MT6781**), GPU **Mali-G57 MC2**, UFS.
Started from [hakios-mt6768](https://github.com/oosexgang/hakios-mt6768) (Infinix Hot 20); its history is kept.

**State: nothing works yet.** `mtkloader/`, `kernel/`, `tools/` and `docs/` are still the Hot 20's,
unchanged; they are the starting point, not this phone's code.

## What differs from the Hot 20

| | Hot 20 (MT6768) | realme 8i (MT6781) |
| --- | --- | --- |
| boot | `boot_a`, A/B | single `boot`, header v2, `Image.gz` + DTB |
| storage | eMMC, MSDC0 | UFS, `ufshci@11270000` |
| display | 720x1640 | 1080x2412, ILI7807S / NT36672C, video mode |
| touch | TD4160, SPI2 | ILI7807S (Oplus "noflash"), SPI4 |
| GPU | Mali-G52 (Bifrost) | Mali-G57 MC2 (Valhall), mfgcfg at 0x13fbf000 |
| CPU | 6x A55 + 2x A75 | 6x A55 (0-5) + 2x A76 (6-7; the DT says A75) |
| keypad, PMIC | 0x10010000, MT6358 | same |

Sources for the table: realme-mt6781-dev's `android_device_realme_spaced` and `android_kernel_realme_mt6781` (read, not copied).

## Building

Common tree `hakios-xnu-kernel`, branch `mt6781`, with this repository at `devices/spaced`:

```sh
make spaced_defconfig && make kernel
```

## Licenses

`kernel/` is APSL 2.0 (`LICENSE.APSL`), everything else MIT (`LICENSE`). See `NOTICE` and `LEGAL.md`.
