#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""PKG_DMF0082 GET — 저장 키 컬럼은 Column Setting 과 무관하게 항상 반환 (사용자 승인 A안, 2026-08-22).

## 결함

GET 출력 컬럼은 **사용자별 Column Setting** 이 결정한다:

    C_TITLE (L137 / L6739)
        FROM SCM_MST_TITLESET_USER U, SCM_MST_SHEET_COLUMNS C
        WHERE U.USER_ID = p_created_by AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C'
    → 그 결과가 V_COLUMN / V_GROUPBY 를 만들고 동적 SQL 의 SELECT 목록이 된다.

그런데 이 목록에는 **저장 키 컬럼**이 섞여 있다(MERGE ON L13763~13774 + FE `save.ts keyOf`).
사용자가 Column Setting 에서 키 컬럼을 숨기면:

    GET 미반환 → FE 가 '' 전송 → ① 검증이 Common 으로 오판해 수정 차단
                                  ② (차단이 없어도) MERGE ON 키 불일치로 중복행

**실증 (2026-08-22)** — `CELL_PROD_SITE_ID` 를 숨긴 계정(minyonglee1, titleset 15컬럼):

    [1] I(qty=7,  CPS='HQ06-A')  → 원장 [('HQ06-A', 7.0)]                       통과
    [2] M(qty=55, CPS='')        → 'Cell Prod Site* 를 Common으로 등록 할 수 없습니다.'
                                    원장 [('HQ06-A', 7.0)] 무변화                 차단

    보유 현황: DMF0082/FcstNPrice titleset 16명 중 CELL_PROD_SITE_ID 보유 15명 · 미보유 1명

⇒ 전역 장애는 아니지만 **표시 선택이 저장 정합성을 조용히 깨뜨리는 구조**다.

## 정정 (A안)

C_TITLE 루프가 끝난 뒤, **저장 키 12종 중 V_COLUMN 에 없는 것을 덧붙인다.**
표시 여부는 FE/메타가 정하므로 payload 에 한 컬럼 더 실리는 것은 무해하고,
FE 는 `item['CELL_PROD_SITE_ID']` 를 그리드 행에서 직접 읽으므로 이것으로 값이 채워진다.

⚠ `V_GROUPBY` 에도 함께 넣는다 — SELECT 목록에만 넣으면 ORA-00979 다. 그 결과
   **키 컬럼을 숨긴 사용자에 한해** 지금까지 뭉쳐 보이던 행이 분리될 수 있다(A안의 알려진 trade-off).
   키 컬럼을 이미 다 보유한 15명은 이미 GROUP BY 에 들어 있어 **변화 없음**.

## 적용 대상 — GET 2벌 모두

    P_DMF0082_GET_MAIN_DATA          (L6~3945)      FE SEARCH
    P_DMF0082_GET_MAIN_DATA_CURRENT  (L6568~8943)   FE SEARCH_CURRENT

두 프로시저는 C_TITLE / V_COLUMN 블록을 **각각 1벌씩** 갖고 텍스트가 거의 같다. 그래서 본문 전체에서
문자열 치환하면 앵커가 2회 잡힌다 — **프로시저 구간별로 잘라서** 각 구간 안에서만 치환한다.

## 안전 절차

    BACKUP → 구간별 치환 → 사본 패키지(스펙+본문) 컴파일 시험 → 적용 → VERIFY → INVALID 시 자동 원복

