**free
CTL-OPT NOMAIN;

DCL-DS system PSDS;
  programName CHAR(10);
END-DS;

// Get configured log level
DCL-PR getInternalLogLevel CHAR(10) END-PR;

// Translate log level into number
// 1 = debug
// 2 = info
// 3 = warn
// 4 = error
// 5 = fatal
DCL-PR numberizeLevel INT(5);
  logLevel CHAR(10) CONST;
END-PR;

DCL-DS errorCode;
  bytesProvided INT(10) INZ(%SIZE(errorCode));
  bytesAvailable INT(10);
  exceptionId CHAR(7);
END-DS;

DCL-PR sendProgramMessage EXTPGM('QMHSNDPM');
  messageId CHAR(7) CONST;
  messageFile CHAR(20) CONST;
  messageData CHAR(32767) CONST;
  messageDataLength INT(10) CONST;
  messageType CHAR(10) CONST;
  callStackEntry CHAR(10) CONST;
  callStackCounter INT(10) CONST;
  messageKey CHAR(4);
  errorCode LIKEDS(errorCode);
END-PR;

DCL-PROC numberizeLevel;
  DCL-PI *N INT(5);
    logLevel CHAR(10) CONST;
  END-PI;

  SELECT;
  WHEN logLevel = 'info';
    RETURN 2;
  WHEN logLevel = 'warn';
    RETURN 3;
  WHEN logLevel = 'error';
    RETURN 4;
  WHEN logLevel = 'fatal';
    RETURN 5;
  OTHER;
    RETURN 1;
  ENDSL;
END-PROC;

DCL-PROC getInternalLogLevel;
  DCL-PI *N CHAR(10) END-PI;

  DCL-PR getEnv POINTER EXTPROC('getenv');
    variable POINTER VALUE OPTIONS(*STRING);
  END-PR;

  DCL-S variable CHAR(25);
  DCL-S logLevel POINTER;

  // Find program log level
  variable = 'RPG_LOG_LEVEL_' + programName;
  
  logLevel = getEnv(%TRIM(variable));
  IF logLevel <> *NULL;
    RETURN %STR(logLevel:%SIZE(logLevel));
  ENDIF;

  // Find global log level
  variable = 'RPG_LOG_LEVEL';
  logLevel = getEnv(%TRIM(variable));
  IF logLevel <> *NULL;
    RETURN %STR(logLevel:%SIZE(logLevel));
  ENDIF;

  RETURN 'info';
END-PROC;

DCL-PROC log EXPORT;
  DCL-PI *N;
    logLevel CHAR(10);
    message CHAR(32767);
  END-PI;

  DCL-S messageKey CHAR(4);
  DCL-S numericLogLevel INT(5);
  DCL-S internalNumericLogLevel INT(5);

  numericLogLevel = numberizeLevel(logLevel);
  internalNumericLogLevel = numberizeLevel(getInternalLogLevel());

  // Do nothing if log is lower than log level
  IF numericLogLevel < internalNumericLogLevel;
    RETURN;
  ENDIF;

  // Error and higher og should quit program
  IF numericLogLevel > 4;
    sendProgramMessage('CPF9898':
                       'QCPFMSG   QSYS':
                       message:%LEN(%TRIMR(message)):
                       '*ESCAPE':'*PGMBDY':1:messageKey:
                       errorCode);
  ELSE;
    sendProgramMessage('CPF9897':
                       'QCPFMSG   QSYS':
                       message:%LEN(%TRIMR(message)):
                       '*INFO':'*PGMBDY':1:messageKey:
                       errorCode);
  ENDIF;

  RETURN;
END-PROC;
