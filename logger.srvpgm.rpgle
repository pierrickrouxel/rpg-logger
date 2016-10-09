**free
CTL-OPT NOMAIN;

DCL-PR getInternalLogLevel CHAR(10) END-PR;

DCL-PROC getInternalLogLevel;
  DCL-PI *N CHAR(10) END-PI;
  DCL-DS system SDS;
    programName CHAR(10);
  END-DS;

  DCL-PR getEnv POINTER EXTPROC('getenv');
    variable POINTER VALUE OPTION(*STRING);
  END-PR;

  DCL-S variable CHAR(25);
  DCL-S logLevel CHAR(10);

  // Find program log level
  variable = 'RPG_LOG_LEVEL_' + programName;
  logLevel = %STR(getEnv(%ADDR(variable)):%SIZE(logLevel));

  IF logLevel <> *BLANK;
    RETURN logLevel;
  END-IF;

  // Find global log level
  variable = 'RPG_LOG_LEVEL';
  logLevelLength = %SIZE(logLevel);
  logLevel = %STR(getEnv(%ADDR(variable)):%SIZE(logLevel));

  IF logLevel <> *BLANK;
    RETURN logLevel;
  END-IF;

  RETURN 'info';
END-PROC;

// Translate log level into number
// 1 = debug
// 2 = info
// 3 = warn
// 4 = error
// 5 = fatal
DCL-PR numberizeLevel INT(5);
  logLevel CHAR(10);
END-PR;

DCL-PROC numberizeLevel;
  DCL-PI *N INT(5);
    logLevel CHAR(5);
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

DCL-DS errorCode;
  bytesProvided INT(10) INZ(%SIZE(errorCode));
  bytesAvailable INT(10);
  exceptionId CHAR(7);
END-DS;

DCL-PR sendProgramMessage EXTPGM('QMHSNDPM');
  messageId CHAR(7) CONST;
  messageFile CHAR(20) CONST;
  messageData POINTER CONST;
  messageDataLength INT(10) CONST;
  messageType CHAR(10) CONST;
  callStackEntry POINTER CONST;
  callStackCounter INT(10) CONST;
  messageKey CHAR(4);
  errorCode LIKEDS(errorCode);
END-PR;

DCL-PROC log EXPORT;
  DCL-PI *N;
    logLevel CHAR(10);
    message POINTER;
    messageLength UNS(10);
  END-PI;

  DCL-S numericLogLevel INT(5);
  DCL-S internalNumericLogLevel INT(5);

  numericLogLevel = numberizeLevel(logLevel);
  internalNumericLogLevel = numberizeLevel(getInternalLogLevel());

  // Do nothing if log is lower than log level
  IF numericLogLevel < internalNumericLogLevel;
    RETURN;
  ENDIF;

  // Error and higher og should quit program
  IF numericLogLevel > 3
    sendProgramMessage('CPF9898':
                       'QCPFMSG   QSYS':
                       message:messageLength:
                       '*ESCAPE':'*':2:'':
                       errorCode);
  ELSE;
    sendProgramMessage('CPF9798':
                       'QCPFMSG   QSYS':
                       message:messageLength:
                       '*INFO':'*':2:'':
                       errorCode);
  ENDIF;

  RETURN;
END-PROC;
