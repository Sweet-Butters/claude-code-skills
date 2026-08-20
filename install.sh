#!/usr/bin/env bash
# 연세 프리미엄 인강 - Claude Code 스킬 설치 (macOS · Linux)
set -e
dst="$HOME/.claude/skills"
mkdir -p "$dst"
src="$(cd "$(dirname "$0")" && pwd)/skills"
for d in "$src"/*/; do
  cp -R "$d" "$dst/"
  echo "  설치됨  $(basename "$d")"
done
echo
echo "설치 위치 : $dst"
echo "Claude Code 를 새로 켜고 / 를 눌러 보세요."
