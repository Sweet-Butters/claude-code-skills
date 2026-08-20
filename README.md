# 연세 프리미엄 인강 — 클로드 코드 실전용 Skills

「바이브코딩의 한계를 부수자 — 클로드 코드 실전용 Skills」 강의에서 쓰는 **Claude Code 스킬 모음**입니다.
전부 한국어로 되어 있고, **비개발자가 쓰는 것을 전제**로 만들었습니다.

## Skill이 뭔가요

**폴더 하나 + `SKILL.md` 한 장**이 전부입니다.

```
skills/
└─ run-mail-bot/
   └─ SKILL.md
```

`SKILL.md`는 위에 설정 세 줄, 아래에 시킬 일을 한국어로 적습니다.

```markdown
---
name: run-mail-bot
description: 알림봇을 점검하고 실행한다. 봇이 안 돌 때도 쓴다.
---

여기부터는 시킬 일을 순서대로 적으면 됩니다.
```

`description`이 가장 중요합니다. Claude는 **이 한 줄을 보고 언제 이 스킬을 꺼낼지** 판단합니다.
"무엇을 하는지"뿐 아니라 **"언제 쓰는지"**까지 적어야 제때 꺼내 씁니다.

> **강의를 그대로 따라가실 거면 이 저장소가 아니라
> [yonsei-claude-code](https://github.com/Sweet-Butters/yonsei-claude-code) 를 받으세요.**
> 발표자료와 스킬이 함께 들어 있어 `git clone` 후 `/run-course` 한 줄이면 됩니다.
> 이 저장소는 **다른 프로젝트에서도 스킬을 쓰고 싶을 때** 설치용입니다.

## 설치

### Windows (PowerShell)

```powershell
git clone https://github.com/Sweet-Butters/claude-code-skills.git
cd claude-code-skills
./install.ps1
```

### macOS · Linux

```bash
git clone https://github.com/Sweet-Butters/claude-code-skills.git
cd claude-code-skills
bash install.sh
```

설치 후 **Claude Code를 새로 켜면** 스킬 목록에 잡힙니다.
Claude가 `description`을 보고 알아서 꺼내 쓰고, `/` 를 눌러 직접 부를 수도 있습니다.

> 같은 이름의 스킬이 이미 있으면 `이름.backup-날짜` 로 옮겨 두고 설치합니다. 덮어쓰지 않습니다.

### 손으로 하려면

`skills/` 안의 폴더를 통째로 아래 둘 중 한 곳에 복사하면 됩니다.

| 위치 | 범위 |
|---|---|
| `~/.claude/skills/<이름>/SKILL.md` | 내 컴퓨터의 모든 프로젝트에서 |
| `<프로젝트>/.claude/skills/<이름>/SKILL.md` | 그 프로젝트에서만 |

## 들어 있는 스킬

| 스킬 | 언제 쓰나 | 차시 |
|---|---|---|
| [**`run-course`**](skills/run-course/SKILL.md) | **강의 전체를 처음부터 재현** — 대부분 이것만 쓰면 됩니다 | 전체 |
| [`check-my-bot`](skills/check-my-bot/SKILL.md) | 알림봇 폴더가 지금 돌 준비가 됐는지 점검 | 4강 |
| [`run-crawler`](skills/run-crawler/SKILL.md) | 크롤러를 점검하고 실행해 CSV로 저장 | 4강 |
| [`run-mail-bot`](skills/run-mail-bot/SKILL.md) | 알림봇을 내 컴퓨터에서 점검하고 실행 | 4강 |
| [`deploy-mail-bot`](skills/deploy-mail-bot/SKILL.md) | 봇을 GitHub Actions로 24시간 돌리기 | 5강 |

`run-mail-bot` · `deploy-mail-bot`은 [Sweet-Butters/mail-notifier](https://github.com/Sweet-Butters/mail-notifier)를 대상으로 합니다.

## 직접 만들어 보기

Claude Code에게 시키는 것이 가장 빠릅니다.

```
지금 폴더를 읽고, 이 프로젝트를 처음 보는 사람이 한 번에 실행할 수 있는
skill을 .claude/skills/ 아래에 만들어줘. description에는 "언제 쓰는지"도 넣어줘.
```

만들어진 `SKILL.md`는 **반드시 열어서 읽고 확인**하세요. 스킬은 앞으로 계속 쓰이는 문서라
틀린 채로 두면 매번 같은 실수를 반복합니다.

### description, 이렇게 씁니다

| | 예시 |
|---|---|
| 나쁨 | `봇 관련 작업` — 언제 꺼낼지 알 수 없음 |
| 나쁨 | `main.py를 실행함` — 무슨 일이 벌어지는지 모름 |
| 좋음 | `알림봇을 점검하고 실행한다. 봇이 안 돌거나 알림이 안 올 때도 쓴다.` |

## 라이선스

MIT — 자유롭게 가져다 고쳐 쓰세요.
