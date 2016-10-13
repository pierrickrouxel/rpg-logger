# rpg-logger

This project provides a simple tool to put message in job log from your RPG programs.

# Method

You can log a message with this syntax:

```
log('info', 'This is an info message');
```

## Log level

* **debug** for development CPF9897
* **info** general information CPF9897
* **warn** warning message CPF9897
* **error** error message CPF9897
* **fatal** fatal error message CPF9898

CPF9898 will exit program.

## Message

The message can not exceed 32767 characters.

# Configuration

By default the logger has the `info` level. All messages with level superior or equal to `info` will be logged.

You can change the log level defining an environment variable `RPG_LOG_LEVEL` (`WRKENVVAR`).
The environment variable can be set for the job or for the system.

You can also define `RPG_LOG_LEVEL_[PROGRAM_NAME]` to set log level for a program only.

# System requirements

* IBM i V7R1 TR11 or later.
