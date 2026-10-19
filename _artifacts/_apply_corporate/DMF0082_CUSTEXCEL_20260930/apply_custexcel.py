# -*- coding: utf-8 -*-
"""PKG_DMF0082.P_DMF0082_GET_MAIN_DATA — 'Customer FCST' 원장 행의 메저 표기를 AS-IS 로직대로 RPA/EXCEL 로 분기 [E20260930-DMF0082CUSTEXCEL]

증상 (사용자 2026-09-30): DMF0014 Excel Upload 한 Customer FCST 가 DMF0082 CUST_FCST 하위에 ' └ EXCEL' 이 아니라 'Customer FCST' 로 표기.
원인: AS-IS DMF0003_GET_MKT_FCST_DATA Block 1-C ([E20241126-000426], 살아있는 AS-IS DB 원문 확인) 는 원장 MEASURE='Customer FCST' 행을
      수정자(LAST_UPDATED_BY) 가 '%robot' 이면 'Cust.FCST_RPA[P+P]', 아니면 'Cust.FCST_EXCEL[P+P]' 로 내보내고,
      공용 콤보 'Measure' 가 그 코드를 ' └ EXCEL' / ' └ RPA' 로 표시한다. TO-BE PKG_DMF0003 L7474·L8225 는 동일 이식.
      DMF0082 는 08-25 CUSTSUB 이식 때 이 분기가 빠져 원장 값 'Customer FCST' 가 그대로 나갔고, 콤보는 DMF0082 에 대해
      'Customer FCST' 코드를 매핑하지 않아(DMF0003/0035 한정) 코드 문자열이 그대로 보였다.
조치 (AS-IS 1:1 · 강제 치환 아님 — 행별 수정자 기준 분기):
  ① Current 계획 arm (81/82 DM_PLN_MKT_FCST · 40 DM_PLN_CFM_MKT_DEMAND_PLAN) 의 MEASURE 출력 = AS-IS Block 1-C CASE
     + LAST_UPDATED_BY = AS-IS 동일 (A.LAST_UPDATED_BY || '_RPA' / '_EXCEL', 그 외 행은 기존 LD 값 유지)
  ② Current 실적 arm (DM_PLN_MKT_FCST_RESULT, 종속 메저) 의 MEASURE 출력 = 동일 CASE (TO-BE PKG_DMF0003 R-3 L8225 와 동일)
     + LAST_UPDATED_BY = R-3 동일 (CREATED_BY || '_RPA' / '_EXCEL', 그 외 행은 기존 NULL 유지)
  비교는 UPPER() — AS-IS MSSQL 대소문자 무시 비교와 등가 (사내 마스터에 'Customer Fcst' 296행 실존 — 사용자 지적).
  Cutoff(_C) arm 은 AS-IS 도 분기하지 않으므로 무변경.
변경 = 4줄 교체(각 1줄→1줄), 그 외 1바이트 불변 (assert). FRESH-GATE: 지금 DB 원문 기준 · 적용 직전 재조회 일치 시에만 CREATE OR REPLACE.
usage: python apply_custexcel.py backup | apply | restore
"""
import datetime, io, pathlib, sys
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")
HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(HERE.parents[1] / "_diagnostics"))
from ora import conn_info
import oracledb

MODE = sys.argv[1] if len(sys.argv) > 1 else "backup"
TAG = "E20260930-DMF0082CUSTEXCEL"
NAME, TYP = "PKG_DMF0082", "PACKAGE BODY"
BAK = HERE / "00_BACKUP_PKG_DMF0082_BODY.sql"
NEW = HERE / "01_PKG_DMF0082_BODY_CUSTEXCEL.sql"
u, p, d = conn_info()
cn = oracledb.connect(user=u, password=p, dsn=d)
cn.call_timeout = 900000
cur = cn.cursor()


