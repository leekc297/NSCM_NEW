"""SCP0111 [E20261112-YIELDP] — 저장 PROC 의 팩/모듈 수율 임시표 적재를 저장 품목으로 한정

원인 (2026-11-12 사내 ZIOUI1 실측):
  PKG_SCP0111.P_SCP0111_SAVE_INTEGRATION_PSI 의 'pack, cell 수율 가져오기' 구간이 수율 뷰 SCM_MST_YIELD_VER_H_V 를
  Division 조건만으로 GT_SCP0111_YIELD_P 에 넣는다(AS-IS SCP0111_SAVE_INTEGRATION_PSI 1263~1275줄과 같은 형태).
  INSERT 문 형태에서 이 조건의 실행 계획은 FP_MGR.SCM_YIELD_VER_H(324,178,091행 · 5,529,638블록) 전체 읽기다
  (v$sql_plan 10u1hwwg9dkfu · EXPLAIN PLAN 09:53 재현). 11-12 03:31~09:37 저장 호출 2건이 누적 43,410초 동안 0행 처리.
보완 (사용자 지시 2026-11-12 '_H TABLE 전체를 TEMP TABLE 에 넣는 프로세스는 보완대상'):
  적재 조건에 AND A.ITEM_ID = UPPER(V_ITEM_ID) 1줄 추가.
  이 임시표를 읽는 3곳(원문 1759·1785·1847줄 부근 ID/IH/ID)이 모두 ITEM_ID(+) = UPPER(V_ITEM_ID) 로만 읽으므로 결과는 같다
  (품목 6개 + 없는 품목 1개 × 2회: 소비 조건 적용 후 행 집합 동일 · '=' 형태 0.1~0.2초 — 09:52 실측).
  EXPLAIN PLAN: SCM_YIELD_VER_H 접근이 TABLE ACCESS FULL → PK_SCM_YIELD_VER_H INDEX UNIQUE SCAN.
사용: python apply_yieldp.py            (기준본·변경본 파일 생성 + 변경 줄 확인 · DB 무변경)
      python apply_yieldp.py --apply    (FRESH-GATE 후 운영 적용 + VALID·오류 0·적용본 일치 확인)
"""
import sys, pathlib, datetime
import oracledb
sys.path.insert(0, r"C:/Projects/NSCM/_artifacts/_diagnostics")
from ora import conn_info  # noqa: E402

OWNER, NAME = "SCM_MGR", "PKG_SCP0111"
HERE = pathlib.Path(__file__).resolve().parent
MARK = "[E20261112-YIELDP]"
# 대상 = 'pack, cell 수율 가져오기' 구간의 마지막 조건 줄(품목 조건이 없는 쪽). 1번 구간('3. 수율 (팩)')은 뒤에 품목 조건 줄이 이어져 이 문자열과 다르다.
# 원문 줄바꿈 = CRLF(ALL_SOURCE 실측 2026-11-12) — 그대로 맞춘다
ANCHOR = "                            /* pack, cell 수율 가져오기 */\r\n"
OLD = ("                             WHERE IA.OPERATION_ID = A.OPERATION_ID\r\n"
       "                               AND A.DIVISION_ID   = UPPER(V_DIVISION_ID);\r\n")
NEW = ("                             WHERE IA.OPERATION_ID = A.OPERATION_ID\r\n"
       "                               AND A.DIVISION_ID   = UPPER(V_DIVISION_ID)\r\n"
       f"                               AND A.ITEM_ID       = UPPER(V_ITEM_ID);  -- {MARK} 2026-11-12 저장 품목만 적재(읽는 3곳이 모두 ITEM_ID(+) = UPPER(V_ITEM_ID)) — Division 전체 적재는 SCM_YIELD_VER_H 전체 읽기로 끝나지 않음\r\n")


def fetch(cur, typ):
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS'), STATUS FROM ALL_OBJECTS WHERE OWNER=:o AND OBJECT_NAME=:n AND OBJECT_TYPE=:t", o=OWNER, n=NAME, t=typ)
    ddl, st = cur.fetchone()
    cur.execute("SELECT TEXT FROM ALL_SOURCE WHERE OWNER=:o AND NAME=:n AND TYPE=:t ORDER BY LINE", o=OWNER, n=NAME, t=typ)
    return "".join(r[0] for r in cur.fetchall()), ddl, st


