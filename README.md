# Node.js --env-file override bug with --watch
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Falialobidm%2Fnodejs-env-file-override-repro.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Falialobidm%2Fnodejs-env-file-override-repro?ref=badge_shield)


When using `--watch` and **mixing** `--env-file` with `--env-file-if-exists`, subsequent env files do not override the prior ones as expected by the [docs](https://nodejs.org/en/learn/command-line/how-to-read-environment-variables-from-nodejs):

> Also, you can pass multiple `--env-file` arguments. Subsequent files override pre-existing variables defined in previous files.

**Regression introduced in Node.js 24.12.0**

## Bug Details

The bug only occurs when:
1. Using `--watch` mode, AND
2. Mixing `--env-file` and `--env-file-if-exists` flags

Using only `--env-file` or only `--env-file-if-exists` works correctly.

| Flags used | Without `--watch` | With `--watch` |
|------------|-------------------|----------------|
| `--env-file` + `--env-file` | ✅ Works | ✅ Works |
| `--env-file-if-exists` + `--env-file-if-exists` | ✅ Works | ✅ Works |
| `--env-file` + `--env-file-if-exists` | ✅ Works | ❌ Broken (24.12+) |

## Reproduction

Uses [mise](https://mise.jdx.dev/) to change Node.js versions being tested.

```bash
./test-versions.sh
```

Slightly cleaned up output:
```
=== Test 1: --env-file + --env-file-if-exists ===
Without --watch:
v24.11.1 MY_VAR: from_dotenv_local
v24.12.0 MY_VAR: from_dotenv_local
v24.13.0 MY_VAR: from_dotenv_local
v25.3.0 MY_VAR: from_dotenv_local

With --watch:
v24.11.1 MY_VAR: from_dotenv_local
v24.12.0 MY_VAR: from_dotenv       <-- BUG: should be from_dotenv_local
v24.13.0 MY_VAR: from_dotenv       <-- BUG
v25.3.0 MY_VAR: from_dotenv        <-- BUG

=== Test 2: --env-file + --env-file (works correctly) ===
Without --watch:
v24.11.1 MY_VAR: from_dotenv_local
v24.12.0 MY_VAR: from_dotenv_local
v24.13.0 MY_VAR: from_dotenv_local
v25.3.0 MY_VAR: from_dotenv_local

With --watch:
v24.11.1 MY_VAR: from_dotenv_local
v24.12.0 MY_VAR: from_dotenv_local
v24.13.0 MY_VAR: from_dotenv_local
v25.3.0 MY_VAR: from_dotenv_local

=== Test 3: --env-file-if-exists + --env-file-if-exists (works correctly) ===
Without --watch:
v24.11.1 MY_VAR: from_dotenv_local
v24.12.0 MY_VAR: from_dotenv_local
v24.13.0 MY_VAR: from_dotenv_local
v25.3.0 MY_VAR: from_dotenv_local

With --watch:
v24.11.1 MY_VAR: from_dotenv_local
v24.12.0 MY_VAR: from_dotenv_local
v24.13.0 MY_VAR: from_dotenv_local
v25.3.0 MY_VAR: from_dotenv_local
```


## License
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Falialobidm%2Fnodejs-env-file-override-repro.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Falialobidm%2Fnodejs-env-file-override-repro?ref=badge_large)