def last_ddl():
    cur.execute("SELECT TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS') FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    return cur.fetchone()[0]


def fetch():
    cur.execute("SELECT TEXT FROM USER_SOURCE WHERE NAME=:1 AND TYPE=:2 ORDER BY LINE", [NAME, TYP])
    return [t or "" for (t,) in cur]


def compile_src(src):
    cur.execute("CREATE OR REPLACE " + src.rstrip())
    cur.execute("SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME=:1 AND OBJECT_TYPE=:2", [NAME, TYP])
    st = cur.fetchone()[0]
    cur.execute("SELECT LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME=:1 AND TYPE=:2 ORDER BY SEQUENCE", [NAME, TYP])
    return st, cur.fetchall()


if MODE == "restore":
    src = BAK.read_text(encoding="utf-8").split("CREATE OR REPLACE ", 1)[1].rsplit("\n/\n", 1)[0]
    print("restore:", compile_src(src))
    sys.exit(0)

ddl0 = last_ddl()
L = fetch()
src0 = "".join(L)
assert TAG not in src0, "이미 적용됨"
GET = next(i for i, t in enumerate(L) if t.strip() == "PROCEDURE P_DMF0082_GET_MAIN_DATA")
END = next(i for i, t in enumerate(L) if t.strip().startswith("PROCEDURE ") and i > GET)   # 다음 프로시저 = 범위 상한
ins = lambda i: "\n".join(L[i:i + 14])

MEAS_CASE = ("CASE WHEN UPPER({m}) = 'CUSTOMER FCST' THEN CASE WHEN {who} LIKE '%robot' THEN 'Cust.FCST_RPA[P+P]' ELSE 'Cust.FCST_EXCEL[P+P]' END "
             "ELSE {m} END")
LUB_CASE = ("CASE WHEN UPPER(A.MEASURE) = 'CUSTOMER FCST' THEN CASE WHEN {who} LIKE '%robot' THEN {who} || '_RPA' ELSE {who} || '_EXCEL' END "
            "ELSE {orig} END")
CMT = f"  /*[{TAG}] AS-IS DMF0003 Block 1-C [E20241126-000426] 1:1 — 'Customer FCST' 원장 행은 수정자 robot 여부로 RPA/EXCEL 표기 (콤보 'Measure' 가 ' └ EXCEL' 로 표시). UPPER = MSSQL 대소문자 무시 등가*/"

edits = []   # (line_index, new_text)


def arm(src_table, meas_line_pat, lub_line_pat, who_meas, who_lub, lub_orig, who_branch=None):
    who_branch = who_branch or who_lub          # 메저 분기 기준 (AS-IS = LAST_UPDATED_BY) · 접미사 기준(who_lub) 과 분리 가능
    """INSERT INTO GT_DMF0082_TEMP_FCST_N_PRICE 중 FROM {src_table} A 인 Current arm 1개를 찾아 MEASURE·LAST_UPDATED_BY 줄 교체."""
    froms = [i for i in range(GET, END) if L[i].strip() == f"FROM   SCM_MGR.{src_table} A"]
    froms = [i for i in froms if "INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE" in "".join(L[i - 120:i])
             and "TEMP_SELECT_MEASURE B" in "".join(L[i:i + 8]) and "'Current' AS VERSION_NO" in "".join(L[i - 10:i])]
    assert len(froms) == 1, (src_table, froms)
    f = froms[0]
    s = next(i for i in range(f, f - 120, -1) if L[i].lstrip().startswith("SELECT"))
    m = [i for i in range(s, f) if L[i].rstrip("\r\n") == meas_line_pat]
    lub = [i for i in range(s, f) if L[i].rstrip("\r\n") == lub_line_pat]
    assert len(m) == 1 and len(lub) == 1, (src_table, m, lub)
    edits.append((m[0], "             , " + MEAS_CASE.format(m=who_meas, who=who_branch) + CMT + "\n"))
    edits.append((lub[0], "             , " + LUB_CASE.format(who=who_lub, orig=lub_orig) + f" AS LAST_UPDATED_BY  /*[{TAG}] AS-IS 동일 — 수정자 접미사*/\n"))
    print(f"  {src_table:30} SELECT L{s+1}  MEASURE L{m[0]+1}  LAST_UPDATED_BY L{lub[0]+1}")


print(f"기준본 LAST_DDL={ddl0}  GET_MAIN_DATA L{GET+1}~{END}")
# ① Current 계획 arm — 81/82 (DM_PLN_MKT_FCST) · 40 (DM_PLN_CFM_MKT_DEMAND_PLAN): MEASURE=A.MEASURE, LUB=LD.LAST_UPDATED_BY
arm("DM_PLN_MKT_FCST",            "             , A.MEASURE", "             , LD.LAST_UPDATED_BY", "A.MEASURE", "A.LAST_UPDATED_BY", "LD.LAST_UPDATED_BY")
arm("DM_PLN_CFM_MKT_DEMAND_PLAN", "             , A.MEASURE", "             , LD.LAST_UPDATED_BY", "A.MEASURE", "A.LAST_UPDATED_BY", "LD.LAST_UPDATED_BY")
# ② Current 실적 arm — 종속 메저 (DM_PLN_MKT_FCST_RESULT): MEASURE=B.MEASURE(=A.MEASURE 조인), LUB=NULL → R-3 동일 CREATED_BY 기반
arm("DM_PLN_MKT_FCST_RESULT",     "             , B.MEASURE", "             , NULL AS LAST_UPDATED_BY", "A.MEASURE", "A.CREATED_BY", "NULL",
    who_branch="A.LAST_UPDATED_BY")   # R-3: 메저 분기 = LAST_UPDATED_BY · 접미사 = CREATED_BY

new = list(L)
for i, t in edits:
    new[i] = t
assert sorted(i for i, _ in edits) == sorted(set(i for i, _ in edits)) and len(edits) == 6
assert [i for i in range(len(L)) if L[i] != new[i]] == sorted(i for i, _ in edits), "교체 6줄 외 변경 발생"
src1 = "".join(new)
assert src1.count(TAG) == 6

now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M")
stamp = f"-- SOURCE-FRESH: SCM_MGR.{NAME} {TYP} LAST_DDL={ddl0} FETCHED={now} DB=ZIOUI1\n"
BAK.write_text(stamp + "-- 적용 전 원문\nCREATE OR REPLACE " + src0.rstrip() + "\n/\n", encoding="utf-8")
NEW.write_text(stamp + f"-- [{TAG}] PKG_DMF0082 BODY 전체본 (교체 6줄)\nSET DEFINE OFF\nSET SQLBLANKLINES ON\nCREATE OR REPLACE " + src1.rstrip() + "\n/\nSHOW ERRORS PACKAGE BODY SCM_MGR.PKG_DMF0082\n", encoding="utf-8")
(HERE / "_diff_preview.txt").write_text("".join(f"L{i+1}\n- {L[i]}+ {t}\n" for i, t in sorted(edits)), encoding="utf-8")
print("파일 생성 완료 (교체 6줄)")

if MODE == "apply":
    assert last_ddl() == ddl0 and "".join(fetch()) == src0, "FRESH-GATE: 추출 이후 변경 감지 — 중단"
    st, errs = compile_src(src1)
    print(f"적용 결과 STATUS={st} 오류={len(errs)} LAST_DDL={last_ddl()}")
    if st != "VALID" or errs:
        for x in errs[:15]:
            print("  ERR", x)
        print("⚠ 원복:", compile_src(src0))
        sys.exit(1)
cn.close()
