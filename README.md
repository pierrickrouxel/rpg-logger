# rpg-logger

# Log level

You can set log level defining an environment variable (`WRKENVVAR`) `RPG_LOG_LEVEL` with this values :

* **debug** for development CPF9897
* **info** (default) general informations CPF9897
* **warn** warning message CPF9897
* **error** error message CPF9898
* **fatal** fatal error message CPF9898

CPF9898 will exit program.

The environment variable can be define just for a job or for all system.

You can also define `RPG_LOG_LEVEL_[PROGRAM_NAME]` to set log level just for a program.
