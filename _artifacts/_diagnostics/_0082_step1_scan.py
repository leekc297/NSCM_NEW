#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""DMF0082 튜닝 — 사용자 방법론 1순위 점검.

절차(사용자 확정 2026-08-15):
  ⓪ 각 호출 시간 측정 → **2초 이상**만 대상 선정
  ① SELECT 컬럼절의 FUNCTION / 스칼라 서브쿼리 → FROM 절 JOIN 으로 전환   ← 1순위
  ② 인덱스 가능한데 못 타는 것 → 타도록
  ③ 필요 시 인덱스 추가
  ④ 조인순서/힌트 등

⓪ 실측 결과 대상 2건: futurePriceInfo 6.35s / savePriceData 2.83s
이 스크립트는 ①을 위해 **SELECT 컬럼절의 함수·스칼라 서브쿼리를 기계적으로 추출**한다.
"""
import io, re, sys, pathlib
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
from ora import conn_info
import oracledb

PROCS = [
    ("futurePriceInfo", "P_DMF0082_POPUP_GET_FUTUREPRICE_INFO"),
    ("savePriceData",   "P_DMF0082_POPUP_GET_SCM_MST_FUTURE_PRICE_SAVE_PRICE_POPUP"),
    ("savePriceTitle",  "P_DMF0082_POPUP_GET_SPREAD_TITLE_SAVE_PRICE"),
]

def select_lists(sql_text):
    """SELECT ... FROM 사이(컬럼절)만 잘라낸다. 괄호 깊이로 중첩 SELECT 는 별도 취급."""
    out = []
    for m in re.finditer(r"\bSELECT\b", sql_text, re.I):
        depth = 0
        i = m.end()
        while i < len(sql_text):
            c = sql_text[i]
            if c == '(':
                depth += 1
            elif c == ')':
                if depth == 0:
                    break
                depth -= 1
            elif depth == 0 and re.match(r"\bFROM\b", sql_text[i:i+4], re.I):
                out.append((m.start(), sql_text[m.end():i]))
                break
            i += 1
    return out

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()

for label, proc in PROCS:
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0082'
                   AND TYPE='PACKAGE BODY' ORDER BY LINE""")
    body = "".join(r[0] for r in cur.fetchall())
    st = body.find(f"PROCEDURE {proc}")
    if st < 0:
        print(f"\n### {label}: 프로시저 {proc} 미발견")
        continue
    nxt = re.search(r"\n\s*PROCEDURE\s+\w+", body[st+10:])
    en = st + 10 + (nxt.start() if nxt else len(body) - st - 10)
    seg = body[st:en]
    print(f"\n{'='*84}\n### {label}  ({proc})  {len(seg):,}자")

    scalar, funcs = [], {}
    for pos, sl in select_lists(seg):
        # 스칼라 서브쿼리 = 컬럼절 안의 (SELECT ...)
        for sm in re.finditer(r"\(\s*SELECT\b", sl, re.I):
            frag = re.sub(r"\s+", " ", sl[sm.start():sm.start()+150])
            scalar.append(frag)
        # 함수 호출 (컬럼절)
        for fm in re.finditer(r"\b(FN_[A-Z0-9_]+|PKG_[A-Z0-9_]+\.[A-Z0-9_]+|PR_[A-Z0-9_]+)\s*\(", sl, re.I):
            funcs[fm.group(1).upper()] = funcs.get(fm.group(1).upper(), 0) + 1

    print(f"  [1순위 대상] SELECT 컬럼절 스칼라 서브쿼리 : {len(scalar)}건")
    for x in scalar[:6]:
        print(f"      • {x[:110]}")
    print(f"  [1순위 대상] SELECT 컬럼절 사용자 함수     : {sum(funcs.values())}건 {dict(list(funcs.items())[:6])}")

    # 참고: 행별 재실행 유발 구조
    for kw, desc in [("LATERAL", "LATERAL 조인"), ("CONNECT BY", "CONNECT BY 토큰분해"),
                     ("PIVOT", "PIVOT"), ("DISTINCT", "DISTINCT")]:
        n = len(re.findall(kw, seg, re.I))
        if n:
            print(f"  [참고] {desc:<18} {n}회")
con.close()
