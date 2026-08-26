#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""윈도우 함수 파티션이 상관 조건에 의해 **축소**되는 변환 결함 전수 스캔 (2026-08-22).

## 계기 — DMF0082 실사고

MSSQL `UPDATE … FROM (파생테이블 with OVER(PARTITION BY …)) DD … JOIN` 를 Oracle 로 옮기면서
상관 조건을 **서브쿼리 안**으로 넣으면, 윈도우 함수가 돌기 **전에** 행이 걸러져 파티션이 축소된다.

    -- AS-IS: 파생테이블에서 전 행에 주차 합계 → 바깥에서 날짜 조인 (주차 합계)
    -- TO-BE: 서브쿼리 안에 `B.YYYYMMDD = A.YYYYMMDD` → 그 날짜 1건만 남음 (일 합계)

컴파일도 되고 값도 그럴듯해서 **결과를 대조하지 않으면 드러나지 않는다.**
증상: 단가 1건 수정인데 "삭제 불가" 검증이 발동 (`PKG_DMF0082` 2026-08-22).

## 이 도구가 하는 일

`ALL_SOURCE` 전 PACKAGE BODY / PROCEDURE / FUNCTION 을 **주석 제거 후** 훑어,
`OVER (PARTITION BY …)` 를 포함한 **스칼라 서브쿼리·인라인뷰** 안에 **바깥 별칭을 참조하는 상관 조건**이
있는지 찾는다.

⚠ **자동 판정은 후보 제시까지다.** 상관 조건이 있어도 파티션 축이 그 컬럼과 무관하면 무해할 수 있다.
   각 후보는 사람이 원문을 읽고 확정한다 (#145 — 근거 없이 결함으로 단정하지 않는다).
"""
import io
import json
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
from strip_code_comments import strip_sql                      # noqa: E402
import cfg                                                     # noqa: E402

NL = chr(10)
OUT = r"C:\Projects\NSCM\_artifacts\_diagnostics\_window_partition_correlation_scan.json"


def scan_object(name, otype, text):
    """**결함 시그니처 한정 스캔** — `SET <컬럼> = ( … OVER (PARTITION BY …) … )` 형태만 찾는다.

    DMF0082 실사고의 정확한 형태다. 스칼라 서브쿼리는 바깥 행마다 1건을 돌려줘야 하므로 상관 조건이
    필수인데, 그 상관 조건이 **윈도우 함수보다 먼저** 적용되어 파티션을 바깥 행 1건으로 축소한다.

    ⚠ 일반 인라인뷰·JOIN 안의 `OVER(PARTITION BY)` 는 대상이 아니다 — 그건 정상 패턴이고
      1차 스캔에서 430건이나 잡혀 판독 불가였다(2026-08-22). 시그니처로 좁히는 것이 핵심이다.
    """
    hits = []
    for m in re.finditer(r"\bSET\s+([A-Za-z_][\w.]*)\s*=\s*\(", text, re.I):
        # 여는 괄호부터 짝 맞는 닫는 괄호까지 (문자열 리터럴 안의 괄호는 건너뛴다)
        k = m.end() - 1
        depth, in_str = 0, False
        while k < len(text):
            c = text[k]
            if in_str:
                if c == "'":
                    in_str = False
            elif c == "'":
                in_str = True
            elif c == "(":
                depth += 1
            elif c == ")":
                depth -= 1
                if depth == 0:
                    break
            k += 1
        if k >= len(text):
            continue
        sub = text[m.end() - 1:k + 1]
        if not re.search(r"OVER\s*\(\s*PARTITION\s+BY", sub, re.I):
            continue
        corr = sorted({f"{a}.{c} = {b}.{c}" for a, c, b in
                       re.findall(r"\b([A-Za-z]\w*)\.(\w+)\s*=\s*([A-Za-z]\w*)\.\2\b", sub)
                       if a.upper() != b.upper()})
        part = re.search(r"OVER\s*\(\s*PARTITION\s+BY([^)]{0,140})", sub, re.I)
        hits.append({
            "object": name, "type": otype,
            "line": text[:m.start()].count(NL) + 1,
            "set_column": m.group(1),
            "partition_by": " ".join((part.group(1) if part else "?").split())[:120],
            "correlations": corr[:6],
            "sub_len": len(sub),
        })
    return hits


def main():
    con = cfg.tobe_connect()
    cur = con.cursor()
    cur.execute("""SELECT NAME, TYPE, COUNT(*) FROM ALL_SOURCE
                    WHERE OWNER='SCM_MGR' AND TYPE IN ('PACKAGE BODY','PROCEDURE','FUNCTION')
                    GROUP BY NAME, TYPE ORDER BY NAME""")
    objs = cur.fetchall()
    print(f"== 대상 객체 {len(objs)}개 ==")

    all_hits, scanned = [], 0
    for name, otype, _n in objs:
        cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n AND TYPE=:t
                        ORDER BY LINE""", n=name, t=otype)
        raw = "".join(r[0] for r in cur.fetchall())
        if "PARTITION BY" not in raw.upper():
            continue
        scanned += 1
        code = strip_sql(raw)          # 주석은 근거가 아니다 (hook #138)
        h = scan_object(name, otype, code)
        if h:
            all_hits.extend(h)

    print(f"   PARTITION BY 보유 객체 {scanned}개 · 후보 {len(all_hits)}건{NL}")
    by_obj = {}
    for h in all_hits:
        by_obj.setdefault(h["object"], []).append(h)
    for obj in sorted(by_obj):
        print(f"== {obj} — 후보 {len(by_obj[obj])}건 ==")
        for h in by_obj[obj][:6]:
            print(f"   L{h['line']:6d}  PARTITION BY {h['partition_by'][:70]}")
            print(f"            상관후보: {', '.join(h['correlations'])}")
        if len(by_obj[obj]) > 6:
            print(f"   … 외 {len(by_obj[obj])-6}건")

    io.open(OUT, "w", encoding="utf-8", newline=NL).write(
        json.dumps({"scanned_objects": scanned, "hits": all_hits}, ensure_ascii=False, indent=2))
    print(f"{NL}   -> {OUT}")
    print("   ⚠ 후보 제시까지다 — 파티션 축과 무관한 상관 조건은 무해할 수 있다. 원문 판독으로 확정할 것.")
    con.close()
    return 0


if __name__ == "__main__":
    sys.exit(main())
