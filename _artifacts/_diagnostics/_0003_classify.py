#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0003 대사표 — `[원문 무번호]` 자동채번 행 분류 (표 헤더·문서 머리말 vs 실제 요구).

배경: `--init` 이 ID 없는 표 행에 자동 채번하면서 **표 헤더·문서 머리말까지 EID** 로 만들었다.
      그대로 '구현' 으로 채우면 숫자만 맞는 허위 통과가 된다(#126 정직성).

분류 규칙 — 요지 문자열을 보고 기계적으로 가른다. 애매하면 **실제 요구로 남겨** 사람이 보게 한다
      (조용히 '해당없음' 으로 밀어내지 않는다 = 과소 판정 방지).

  ① 문서 머리말 : '화면 ID / 도메인 / 메뉴 / TO-BE FE / AS-IS 소스' 등 메타정보
  ② 표 헤더     : 좌우가 **컬럼명**인 행 — 서술이 아니라 명사 나열이고 .cs 라인·조건이 없음
  ③ 범위 제외   : DMF0003_1 / DMF0003_T (사용자 확정 2026-08-15 — 별도 메뉴)
  ④ 실제 요구   : 위 어디에도 안 걸리는 것 — 코드 대조 대상으로 남긴다
"""
import io, re, sys, pathlib
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

MAP = pathlib.Path(r"C:\Projects\NSCM\nscm-fe\features\demand\src\pages\mkt-fcst\__asis-mapping__.md")

# ③ 범위 제외 — 요지에 이 토큰이 있으면 무조건 제외
SCOPE_OUT = re.compile(r"DMF0003_1\b|DMF0003_T\b")

# ① 문서 머리말 — '키 / 값' 형태의 문서 메타
FRONT_MATTER = re.compile(
    r"^\s*(화면 ID|도메인|메뉴|TO-BE FE|AS-IS|편집 가능|정본|원천|버전|작성)\s*/", re.I)

# ② 표 헤더 — 좌우가 컬럼명. 판정 신호: 서술 부호(.cs 라인/괄호조건/→/MSG)가 **없고** 짧다
HEADER_HINT = re.compile(r"(L\d{3,}|→|MSG\d|\(|\)|=|＝|·)")

def classify(gist: str):
    g = re.sub(r"^§[\d.]+\s*", "", gist).replace("[원문 무번호]", "").strip()
    if SCOPE_OUT.search(g):
        return ("해당없음", "범위 제외 — `DMF0003_1`/`DMF0003_T` 는 별도 메뉴(사용자 확정 2026-08-15). "
                            "본 대사표 대상은 DMF0003 본화면")
    if FRONT_MATTER.match(g):
        return ("해당없음", "문서 머리말(화면 메타정보) — 요구사항 행이 아님. `--init` 자동채번 산물")
    # 표 헤더: 'A / B' 형태 + 서술 신호 없음 + 짧음
    if "/" in g and not HEADER_HINT.search(g) and len(g) <= 40:
        return ("해당없음", "표 헤더 행(컬럼명 나열) — 요구사항 행이 아님. `--init` 자동채번 산물")
    return (None, None)

lines = MAP.read_text(encoding="utf-8").split("\n")
stat = {"범위제외": 0, "머리말": 0, "표헤더": 0, "잔류": 0}
keep = []
for i, l in enumerate(lines):
    if not l.startswith("| "):
        continue
    c = l.split("|")
    if len(c) < 6 or c[5].strip() != "미구현":
        continue
    rid, gist = c[1].strip(), c[2].strip()
    if "[원문 무번호]" not in gist and not SCOPE_OUT.search(gist):
        keep.append((rid, gist)); stat["잔류"] += 1; continue
    st, why = classify(gist)
    if st is None:
        keep.append((rid, gist)); stat["잔류"] += 1; continue
    c[3] = " 해당없음 "
    c[4] = f" {why} "
    c[5] = " 해당없음 "
    lines[i] = "|".join(c)
    stat["범위제외" if "범위 제외" in why else ("머리말" if "머리말" in why else "표헤더")] += 1

MAP.write_text("\n".join(lines), encoding="utf-8")
print(f"[분류] 범위제외 {stat['범위제외']} / 머리말 {stat['머리말']} / 표헤더 {stat['표헤더']} "
      f"→ 해당없음 처리 {sum(v for k,v in stat.items() if k!='잔류')}건")
print(f"[잔류] 실제 요구 후보 {stat['잔류']}건 — 코드 대조 대상\n")
SEC = re.compile("^§[0-9.]+ *")
for rid, g in keep[:40]:
    print("   {:<10}{}".format(rid, SEC.sub("", g)[:96]))
if len(keep) > 40:
    print(f"   … 외 {len(keep)-40}건")
