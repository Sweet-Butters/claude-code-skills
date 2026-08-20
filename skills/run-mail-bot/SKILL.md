---
name: run-mail-bot
description: Gmail→Telegram 알림봇을 내 컴퓨터에서 점검하고 실행한다. 봇이 안 돌거나 알림이 안 올 때, 키를 새로 넣었을 때도 이 스킬을 쓴다.
---

3강에서 clone한 알림봇 저장소를 **비개발자 대신 끝까지 돌려 주는** 스킬이다.
`수집(Gmail) → 분류(Gemini) → 알림(Telegram)` 세 단계로 도는 프로그램이다.

아래를 순서대로 확인한다. **실패한 단계에서 멈추고**, 무엇이 왜 안 됐는지 한국어 한두 문장으로 설명한 뒤
다음에 무엇을 하면 되는지 알려 준다. 오류 메시지를 그대로 던지지 않는다.

## 0. 먼저 저장소를 읽는다

파일 이름을 **추측하지 말고** 실제로 확인한다.

```
ls
```

`README.md`가 있으면 읽는다. 원본 저장소 기준으로는 이렇게 생겼다 — 다르면 **실물을 따른다.**

| 파일 | 하는 일 |
|---|---|
| `main.py` | 수집 → 분류 → 알림 전체 흐름 |
| `auth_gmail.py` | Gmail 인증 (`gmail.readonly` 하나만 요청) |
| `classify.py` | Gemini로 4종 분류 |
| `send_telegram.py` | 텔레그램 발송 |
| `.env.example` | 채워야 할 키 3개의 틀 |
| `*.txt` · `quota.json` | 봇이 스스로 갱신하는 상태 파일 — 손대지 않는다 |

## 1. 안전 점검 — 이걸 제일 먼저 한다

`.gitignore`에 `.env`가 들어 있는지 확인한다.

```
git status --short
```

`.env`가 커밋 대상으로 보이면 **즉시 멈추고** 사용자에게 알린다.
`.gitignore`에 `.env`를 추가한 뒤에만 다음으로 넘어간다.
이미 GitHub에 올라간 적이 있다면 **키를 폐기하고 재발급해야 한다**고 분명히 말한다.

## 2. 가상환경과 패키지

```
python -m venv .venv
```

활성화 명령은 OS에 맞게 안내하고 **사용자가 직접 실행**하게 한다.
Windows `.venv\Scripts\activate` · macOS·Linux `source .venv/bin/activate`

```
python -m pip install -r requirements.txt
```

## 3. 키가 다 들어왔는지 확인

`.env`가 없으면 `.env.example`을 복사해서 만든다.
**값은 절대 지어내지 않는다.** 비어 있는 항목이 있으면 어디서 발급받는지 알려 준다.

| 키 | 발급처 |
|---|---|
| `GEMINI_API_KEY` | Google AI Studio |
| `TELEGRAM_TOKEN` | 텔레그램 @BotFather |
| `TELEGRAM_CHAT_ID` | 봇에게 말을 건 뒤 확인 |
| `credentials.json` | Google Cloud Console (OAuth 클라이언트, 데스크톱 앱) |

값이 채워졌는지만 확인하고 **값 자체는 화면에 출력하지 않는다.**

## 4. Gmail 인증 (처음 한 번만)

인증 토큰 파일이 이미 있으면 이 단계는 건너뛴다.

```
python auth_gmail.py
```

브라우저가 열리면 계정을 고르고 승인하라고 안내한다.
**"이 앱은 Google에서 확인하지 않았습니다"** 화면이 나오면
`고급` → `(앱 이름)(안전하지 않음)으로 이동`을 눌러야 한다고 미리 알려 준다.
여기서 막히는 사람이 가장 많으므로, 화면이 어떻게 생겼는지 말로 설명해 준다.

## 5. 실행

```
python main.py
```

## 6. 결과 확인

- 콘솔에 몇 통을 읽고 몇 통을 분류했는지 요약해 준다
- **첫 실행은 기준점만 잡고 끝날 수 있다.** 알림이 안 와도 정상이라고 알려 준다
- 두 번째 실행부터 새 메일이 있으면 텔레그램으로 온다

## 자주 막히는 곳

| 증상 | 원인과 조치 |
|---|---|
| `FileNotFoundError: 'credentials.json'` | **가장 흔하다.** Google Cloud에서 받은 OAuth 파일을<br>저장소 폴더에 `credentials.json` 이름으로 두지 않았다.<br>`main.py`는 이 확인을 먼저 하지 않고 바로 인증으로 들어가므로<br>파이썬 트레이스백이 그대로 뜬다 — 놀라지 말라고 미리 말해 준다 |
| `ModuleNotFoundError` | 가상환경이 활성화되지 않았다. 2단계를 다시 |
| `403` / `insufficient scope` | Gmail API 권한 범위가 모자라다. 토큰 파일을 지우고 4단계 재실행 |
| 텔레그램에 아무것도 안 옴 | chat id가 틀렸거나, 봇에게 먼저 말을 건 적이 없다 |
| `quota` / `429` | Gemini 무료 한도. 잠시 뒤 다시 실행 |
| 한글이 깨짐 | 터미널 인코딩 문제. 결과 파일로 확인하게 안내 |

문제를 고친 뒤에는 **반드시 5단계를 다시 실행해서** 되는 것까지 확인하고 끝낸다.


---

> **검증 기록 (2026-08-20)** — 빈 폴더에 clone해서 여기까지 직접 실행해 확인했습니다.
>
> | 단계 | 결과 |
> |---|---|
> | 0. 진입점 파일 | `main.py` · `auth_gmail.py` · `requirements.txt` · `.env.example` 모두 존재 |
> | 1. 안전 점검 | `.gitignore`에 `.env` · `credentials.json` · `token.json` 이미 차단됨 |
> | 2. 패키지 설치 | `pip install -r requirements.txt` 후 4개 모듈 임포트 성공 |
> | 3. `.env` 항목 | `TELEGRAM_TOKEN` · `TELEGRAM_CHAT_ID` · `GEMINI_API_KEY` 세 개 |
> | 4. 키 없이 실행 | `FileNotFoundError: 'credentials.json'` — 위 표에 반영 |
>
> 5단계 이후(실제 인증·발송)는 계정이 필요해 미검증입니다.
