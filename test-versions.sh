#!/bin/bash

VERSIONS="24.11 24.12 24.13 25"

run_test() {
  local flags="$1"

  echo "Without --watch:"
  for v in $VERSIONS; do
    mise exec node@$v -- node $flags test.js
  done

  echo ""
  echo "With --watch:"
  for v in $VERSIONS; do
    mise exec node@$v -- node --watch $flags test.js &
    sleep 0.5
    kill $! 2>/dev/null
    wait $! 2>/dev/null
  done
}

echo "=== Test 1: --env-file + --env-file-if-exists (BUG) ==="
run_test "--env-file=.env --env-file-if-exists=.env.local"

echo ""
echo "=== Test 2: --env-file + --env-file (works correctly) ==="
run_test "--env-file=.env --env-file=.env.local"

echo ""
echo "=== Test 3: --env-file-if-exists + --env-file-if-exists (works correctly) ==="
run_test "--env-file-if-exists=.env --env-file-if-exists=.env.local"
