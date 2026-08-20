---
name: run-crawler
description: 2강에서 만든 scrapling 크롤러를 점검하고 실행해 결과를 CSV로 저장한다. 크롤링이 안 되거나 결과가 비어 있을 때도 이 스킬을 쓴다.
---

2강 실습 크롤러를 **처음 해 보는 사람 대신** 끝까지 돌려 주는 스킬이다.
아래 순서대로 하나씩 확인하고, **실패한 단계에서 멈춰서** 무엇이 왜 안 됐는지 한국어로 설명한다.
사용자는 비개발자다. 오류 메시지를 그대로 붙여넣지 말고, 무슨 뜻인지 한 줄로 풀어서 말한다.

## 1. 지금 폴더 확인

`ls`로 현재 폴더를 본다. 크롤러 스크립트(`*.py`)가 없으면 만들 자리인지 사용자에게 먼저 묻는다.

## 2. 파이썬과 가상환경

```
python --version
```

`.venv` 폴더가 없으면 만든다.

```
python -m venv .venv
```

활성화는 사용자의 OS에 맞춰 안내한다 — Windows는 `.venv\Scripts\activate`, macOS·Linux는 `source .venv/bin/activate`.
**활성화는 사용자가 직접 하도록 안내하고**, 이후 명령은 `.venv`의 파이썬을 직접 지정해 실행한다.

## 3. scrapling 설치 확인

```
<PY> -c "import scrapling; print(scrapling.__version__)"
```

실패하면 설치한다.

```
<PY> -m pip install "scrapling[fetchers]"
```

`[fetchers]` 없이 설치하면 `Fetcher`를 불러올 때 `No module named 'curl_cffi'`가 난다.
이 오류가 보이면 위 명령으로 다시 설치한다.

## 4. 크롤링 실행

대상은 연습용 공개 사이트 `https://quotes.toscrape.com/` 이다.
**강의 저장소 안에서 돌고 있다면 `코드/crawl.py` 가 이미 있다.**
그건 동작이 확인된 코드이므로 **새로 쓰지 말고 그것을 쓴다.**

```
<PY> 코드/crawl.py
```

`코드/` 가 없는 다른 폴더라면 아래 내용으로 `crawl.py` 를 만든다.

```python
import csv
from scrapling.fetchers import Fetcher

rows = []
page = Fetcher.get("https://quotes.toscrape.com/")
print("status:", page.status)

for q in page.css(".quote"):
    rows.append({
        "text":   q.css(".text")[0].text,
        "author": q.css(".author")[0].text,
        "tags":   ",".join(t.text for t in q.css(".tag")),
    })

with open("quotes.csv", "w", newline="", encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=["text", "author", "tags"])
    w.writeheader()
    w.writerows(rows)

print(f"{len(rows)}개 저장 -> quotes.csv")
```

실행한다.

```
<PY> crawl.py
```

여러 페이지를 돌리려면 저장소의 `코드/crawl_all.py` 를 쓴다 (3페이지 30행, 확인됨).

## 5. 결과 확인

`quotes.csv`의 **행 수와 첫 두 줄**을 보여 준다.
0행이면 사이트 구조가 바뀐 것이므로, 실제 HTML을 확인해 CSS 선택자를 고치고 다시 돌린다.

## 막혔을 때

- `AttributeError: 'Selector' object has no attribute 'css_first'` → 이 버전에는 `css_first`가 없다. `q.css(".text")[0].text` 형태로 쓴다
- `No module named 'curl_cffi'` → `[fetchers]` 없이 설치된 것. 3단계를 다시
- `status`가 200이 아니면 → 네트워크나 사이트 문제. 잠시 뒤 다시 시도하라고 안내
- 한글이 깨지면 → `encoding="utf-8-sig"`가 들어 있는지 확인
- 다른 사이트를 크롤링해 달라고 하면 → **먼저 `robots.txt`와 이용약관을 확인**하고, 개인정보나 저작물이면 하지 않는다고 말한다