멱등: 마커가 있으면 무변경. 실행: python apply.py   (점검만: --dry)
"""
import io
import os
import re
import sys

sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics\ui_meta_dictionary_20260821")
import cfg  # noqa: E402

PKG = "PKG_DMF0082"
PROBE = "PKG_DMF0082_PROBEKC"
HERE = os.path.dirname(os.path.abspath(__file__))
NL = chr(10)
MARK = "E20260822-KEYCOL"

TARGET_PROCS = ("P_DMF0082_GET_MAIN_DATA", "P_DMF0082_GET_MAIN_DATA_CURRENT")

# 저장 키 = MERGE ON 절(L13763~13774) + FE save.ts keyOf. CURRENCY 는 SAVE 페이로드 축.
KEY_COLS = ("DIVISION_ID", "PROJECT_CODE", "END_CUSTOMER", "SCM_SITE_ID", "ITEM_ID",
            "DOM_EXP", "FCST_TYPE", "INCOTERMS", "MEASURE", "PLANT_SITE_ID",
            "CELL_PROD_SITE_ID", "CURRENCY")
KEY_CSV = ",".join(KEY_COLS)

BLOCK = """
    --[{mark}] 저장 키 컬럼은 Column Setting 과 무관하게 항상 반환한다 (사용자 승인 A안, 2026-08-22).
    --  C_TITLE 는 SCM_MST_TITLESET_USER('C') 를 읽으므로 사용자가 키 컬럼을 숨기면 GET 이 값을 안 준다.
    --  그러면 FE 가 '' 를 보내 ①검증이 Common 으로 오판(수정 차단) ②MERGE ON 키 불일치(중복행) 가 난다.
    --  실측: CELL_PROD_SITE_ID 를 숨긴 계정에서 기존 행 M 저장이
    --        'Cell Prod Site* 를 Common으로 등록 할 수 없습니다' 로 차단됨.
    --  키 목록 = SAVE MERGE ON 절 + FE save.ts keyOf. 이미 있으면 넣지 않는다(멱등).
    --  ⚠ V_GROUPBY 에도 넣어야 한다 — SELECT 목록에만 넣으면 ORA-00979.
    FOR K IN (SELECT REGEXP_SUBSTR('{keys}', '[^,]+', 1, LEVEL) AS C
                FROM DUAL
             CONNECT BY REGEXP_SUBSTR('{keys}', '[^,]+', 1, LEVEL) IS NOT NULL) LOOP
        IF INSTR(',' || REPLACE(V_COLUMN, ' ', '') || ',', ',' || K.C || ',') = 0 THEN
            V_COLUMN  := V_COLUMN  || ', ' || K.C;
            V_GROUPBY := V_GROUPBY || ', ' || K.C;
        END IF;
    END LOOP;
""".format(mark=MARK, keys=KEY_CSV)

# 각 프로시저 구간 안에서 유일한 앵커 — NOTATION 기본값 처리 직후에 넣는다
# (그 시점에는 V_COLUMN / V_GROUPBY 가 NULL 이 아님이 보장된다).
ANCHOR_RE = re.compile(
    r"V_GROUPBY\s*:=\s*CASE\s+WHEN\s+V_GROUPBY\s+IS\s+NULL\s+THEN\s+' GROUP BY EDIT_FLAG, SORT_ORDER_NO'"
    r"\s+ELSE\s+V_GROUPBY\s*\|\|\s*', EDIT_FLAG, SORT_ORDER_NO'\s+END\s*;", re.I)


def body_of(cur, name=PKG):
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                    AND TYPE='PACKAGE BODY' ORDER BY LINE""", n=name)
    return "".join(r[0] for r in cur.fetchall())


def proc_spans(body):
    """PROCEDURE 선언 위치로 구간을 나눈다 — 같은 이름의 블록이 2벌이라 구간 분리가 필수."""
    hits = [(m.start(), m.group(1).upper())
            for m in re.finditer(r"^\s*PROCEDURE\s+([A-Z0-9_]+)", body, re.I | re.M)]
    spans = {}
    for i, (pos, nm) in enumerate(hits):
        end = hits[i + 1][0] if i + 1 < len(hits) else len(body)
        spans.setdefault(nm, (pos, end))
    return spans


