# Node.js --env-file override bug with --watch

When using `--watch`, subsequent env files do not override the prior ones as expected by the [docs](https://nodejs.org/en/learn/command-line/how-to-read-environment-variables-from-nodejs):

> Also, you can pass multiple `--env-file` arguments. Subsequent files override pre-existing variables defined in previous files.

**Regression introduced in Node.js 24.12.0**

## Reproduction

Uses [mise](https://mise.jdx.dev/) to change Node.js versions being tested.

```bash
./test-versions.sh
```

Slightly cleaned up output:
```
Without --watch:
v24.11.1 MY_VAR: from_dotenv_local
v24.12.0 MY_VAR: from_dotenv_local
v24.13.0 MY_VAR: from_dotenv_local
v25.3.0 MY_VAR: from_dotenv_local

With --watch:
v24.11.1 MY_VAR: from_dotenv_local
v24.12.0 MY_VAR: from_dotenv
v24.13.0 MY_VAR: from_dotenv
v25.3.0 MY_VAR: from_dotenv
```
