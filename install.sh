#!/usr/bin/env bash
# 연세 프리미엄 인강 - Claude Code 스킬 설치 (macOS · Linux)
set -e
dst="$HOME/.claude/skills"
mkdir -p "$dst"
src="$(cd "$(dirname "$0")" && pwd)/skills"
stamp="$(date +%Y%m%d-%H%M%S)"

for d in "$src"/*/; do
  name="$(basename "$d")"
  if [ -e "$dst/$name" ]; then
    mv "$dst/$name" "$dst/$name.backup-$stamp"
    echo "  기존 것 백업  $name  ->  $name.backup-$stamp"
  fi
  cp -R "$d" "$dst/"
  echo "  설치됨        $name"
done
echo
echo "설치 위치 : $dst"
echo "Claude Code 를 새로 켜면 목록에 잡힙니다."
