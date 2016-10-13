#!/bin/sh

library="*CURLIB"

system_with_exit() {
  system "$1"
  if [ $? -gt 0 ]; then
    exit $?
  fi
}

# Library
system "CRTSRCPF FILE(*CURLIB/QSRVSRC)"
system "ADDPFM FILE(*CURLIB/QSRVSRC) MBR(LOGGER) SRCTYPE(BND)"
cat logger.bnd | Rfile -wQ "QSRVSRC(LOGGER)"
system_with_exit "CRTRPGMOD MODULE(*CURLIB/LOGGER) SRCSTMF('logger.module.rpgle') DBGVIEW(*SOURCE)"
system_with_exit "CRTSRVPGM SRVPGM(*CURLIB/LOGGER) MODULE(*CURLIB/LOGGER) SRCFILE(*CURLIB/QSRVSRC) TGTRLS(*CURRENT)"

system "DLTBNDDIR BNDDIR(*CURLIB/LOGGER)"
system_with_exit "CRTBNDDIR BNDDIR(*CURLIB/LOGGER)"
system_with_exit "ADDBNDDIRE BNDDIR(*CURLIB/LOGGER) OBJ((LOGGER *SRVPGM))"

# Test
system_with_exit "CRTBNDRPG PGM(*CURLIB/TSTLOGGER) SRCSTMF('example/tstlogger.rpgle') TGTRLS(*CURRENT) DBGVIEW(*SOURCE)"

echo "LOGGER is built with success"