def transform(body):
    spans = proc_spans(body)
    for nm in TARGET_PROCS:
        if nm not in spans:
            sys.exit(f"[ABORT] 프로시저 {nm} 를 찾지 못함 — 중단.")
    # 뒤쪽부터 치환해야 앞 구간의 offset 이 밀리지 않는다
    out, done = body, []
    for nm in sorted(TARGET_PROCS, key=lambda n: spans[n][0], reverse=True):
        s, e = spans[nm]
        seg = out[s:e]
        hits = ANCHOR_RE.findall(seg)
        if len(hits) != 1:
            sys.exit(f"[ABORT] {nm} 구간 내 앵커 {len(hits)}회 (기대 1) — 중단.")
        seg2 = ANCHOR_RE.sub(lambda m: m.group(0) + NL + BLOCK, seg, count=1)
        out = out[:s] + seg2 + out[e:]
        done.append(nm)
    return out, done


def compile_probe(cur, con, text):
    probe_ddl = re.sub(r'(PACKAGE\s+BODY\s+")' + PKG + r'(")', r"\1" + PROBE + r"\2",
                       text, count=1, flags=re.I)
    if PROBE not in probe_ddl:
        probe_ddl = re.sub(r"(PACKAGE\s+BODY\s+)" + PKG, r"\1" + PROBE,
                           text, count=1, flags=re.I)
    if PROBE not in probe_ddl:
        return None, "이름 치환 실패"
    probe_ddl = re.sub(r"(\bEND\s+)" + PKG + r"(\s*;)", r"\1" + PROBE + r"\2",
                       probe_ddl, flags=re.I)
    cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME=:n
                    AND TYPE='PACKAGE' ORDER BY LINE""", n=PKG)
    spec = "".join(r[0] for r in cur.fetchall())
    if not spec:
        return None, "원본 스펙을 읽지 못함"
    spec_ddl = re.sub(r'(PACKAGE\s+")' + PKG + r'(")', r"\1" + PROBE + r"\2",
                      spec, count=1, flags=re.I)
    if PROBE not in spec_ddl:
        spec_ddl = re.sub(r"(PACKAGE\s+)" + PKG, r"\1" + PROBE, spec, count=1, flags=re.I)
    spec_ddl = re.sub(r"(\bEND\s+)" + PKG + r"(\s*;)", r"\1" + PROBE + r"\2", spec_ddl, flags=re.I)
    try:
        cur.execute("CREATE OR REPLACE " + spec_ddl)
        con.commit()
    except Exception as ex:                                    # noqa: BLE001
        return None, "사본 스펙 생성 실패: " + str(ex).splitlines()[0][:90]
    try:
        cur.execute("CREATE OR REPLACE " + probe_ddl)
        con.commit()
    except Exception as ex:                                    # noqa: BLE001
        return False, str(ex).splitlines()[0][:130]
    cur.execute("SELECT COUNT(*) FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n", n=PROBE)
    ne = cur.fetchone()[0]
    msg = ""
    if ne:
        cur.execute("""SELECT LINE, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR' AND NAME=:n
                        ORDER BY SEQUENCE FETCH FIRST 3 ROWS ONLY""", n=PROBE)
        msg = " | ".join("L{0}: {1}".format(a, b.strip()[:70]) for a, b in cur.fetchall())
    for ddl in ("DROP PACKAGE BODY SCM_MGR." + PROBE, "DROP PACKAGE SCM_MGR." + PROBE):
        try:
            cur.execute(ddl)
            con.commit()
        except Exception:                                      # noqa: BLE001
            pass
    return (ne == 0), msg


def main():
    dry = "--dry" in sys.argv
    con = cfg.tobe_connect()
    cur = con.cursor()

    before = body_of(cur)
    print(f"== 본문 {len(before):,} chars ==")
    if MARK in before:
        print("== 이미 정정됨 — 무변경 종료 ==")
        con.close()
        return 0

    bak = os.path.join(HERE, "BACKUP_" + PKG + "_BODY.sql")
    if not os.path.exists(bak):
        io.open(bak, "w", encoding="utf-8", newline="").write(before)
        print(f"== BACKUP: {bak} ==")

    after, done = transform(before)
    print(f"== 치환 {len(done)}곳: {', '.join(done)} ==")

    if after.count(MARK) != 2:
        sys.exit(f"[ABORT] 마커 {after.count(MARK)}곳 (기대 2) — 중단.")
    for stmt in ("MERGE INTO", "CURSOR C_TITLE", "OPEN C_TITLE"):
        if after.count(stmt) != before.count(stmt):
            sys.exit(f"[ABORT] '{stmt}' 개수 변동 — 중단.")
    # 삽입 위치 검증 — 두 마커가 각각 대상 프로시저 구간 안에 있어야 한다
    spans = proc_spans(after)
    for nm in TARGET_PROCS:
        s, e = spans[nm]
        if after[s:e].count(MARK) != 1:
            sys.exit(f"[ABORT] {nm} 구간 마커 {after[s:e].count(MARK)}개 (기대 1) — 중단.")
    print("   위치 PASS — 두 GET 프로시저 구간에 각 1개")

    if dry:
        io.open(os.path.join(HERE, "PREVIEW_" + PKG + "_BODY.sql"), "w",
                encoding="utf-8", newline="").write(after)
        i = after.index(MARK)
        print(NL + "== PREVIEW ==" + NL + after[i - 260:i + 1180])

    print(NL + f"== 사본 컴파일 시험 ({PROBE}) ==")
    ok, msg = compile_probe(cur, con, after)
    if ok is None:
        print(f"   [ABORT] 시험 자체 실패: {msg}")
        con.close()
        return 1
    if not ok:
        print(f"   FAIL — 원본 미적용 유지. {msg}")
        con.close()
        return 1
    print("   PASS — 사본 VALID / ERRORS 0")

    if dry:
        print(NL + "== --dry: DB 미적용 종료 ==")
        con.close()
        return 0

    cur.execute("ALTER SESSION SET DDL_LOCK_TIMEOUT = 120")
    cur.execute("CREATE OR REPLACE " + after)
    con.commit()
    print(NL + "== 원본 재컴파일 완료 ==")

    print(NL + "== VERIFY ==")
    bad = 0
    cur.execute("""SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                    AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'""", n=PKG)
    st = (cur.fetchone() or ["(없음)"])[0]
    print(f"   {'PASS' if st == 'VALID' else 'FAIL'}  {PKG} BODY STATUS = {st}")
    bad += 0 if st == "VALID" else 1

    cur.execute("""SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER='SCM_MGR'
                    AND NAME=:n ORDER BY SEQUENCE""", n=PKG)
    errs = cur.fetchall()
    print(f"   {'PASS' if not errs else 'FAIL'}  ALL_ERRORS {len(errs)}건")
    for e in errs[:5]:
        print("        ", e)
    bad += 0 if not errs else 1

    if bad:
        print(NL + "   ⛔ INVALID — 백업으로 자동 원복한다.")
        cur.execute("CREATE OR REPLACE " + before)
        con.commit()
        cur.execute("""SELECT STATUS FROM ALL_OBJECTS WHERE OWNER='SCM_MGR'
                        AND OBJECT_NAME=:n AND OBJECT_TYPE='PACKAGE BODY'""", n=PKG)
        print(f"   원복 후 STATUS = {(cur.fetchone() or ['?'])[0]}")
        con.close()
        return 1

    cur.execute("""SELECT COUNT(*) FROM ALL_OBJECTS O WHERE O.OWNER='SCM_MGR'
                    AND O.STATUS='INVALID'
                    AND O.OBJECT_NAME IN (SELECT NAME FROM ALL_DEPENDENCIES
                                           WHERE OWNER='SCM_MGR' AND REFERENCED_NAME=:n)""", n=PKG)
    print(f"   {'PASS' if cur.fetchone()[0] == 0 else 'WARN'}  의존 객체 INVALID 확인")

    fin = body_of(cur)
    ok2 = fin.count(MARK) == 2
    print(f"   {'PASS' if ok2 else 'FAIL'}  적용 후 마커 {fin.count(MARK)}곳 (기대 2)")
    bad += 0 if ok2 else 1

    con.close()
    return 1 if bad else 0


if __name__ == "__main__":
    sys.exit(main())
