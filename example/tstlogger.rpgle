**free
CTL-OPT BNDDIR('LOGGER');

/copy logger.h.rpgle

log('debug':'This log should not appear');

log('info':'This log should appear with CPF9897');

MONITOR;
  log('fatal':'This log should appear with CPF9898');
ON-ERROR;
ENDMON;

RETURN;
