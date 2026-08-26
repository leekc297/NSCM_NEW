#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""대사표 `구현` 주장 ↔ 실제 코드 대조 검증기 (사용자 지시 2026-08-22).

## 왜 필요한가 — 실사고

DMF0082 `__asis-mapping__.md` 에 이런 줄이 있었다:

    | M-22 | MKT_FCST / InsertRow(포커스 행 없음)
           | ForecastPrice.tsx `handleInsert` — 시드 없으면 MEASURE='MKT_FCST' | — | 구현 |

**분석은 정확했다.** AS-IS else 분기(`포커스 행 없음 → MKT_FCST`)를 정확히 집어냈다.
그런데 **코드에는 그 조건문이 존재한 적이 없었다** — `MEASURE: ''` 한 줄이었다.
즉 *분석한 내용을 구현하지 않은 채 대사표에 `구현` 이라고 적었고*, 그 거짓 기록이 여러 번의
재점검을 통과했다. 사용자가 화면에서 직접 발견할 때까지.

⇒ **대사표를 AS-IS 만 보고 채우고 TO-BE 코드로 되짚지 않은 것**이 근본 원인이다.

## 이 도구가 하는 일

`상태 = 구현` 인 모든 행에 대해 **구현 위치 셀에서 근거를 추출해 실제 코드와 대조**한다.

| 검사 | 내용 | 판정 |
|---|---|---|
| E1 파일 실존 | 인용된 `*.tsx/ts` 파일이 저장소에 있는가 | 없으면 FAIL |
| E2 라인 범위 | `파일:123-456` 이 파일 라인 수 안인가 | 벗어나면 FAIL |
| E3 심볼 실존 | 백틱 심볼(`` `handleInsert` ``)이 그 파일에 있는가 | 없으면 FAIL |
| E4 리터럴 근거 | 셀에 인용된 `'MKT_FCST'` 류 리터럴이 코드에 있는가 | 없으면 **FAIL** ← M-22 를 잡는 축 |
| E5 근거 공란 | `구현` 인데 위치 셀이 비었는가 | 비면 FAIL |

E4 가 핵심이다. M-22 는 E1~E3 을 전부 통과한다(파일도 심볼도 실존) — **리터럴 대조만이** 거짓
`구현` 을 잡는다.

## 한계 (명시)

- 자연어 서술만 있고 인용 근거가 없는 셀은 **`UNVERIFIABLE`** 로 분류한다. PASS 가 아니다.
- 이 도구는 "인용한 근거가 실재하는가" 만 본다. **동작 동등성은 사람이 봐야 한다.**
- 따라서 `PASS` 는 "거짓 인용이 아니다" 이지 "AS-IS 와 같다" 가 아니다.

