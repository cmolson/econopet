// SPDX-License-Identifier: CC0-1.0
// https://github.com/dlehenbauer/econopet

#include "pch.h"
#include "version.h"

// Bootloader compares this against firmware.uf2 on the SD card.
bi_decl(bi_program_version_string(FW_VERSION_STRING "-" FW_GIT_HASH "-" FW_BUILD_ID));
