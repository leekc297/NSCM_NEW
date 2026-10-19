# -*- coding: utf-8 -*-
"""[E20260930-DMF0082CLOUDPERF] PKG_DMF0082.P_DMF0082_GET_MAIN_DATA 병목 2문장 계획 고정 — 사내 ZIOUI1 적용.

근거: 클라우드 점검(_diagnostics/DMF0082_CLOUD_PERFCHK_20260930) + 사내 재현 벤치(b01_hint_bench.py)
  ① 2nysu9tbng9v4 (CUST 종속 메저 실적 arm, DM_PLN_MKT_FCST_RESULT)
     커서가 '종속 메저 0행' 사용자 조건에서 파싱되면 GTT 3종 MERGE JOIN CARTESIAN → PK 행별 조회 계획으로 굳어,
     CUST_FCST 선택 사용자(k0101 등 사내 11명)가 재사용 시 18~30초 (BG 860만, 결과 0행).
     → LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) + D·C 해시 : 28.41s → 0.03s (결과 동일)
  ② 7mrzdbpupw3b9 (div40 T_LAST_DATA_SETUP_FCST, DM_PLN_CFM_MKT_DEMAND_PLAN)
     TEMP_SITE_ITEM 0행 추정으로 파싱되면 NESTED LOOPS + PK 행별 조회 (클라우드 9.4s / 사내 재현 4.6s)
     → 형제 문장 L1265([E20260815-PERF2]) 와 동일 힌트 LEADING(A) USE_HASH(C) : 4.64s → 0.69s (결과 동일)
변경 = 두 SELECT 줄에 힌트 삽입(같은 줄) + 헤더 이력 1줄 (이후 라인번호 +1). 타 문장·타 프로시저 1바이트 불변 (assert).
FRESH-GATE: 추출 시 LAST_DDL·원문 기록 → 실행 직전 재조회 일치 시에만 CREATE OR REPLACE. 컴파일 실패 시 백업 자동 원복.
사용: python apply_cloudperf.py build | apply
"""
import datetime, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "build"
MARK = "E20260930-DMF0082CLOUDPERF"
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cur = cn.cursor()


def last_ddl():
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS "
                "WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
    return cur.fetchone()[0]


def fetch_lines():
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY LINE")
    return [t or "" for (t,) in cur]


ddl0 = last_ddl()
lines = fetch_lines()
src = "".join(lines)
now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
assert MARK not in src, "이미 적용된 원문 — 재적용 금지(멱등 가드)"
L = lambda n: lines[n - 1]  # 1-based

# ① L1943 — 앵커: 1931 INSERT INTO TEMP_FCST_N_PRICE · 2003 FROM DM_PLN_MKT_FCST_RESULT A · 2007 종속 게이트 · 2019 종결
assert L(1931).strip() == "INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE"
assert L(1943).rstrip("\r\n") == "        SELECT A.DIVISION_ID"
assert L(2003).strip() == "FROM   SCM_MGR.DM_PLN_MKT_FCST_RESULT A"
assert L(2004).strip() == "INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B"
assert "B.MEASURE <> 'CUST_FCST'" in L(2007)
assert L(2008).strip() == "INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C"
assert L(2014).strip() == "INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D"
assert L(2019).strip() == "AND    A.QTY <> 0;"
# ② L1229 — 앵커: 1226 ELSE · 1227 INSERT T_LAST_DATA_SETUP_FCST · 1233 FROM DM_PLN_CFM_MKT_DEMAND_PLAN A · 1234 C
assert L(1226).strip() == "ELSE"
assert L(1227).strip() == "INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_FCST"
assert L(1229).rstrip("\r\n") == "    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID"
assert L(1233).strip() == "FROM   SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN A"
assert L(1234).strip() == "INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C"
assert "/*+" not in L(1943) and "/*+" not in L(1229)

