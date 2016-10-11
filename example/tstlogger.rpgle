**free
CTL-OPT BNDDIR('LOGGER');

/copy logger.h.rpgle

DCL-S message CHAR(100);

message = 'This log should not appear';
log('debug':message);

message = 'This log should appear with CPF9897';
log('info':message);

MONITOR;
  message = 'This log should appear with CPF9898';
  log('fatal':message);
ENDMON;

RETURN;
