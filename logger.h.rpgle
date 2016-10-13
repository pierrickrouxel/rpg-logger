**free
//*
// Put a message in the job log.
// @method log
// @param level The level of message (debug|info|warn|error|fatal)
// @param message The message to log
//
// ```rpg
// log('info', 'This is an info message');
// ```
DCL-PR log;
  level CHAR(10) CONST;
  message CHAR(32767) CONST;
END-PR;