사용: python verify_mapping_evidence.py <__asis-mapping__.md 경로> [--json out.json]
"""
import io
import json
import os
import re
import sys

NL = chr(10)
FE_ROOT = r"C:\Projects\NSCM\nscm-fe"
# 코드 파일 확장자 — 이것만 실존 검사 대상
CODE_EXT = (".tsx", ".ts", ".sql", ".java", ".xml")


_INDEX = None


def _build_index():
    """저장소 파일명 → 경로 인덱스를 **1회만** 만든다.

    ⚠ 구 구현은 파일명마다 `os.walk(FE_ROOT)` 를 새로 돌았다. 대사표 1장에 인용 파일이 수십 종이라
    전체 트리를 수십 번 순회했고, 게이트가 10분을 넘겨 **실행 자체가 안 되는 상태**였다(2026-08-23).
    게이트는 돌아야 게이트다 — 인덱스 1회 구축으로 바꾼다.
    """
    global _INDEX
    if _INDEX is not None:
        return _INDEX
    idx = {}
    for dp, dn, fn in os.walk(FE_ROOT):
        # BACKUP_20260818 처럼 **접두** 형태도 제외한다 — 사본이 후보로 섞이면 오판정 원인.
        dn[:] = [d for d in dn
                 if d not in ("node_modules", ".git", "dist") and not d.startswith("BACKUP")]
        for f in fn:
            if f.endswith(CODE_EXT):
                idx.setdefault(f, []).append(os.path.join(dp, f))
    _INDEX = idx
    return idx


BASE_DIR = None          # 검증 대상 대사표가 있는 디렉터리 (최근접 우선 판정 기준)


def find_file(name, cache={}):
    """파일명으로 저장소에서 찾는다 — **대사표와 가까운 경로 우선**.

    ⚠ basename 만으로 고르면 안 된다. `ExchangeRateModal.tsx` 는 저장소에 **6곳**(business-plan /
    sales-reports / forecast-price / sales-future-price / BACKUP 2)에 있어, 임의 선택 시 엉뚱한
    파일의 라인 수로 "라인 범위 초과" FAIL 이 났다(2026-08-23 실측 — 실제 836줄인데 522줄짜리로 판정).
    같은 계보의 사고: SP 배포 검증에서 이름 비슷한 다른 객체 상태를 출력한 건(#136).

    · 인용에 경로가 포함돼 있으면 그 경로로 끝나는 후보를 우선한다.
    · 그다음 대사표 디렉터리(BASE_DIR)와 **공통 접두가 가장 긴** 후보를 고른다.
    """
    if name in cache:
        return cache[name]
    cands = _build_index().get(os.path.basename(name)) or []
    if not cands:
        cache[name] = None
        return None
    want = name.replace(chr(92), "/")
    if "/" in want:
        exact = [c for c in cands if c.replace(chr(92), "/").endswith(want)]
        if exact:
            cands = exact
    if BASE_DIR and len(cands) > 1:
        # ⚠ **대소문자 정규화 필수** — CLI 로 `c:/…`(소문자 드라이브)를 받으면 인덱스의 `C:\…` 와
        #   첫 글자부터 달라 commonprefix 가 **0** 이 된다. 그러면 정렬이 무의미해져 첫 후보
        #   (BACKUP_20260818 사본)가 뽑히고, 엉뚱한 파일의 줄 수로 "라인 범위 초과" FAIL 이 났다
        #   (2026-08-23 실측: 실제 837줄 파일 대신 522줄 사본으로 판정).
        base = os.path.normcase(BASE_DIR)
        cands = sorted(cands, key=lambda c: -len(os.path.commonprefix([os.path.normcase(c), base])))
    cache[name] = cands[0]
    return cache[name]


def read(path, cache={}):
    if path in cache:
        return cache[path]
    try:
        cache[path] = io.open(path, encoding="utf-8", errors="replace").read()
    except Exception:                                          # noqa: BLE001
        cache[path] = None
    return cache[path]


def parse_rows(md):
    rows = []
    for ln, line in enumerate(md.split(NL), 1):
        s = line.strip()
        if not s.startswith("|") or re.match(r"^\|\s*[-: ]+\|", s):
            continue
        c = [x.strip() for x in s.strip("|").split("|")]
        if len(c) < 5 or c[0] in ("ID", "EID"):
            continue
        rows.append({"line": ln, "id": c[0], "gist": c[1], "where": c[2],
                     "reason": c[3], "status": c[-1]})
    return rows


def check(row):
    """한 행을 검증해 (verdict, [사유]) 반환."""
    where, fails, checked = row["where"], [], 0

    if not where:
        return "FAIL", ["구현 위치 공란 — `구현` 주장에 근거가 없다"]

    # E1/E2 — 파일:라인
    for m in re.finditer(r"([\w./\\-]+\.(?:tsx|ts|sql|java|xml))(?::(\d+)(?:-(\d+))?)?", where):
        fname, l1, l2 = m.group(1), m.group(2), m.group(3)
        path = find_file(fname)
        checked += 1
        if not path:
            fails.append(f"E1 파일 미존재: {fname}")
            continue
        if l1:
            txt = read(path)
            if txt is None:
                fails.append(f"E1 파일 판독 실패: {fname}")
                continue
            total = txt.count(NL) + 1
            hi = int(l2 or l1)
            if hi > total:
                fails.append(f"E2 라인 범위 초과: {fname}:{l1}-{l2 or l1} (총 {total}줄)")

    # E3/E4 — 백틱 인용 (심볼 또는 리터럴)
    files = [find_file(m.group(1)) for m in
             re.finditer(r"([\w./\\-]+\.(?:tsx|ts|sql|java|xml))", where)]
    files = [f for f in files if f]
    for m in re.finditer(r"`([^`]{2,60})`", where):
        tok = m.group(1).strip()
        if not re.fullmatch(r"[A-Za-z_][\w.$]*|'[^']+'|\"[^\"]+\"", tok):
            continue                                            # 서술형 백틱은 건너뛴다
        needle = tok.strip("'\"")
        checked += 1
        if not files:
            fails.append(f"E3 심볼 `{tok}` — 대조할 파일 인용이 없다")
            continue
        if not any(needle in (read(f) or "") for f in files):
            kind = "E4 리터럴" if tok[0] in "'\"" else "E3 심볼"
            fails.append(f"{kind} `{tok}` 이 인용 파일에 없다")

    if fails:
        return "FAIL", fails
    if checked == 0:
        return "UNVERIFIABLE", ["인용 근거(파일:라인 / `심볼`)가 없어 기계 대조 불가"]
    return "PASS", []


def main():
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    md_path = sys.argv[1]
    global BASE_DIR
    BASE_DIR = os.path.dirname(os.path.abspath(md_path))
    md = io.open(md_path, encoding="utf-8").read()
    rows = parse_rows(md)

    stat, out = {}, []
    for r in rows:
        if r["status"] != "구현":
            v, why = ("BLANK", ["구현 위치 공란"]) if (not r["where"] and
                                                   r["status"] in ("미구현", "")) else ("SKIP", [])
            stat[r["status"] or "(공란)"] = stat.get(r["status"] or "(공란)", 0) + 1
            if v == "BLANK":
                out.append({**r, "verdict": "BLANK", "why": why})
            continue
        v, why = check(r)
        stat[v] = stat.get(v, 0) + 1
        if v != "PASS":
            out.append({**r, "verdict": v, "why": why})

    total_impl = sum(v for k, v in stat.items() if k in ("PASS", "FAIL", "UNVERIFIABLE"))
    print(f"== 대사표 근거 검증: {os.path.basename(md_path)} ==")
    print(f"   전체 행 {len(rows)} · '구현' 주장 {total_impl}")
    for k in ("PASS", "FAIL", "UNVERIFIABLE"):
        if k in stat:
            print(f"      {k:14s} {stat[k]:4d}")
    others = {k: v for k, v in stat.items() if k not in ("PASS", "FAIL", "UNVERIFIABLE")}
    if others:
        print(f"   그 외 상태: {others}")

    fails = [o for o in out if o["verdict"] == "FAIL"]
    blanks = [o for o in out if o["verdict"] == "BLANK"]
    unver = [o for o in out if o["verdict"] == "UNVERIFIABLE"]

    if fails:
        print(f"{NL}== ⛔ FAIL — 거짓 인용 {len(fails)}건 ==")
        for o in fails[:30]:
            print(f"   [{o['id']}] {o['gist'][:52]}")
            for w in o["why"][:3]:
                print(f"        → {w}")
    if blanks:
        print(f"{NL}== ⚠ 근거 공란 {len(blanks)}건 (상태={{미구현/공란}}) ==")
        for o in blanks[:30]:
            print(f"   [{o['id']}] {o['gist'][:60]}  상태={o['status'] or '(공란)'}")
    if unver:
        print(f"{NL}== ℹ UNVERIFIABLE {len(unver)}건 — 인용 근거 없어 기계 대조 불가(PASS 아님) ==")
        for o in unver[:12]:
            print(f"   [{o['id']}] {o['gist'][:60]}")
        if len(unver) > 12:
            print(f"   … 외 {len(unver)-12}건")

    if "--json" in sys.argv:
        dst = sys.argv[sys.argv.index("--json") + 1]
        io.open(dst, "w", encoding="utf-8", newline=NL).write(
            json.dumps({"file": md_path, "stat": stat, "rows": out},
                       ensure_ascii=False, indent=2))
        print(f"{NL}   -> {dst}")

    return 1 if (fails or blanks) else 0


if __name__ == "__main__":
    sys.exit(main())