def build(base):
    assert MARK not in base, "이미 반영됨"
    assert base.count(ANCHOR) == 1, f"구간 주석 매칭 {base.count(ANCHOR)}"
    assert base.count(OLD) == 1, f"대상 조건 매칭 {base.count(OLD)} (1 이어야 함)"
    a, o = base.index(ANCHOR), base.index(OLD)
    assert 0 < o - a < 2000 and base[a:o].count("INSERT INTO GT_SCP0111_YIELD_P") == 1, "대상 조건이 'pack, cell 수율 가져오기' 구간의 INSERT 가 아님"
    # 이 적재분을 읽는 곳(다음 DELETE FROM GT_SCP0111_YIELD_P 또는 PROC 끝까지)이 모두 저장 품목 조건으로 읽는지 다시 확인
    seg = base[o:]
    refs = seg.count("GT_SCP0111_YIELD_P")
    assert refs == 3, f"적재 뒤 임시표 참조 {refs}곳(3 이어야 함) — 읽는 곳이 바뀜"
    import re
    for al in re.findall(r"GT_SCP0111_YIELD_P\s+(\w+)", seg):
        assert re.search(rf"\b{al}\.ITEM_ID\(\+\)\s*=\s*UPPER\(V_ITEM_ID\)", seg), f"별칭 {al} 가 ITEM_ID(+) = UPPER(V_ITEM_ID) 로 읽지 않음"
    return base.replace(OLD, NEW)


def ddl_of(src):
    return "CREATE OR REPLACE " + src.rstrip() + "\n"


def main():
    apply = "--apply" in sys.argv
    u, p, d = conn_info()
    stamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    with oracledb.connect(user=u, password=p, dsn=d) as con:
        cur = con.cursor()
        cur.execute("ALTER SESSION SET CURRENT_SCHEMA=SCM_MGR")
        body, ddl, st = fetch(cur, "PACKAGE BODY")
        print(f"기준본 BODY LAST_DDL={ddl} STATUS={st} FETCHED={stamp} 줄 수={body.count(chr(10))}")
        tobe = build(body)
        asis_f = HERE / "PKG_SCP0111_BODY.ASIS.sql"
        if not asis_f.exists():
            # 줄바꿈 변환 없이(newline="") 쓴다 — FRESH-GATE 비교가 글자 단위로 맞도록
            with open(asis_f, "w", encoding="utf-8", newline="") as f:
                f.write(f"-- SOURCE-FRESH: {OWNER}.{NAME} PACKAGE BODY LAST_DDL={ddl} FETCHED={stamp} DB=ZIOUI1 (원복용 백업)\n" + ddl_of(body) + "/\n")
        with open(HERE / "PKG_SCP0111_BODY.TOBE.sql", "w", encoding="utf-8", newline="") as f:
            f.write(f"-- SOURCE-FRESH: {OWNER}.{NAME} PACKAGE BODY LAST_DDL={ddl} FETCHED={stamp} DB=ZIOUI1\n" + ddl_of(tobe) + "/\n")
        bl, tl = body.split("\n"), tobe.split("\n")
        diff = [(i + 1, x) for i, x in enumerate(tl) if i >= len(bl) or x != bl[i]]
        print("변경 줄수 +", len(tl) - len(bl), "· 첫 변경 줄", diff[0][0] if diff else "-")
        k = next(i for i, x in enumerate(tl) if MARK in x)
        for i in range(k - 2, k + 1):
            print(f"  {i + 1}: {tl[i].rstrip()[:150]}")
        if not apply:
            print("DB 무변경(기준본·변경본 파일만 생성). 적용 = --apply")
            return 0
        # FRESH-GATE: 적용 직전 DB 원문 재조회 == 착수 기준본(백업 파일)
        now, ddl2, _ = fetch(cur, "PACKAGE BODY")
        with open(asis_f, encoding="utf-8", newline="") as f:
            saved = f.read().split("\n", 1)[1]
        assert ddl_of(now) + "/\n" == saved, f"FRESH-GATE 실패: 착수 후 DB 원문 변경(LAST_DDL {ddl2}) — 중단·재조회·재병합"
        cur.execute(ddl_of(build(now)))
        cur.execute("SELECT LINE, POSITION, TEXT FROM ALL_ERRORS WHERE OWNER=:o AND NAME=:n ORDER BY SEQUENCE", o=OWNER, n=NAME)
        errs = cur.fetchall()
        after, ddl3, st3 = fetch(cur, "PACKAGE BODY")
        cur.execute("SELECT OBJECT_NAME, OBJECT_TYPE FROM ALL_OBJECTS WHERE OWNER=:o AND STATUS <> 'VALID' AND OBJECT_NAME LIKE '%SCP0111%'", o=OWNER)
        inv = cur.fetchall()
        print(f"적용 후 BODY LAST_DDL={ddl3} STATUS={st3} 오류 {len(errs)}건 · 적용본==DB 원문 {after.rstrip() == tobe.rstrip()} · SCP0111 INVALID 객체 {len(inv)}건")
        for e in errs[:10]:
            print("  ERR", e)
        return 0 if (st3 == "VALID" and not errs and after.rstrip() == tobe.rstrip() and not inv) else 1


if __name__ == "__main__":
    sys.exit(main())
