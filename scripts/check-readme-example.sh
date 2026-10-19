#!/usr/bin/env bash
# The TypeScript example in README.md must type-check against the published
# package. Extracts the README's ```ts block and runs `tsc --noEmit` (strict)
# over it in a throwaway project with @computesphere/api-client installed.
# PACKAGE_VERSION picks the version (default: latest).
# Run from the repository root: scripts/check-readme-example.sh
set -euo pipefail

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

blocks=$(grep -c '^```ts$' README.md || true)
if [ "$blocks" -ne 1 ]; then
  echo "README.md: expected one ts block, found $blocks" >&2
  exit 1
fi
awk '/^```ts$/{f=1;next} /^```$/{f=0} f' README.md > "$work/main.ts"

cd "$work"
cat > package.json <<'JSON'
{ "name": "readme-example", "private": true, "type": "module" }
JSON
cat > tsconfig.json <<'JSON'
{
  "compilerOptions": {
    "target": "es2022",
    "module": "esnext",
    "moduleResolution": "bundler",
    "strict": true,
    "noEmit": true,
    "types": ["node"]
  },
  "include": ["main.ts"]
}
JSON
npm install --silent --no-audit --no-fund "@computesphere/api-client@${PACKAGE_VERSION:-latest}" typescript @types/node
npx --no-install tsc -p .
echo "README.md ts example type-checks against @computesphere/api-client@$(node -p "require('./node_modules/@computesphere/api-client/package.json').version")"
