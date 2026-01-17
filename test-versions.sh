#!/bin/bash
echo "Without --watch:"
for v in 24.11 24.12 24.13 25; do
  mise exec node@$v -- node --env-file=.env --env-file-if-exists=.env.local test.js
done

echo ""
echo "With --watch:"
for v in 24.11 24.12 24.13 25; do
  mise exec node@$v -- node --watch --env-file=.env --env-file-if-exists=.env.local test.js &
  sleep 0.5
  kill $! 2>/dev/null
  wait $! 2>/dev/null
done
