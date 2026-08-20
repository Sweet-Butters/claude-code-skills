---
name: deploy-mail-bot
description: 로컬에서 돌아가는 알림봇을 GitHub에 올리고 GitHub Actions로 24시간 자동 실행되게 만든다. 배포가 실패하거나 Actions가 빨간불일 때도 이 스킬을 쓴다.
---

내 컴퓨터에서 이미 돌아가는 봇을 **꺼져 있어도 도는 상태**로 만드는 스킬이다.
사용자는 비개발자다. 각 단계에서 **지금 무엇을 왜 하는지** 한 줄로 먼저 말하고 진행한다.

## 0. 전제 확인

로컬 실행이 성공한 적이 있어야 한다. 확인이 안 되면 먼저 `run-mail-bot` 스킬로 돌려 보게 한다.
**로컬에서 안 되는 것은 GitHub에서도 안 된다.**

## 1. 올리면 안 되는 것부터 막는다

```
git status --short
```

`.env`, `token.json`, `credentials.json`이 목록에 보이면 **여기서 멈춘다.**
원본 저장소의 `.gitignore`에는 이 셋이 이미 들어 있으므로, 보인다면 `.gitignore`가
지워졌거나 이미 추적되고 있다는 뜻이다. `.gitignore`를 고치고 다시 확인한 뒤에만 다음으로 간다.

이미 올라간 적이 있다면 커밋 기록에 남아 있으므로 **키를 폐기하고 재발급**해야 한다고 말한다.
이건 강의에서 가장 중요한 안전 수칙이다. 절대 그냥 넘어가지 않는다.

## 2. 내 저장소에 올리기

원격 저장소가 없으면 GitHub 웹에서 **New repository**로 만들게 안내한다.
처음에는 **Private**을 권한다.

```
git add .
git commit -m "알림봇 첫 커밋"
git push -u origin main
```

푸시가 거부되면 원인을 확인해서 알려 준다 (기본 브랜치 이름, 원격 주소, 인증 등).

## 3. Secrets 등록 — 웹 화면에서

로컬의 값을 GitHub이 대신 들고 있게 하는 단계다. **값은 절대 출력하지 않는다.**
`.github/workflows/check-mail.yml`을 읽어 **실제로 쓰이는 secret 이름을 뽑아** 목록으로 보여 주고,
사용자가 웹에서 직접 넣도록 안내한다. 이 저장소 기준으로는 다섯 개다.

| 이름 | 값 |
|---|---|
| `TELEGRAM_TOKEN` | `.env`의 같은 항목 |
| `TELEGRAM_CHAT_ID` | `.env`의 같은 항목 |
| `GEMINI_API_KEY` | `.env`의 같은 항목 |
| `GOOGLE_CREDENTIALS_JSON` | `credentials.json` **파일 내용 전체** |
| `GOOGLE_TOKEN_JSON` | `token.json` **파일 내용 전체** |

1. 저장소 → **Settings**
2. **Secrets and variables → Actions**
3. **New repository secret**
4. 이름과 값을 넣고 **Add secret**
5. 목록만큼 반복

Gmail 인증 파일처럼 파일 내용이 통째로 들어가는 항목은 **파일 전체를 붙여넣는다**고 알려 준다.

## 4. 워크플로 읽기

**이 저장소에는 `.github/workflows/check-mail.yml`이 이미 들어 있다. 새로 만들지 않는다.**
대신 **사용자가 스스로 읽을 수 있게** 다섯 가지를 짚어 준다.

| 부분 | 뜻 |
|---|---|
| `on: schedule: cron: '*/10 * * * *'` | 10분마다 자동 실행 |
| `on: workflow_dispatch` | Actions 탭의 수동 실행 버튼 |
| `permissions: contents: write` | 상태 파일 변경분을 커밋하기 위한 권한 |
| `env: ... ${{ secrets.XXX }}` | 키를 Secrets에서 읽어 온다 — 파일에 값이 없다 |
| `Commit state if changed` | `last_seen_id.txt` 등이 바뀌면 자동 커밋 |

없거나 지워졌을 때만 새로 만든다. 그 경우에도 위 다섯 가지를 그대로 갖추게 한다.

## 5. 돌아가는지 확인

저장소의 **Actions** 탭을 열게 한다.
수동 실행 버튼(`Run workflow`)으로 **지금 한 번** 돌려 보게 한다.

- 초록불 → 성공. 텔레그램에 알림이 오는지 확인
- 빨간불 → 실패한 단계의 로그를 열어서 **그 부분만** 읽고 원인을 짚어 준다

## 6. 실패했을 때

가장 흔한 원인부터 확인한다.

| 증상 | 원인 |
|---|---|
| `RefreshError: invalid_client` | **`GOOGLE_CREDENTIALS_JSON` 또는 `GOOGLE_TOKEN_JSON` 이 잘못됐다.**<br>파일 내용을 통째로가 아니라 일부만 붙여넣었거나, 다른 프로젝트 키다.<br>로컬에서 `auth_gmail.py` 를 다시 돌려 새 `token.json` 을 만들고 다시 등록 |
| `KeyError` / 빈 값 | Secrets 이름이 코드와 다르다. 철자를 대조 |
| `ModuleNotFoundError` | `requirements.txt` 설치 단계가 빠졌다 |
| 인증 실패 | Gmail 토큰이 Secrets에 안 들어갔거나 만료 |
| 커밋 단계 실패 | 워크플로에 쓰기 권한(`permissions: contents: write`)이 없다 |
| 계속 같은 메일 알림 | `last_seen_id.txt` 커밋이 안 되고 있다. 위 항목 확인 |

고친 뒤 push하면 **그 순간부터 새 설정이 적용된다.** 다시 수동 실행해서 초록불을 확인하고 끝낸다.

## 7. 마무리

- 무료 한도 안에서 돈다는 것을 확인시켜 준다 (Actions 월 무료 분, Gemini 무료 등급)
- 저장소를 공개할지 물어본다. 공개하면 **Secrets는 공개되지 않지만** 코드는 공개된다는 점을 알려 준다
- `README.md`가 없으면, 처음 보는 사람이 따라 할 수 있는 수준으로 써 준다


---

> **검증 기록 (2026-08-20)** — 저장소를 빈 폴더에 clone 하고, GitHub Actions 가 하는 일을
> 로컬에서 그대로 재현해 확인했습니다.
>
> | 확인한 것 | 결과 |
> |---|---|
> | 워크플로 구조 | `schedule`(*/10) · `workflow_dispatch` · `permissions: contents: write` · `concurrency` · `timeout-minutes` 모두 존재 |
> | Secrets 5개 | 워크플로가 요구하는 이름과 **코드가 읽는 환경변수가 완전히 일치** (누락 0) |
> | 파일 복원 | `GOOGLE_CREDENTIALS_JSON`·`GOOGLE_TOKEN_JSON` → `credentials.json`·`token.json`,<br>`auth_gmail.py` 가 여는 경로와 **일치** |
> | 상태 파일 커밋 | 목록의 7개 파일이 저장소에 **모두 존재** |
> | 실제 실행 | 더미 자격증명으로 재현 → Google OAuth 서버까지 도달해 `invalid_client` 반환.<br>즉 **복원·전달·진입 경로가 전부 정상** |
>
> 실제 계정으로 Actions 를 돌려 초록불을 보는 것만 남았습니다.
