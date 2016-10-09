**free
/copy logger.h.rpgle

DCL-S message CHAR(100);

message = 'This log should not appear';
log('debug':message:%LEN(%TRIM(message)));

message = 'This log should appear with CPF9897';
log('info':message:%LEN(%TRIM(message)));

message = 'This log should appear with CPF9898';

RETURN;