nl1943 = L(1943)[len(L(1943).rstrip("\r\n")):]
nl1229 = L(1229)[len(L(1229).rstrip("\r\n")):]
new = list(lines)
new[1943 - 1] = ("        SELECT /*+ LEADING(B A D C) USE_NL(A) INDEX(A IDX_DM_PLN_MKT_FCST_RESULT_N1) USE_HASH(D) USE_HASH(C) "
                 "SWAP_JOIN_INPUTS(D) SWAP_JOIN_INPUTS(C) */ /*[" + MARK + "] 종속메저 0행 파싱 계획(CARTESIAN→PK 행별) 고정 방지 — "
                 "k0101 28.4s→0.03s */ A.DIVISION_ID" + nl1943)
new[1229 - 1] = ("    SELECT /*+ LEADING(A) USE_HASH(C) */ /*[" + MARK + "] L1265 형제문장 동일 — TEMP_SITE_ITEM 1행 추정 NL 방지 "
                 "(클라우드 9.4s) */ A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID" + nl1229)
diff = [i + 1 for i in range(len(lines)) if lines[i] != new[i]]
assert diff == [1229, 1943] and len(new) == len(lines), diff

hist_anchor = " *                               82 후행 UPDATE 2건 INSERT 흡수 / 중복제거 안전망 조건부 실행 (결과 전행 동일 검증)\n"
new_src = "".join(new)
assert new_src.count(hist_anchor) == 1
new_src = new_src.replace(hist_anchor, hist_anchor +
    f" * 2026.09.30       admin        [{MARK}] 클라우드 병목 2문장 계획 고정 힌트 (CUST 종속 실적 arm L1943 · div40 LAST_DATA_FCST L1229)\n", 1)
print(f"기준본 LAST_DDL={ddl0}  변경 라인 {diff} (+이력 1줄)  {len(src):,}B → {len(new_src):,}B")

stamp = f"-- SOURCE-FRESH: SCM_MGR.PKG_DMF0082 PACKAGE BODY LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
(HERE / "00_BACKUP_PKG_DMF0082_BODY.sql").write_text(
    stamp + "-- 적용 전 원문 백업 (USER_SOURCE 그대로)\nCREATE OR REPLACE " + src.rstrip() + "\n/\n", encoding="utf-8")
(HERE / "99_ROLLBACK_PKG_DMF0082_BODY.sql").write_text(
    stamp + f"-- [{MARK}] 원복 = 적용 전 원문 재컴파일\nCREATE OR REPLACE " + src.rstrip() + "\n/\n", encoding="utf-8")
(HERE / "01_PKG_DMF0082_BODY_CLOUDPERF.sql").write_text(
    stamp + f"-- [{MARK}] PKG_DMF0082 BODY 전체본 (GET_MAIN_DATA 2줄 힌트 + 이력 1줄)\nCREATE OR REPLACE "
    + new_src.rstrip() + "\n/\n", encoding="utf-8")
print("파일 생성 완료")

if MODE == "apply":
    # FRESH-GATE — 실행 직전 원문 재조회 일치 확인
    assert last_ddl() == ddl0 and "".join(fetch_lines()) == src, "FRESH-GATE: 추출 이후 PKG_DMF0082 변경됨 — 중단"
    cur.execute("CREATE OR REPLACE " + new_src.rstrip())
    cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
    st = cur.fetchone()[0]
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME='PKG_DMF0082' AND TYPE='PACKAGE BODY' ORDER BY SEQUENCE")
    errs = cur.fetchall()
    print(f"적용 결과 STATUS={st} 오류={len(errs)}  LAST_DDL={last_ddl()}")
    if st != "VALID" or errs:
        for e in errs[:20]:
            print("  ERR", e)
        cur.execute("CREATE OR REPLACE " + src.rstrip())
        cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_DMF0082' AND OBJECT_TYPE='PACKAGE BODY'")
        print("⚠ 컴파일 실패 → 백업 원복 STATUS=", cur.fetchone()[0])
        sys.exit(1)
    body = "".join(fetch_lines())
    assert body.count(MARK) == 3, body.count(MARK)
    print("적용 완료 — 마커 3 확인")
cn.close()
