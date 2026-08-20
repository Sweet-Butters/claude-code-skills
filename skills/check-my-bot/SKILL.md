---
name: check-my-bot
description: 알림봇 폴더가 지금 돌 준비가 됐는지 점검한다. 3강에서 매번 손으로 확인하던 것을 한 번에 한다. 오랜만에 폴더를 열었을 때, 뭔가 안 될 때 쓴다.
---

3강에서 봇을 돌릴 때마다 반복했던 확인을 대신 해 주는 스킬이다.
**고치지 말고 상태만 알려 준다.** 고치는 건 사용자가 결정한다.

아래를 순서대로 확인하고, 마지막에 **표 하나로 요약**한다.

## 1. 여기가 봇 폴더가 맞나

```
ls
```

`main.py` · `auth_gmail.py` · `requirements.txt`가 보이면 맞다.
없으면 "여기는 봇 폴더가 아닙니다"라고 말하고 끝낸다.

## 2. 가상환경

`.venv` 폴더가 있는지 확인한다. 없으면 만들어야 한다고 알려 준다.

## 3. 패키지

```
python -c "import googleapiclient, google.genai, dotenv, requests; print('ok')"
```

`ok`가 나오면 통과. 아니면 `pip install -r requirements.txt`가 필요하다.

## 4. 키 3개

`.env`에 아래 세 줄이 **비어 있지 않은지**만 확인한다. **값은 절대 출력하지 않는다.**

```
TELEGRAM_TOKEN=
TELEGRAM_CHAT_ID=
GEMINI_API_KEY=
```

## 5. Gmail 인증

`credentials.json`과 `token.json`이 있는지 본다.
`token.json`이 없으면 `python auth_gmail.py`를 한 번 돌려야 한다.

## 6. 안전

```
git status --short
```

`.env` · `credentials.json` · `token.json`이 목록에 보이면 **빨간 경고**로 알린다.
`.gitignore`에 이미 들어 있으면 안 보이는 게 정상이다.

## 마지막 : 요약표

| 항목 | 상태 |
|---|---|
| 봇 폴더 | O / X |
| 가상환경 | O / X |
| 패키지 | O / X |
| 키 3개 | O / X |
| Gmail 인증 | O / X |
| 키 유출 위험 | 없음 / **있음** |

X가 하나라도 있으면 **무엇을 하면 되는지 한 줄로** 알려 주고 끝낸다.
