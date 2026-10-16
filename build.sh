#!/usr/bin/env bash
# 极客时间：左耳听风 静态站构建：克隆上游 → mdbook build → site/
set -euo pipefail

VERSION="${LAZYCAT_VERSION:-${VERSION:-}}"
echo "==> building some-haoel-talks version: ${VERSION:-<default branch>}"

rm -rf .upstream book site
if [ -n "$VERSION" ]; then
  if ! git clone --depth 1 --branch "$VERSION" https://github.com/read-x/some-haoel-talks.git .upstream 2>/dev/null; then
    echo "==> tag $VERSION not found, falling back to default branch"
    git clone --depth 1 https://github.com/read-x/some-haoel-talks.git .upstream
  fi
else
  git clone --depth 1 https://github.com/read-x/some-haoel-talks.git .upstream
fi

MDBOOK_VERSION="0.4.44"
if ! command -v mdbook >/dev/null 2>&1; then
  curl -fsSL "https://github.com/rust-lang/mdbook/releases/download/v${MDBOOK_VERSION}/mdbook-v${MDBOOK_VERSION}-x86_64-unknown-linux-gnu.tar.gz" \
    | tar -xz -C /tmp
  export PATH="/tmp:$PATH"
fi
mdbook --version

cd .upstream
mdbook build
cd ..
cp -r .upstream/book site
echo "==> site built: $(du -sh site | cut -f1)"
