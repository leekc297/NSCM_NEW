#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""STEP9 — TRANSFER 전 구간 end-to-end 실측 (배포 후)

프로시저를 **호출하지 않는다** — 하위 PROC 들이 내부 COMMIT 을 하기 때문(실데이터 확정 위험).
대신 라이브 소스에서 각 문장을 그대로 뽑아 같은 순서로 실행하고 **마지막에 전체 ROLLBACK** 한다.
따라서 커밋되는 변경은 0이며, 소요만 측정한다.

MOBILE_REPORT_CREATE(division 40 경로) 순서:
  V1 중복검증 SELECT (FN_GET_COUNTRY_KR_NAME 포함 — 남은 1순위 함수 후보 측정)
  M1 DELETE  DM_PLN_SALES_PLAN_REPORT_C (DATA_TYPE='2')
  M2 INSERT  DM_PLN_SALES_PLAN_REPORT_C  (FN_GET_COUNTRY_KR_NAME 포함)
  P1 DELETE  DM_MOBILE_REPORT_PRODUCT      / P2 INSERT   ← ★ 사고 문장
  D1 DELETE  DM_MOBILE_REPORT_DEPT / D2 GTT DELETE / D3 GTT INSERT
  D4~D6 UPDATE(부서 기타 재배정) / D7 INSERT DM_MOBILE_REPORT_DEPT
  E1 DELETE  DM_MOBILE_REPORT_EXCHANGE_RATE / E2 INSERT
"""
import sys, pathlib, re, time
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
from ora import conn_info
import oracledb

DIV, VER = '40', 'R_S_20260128_V002_C'

u, p, dsn = conn_info()
con = oracledb.connect(user=u, password=p, dsn=dsn)
con.call_timeout = 1800000
cur = con.cursor()

cur.execute("""SELECT TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_DMF0044'
                AND TYPE='PACKAGE BODY' ORDER BY LINE""")
live = "".join(r[0] for r in cur.fetchall())


def mask(s):
    out = list(s); i = 0; n = len(s)
    while i < n:
        if s[i] == "'":
            j = i + 1
            while j < n:
                if s[j] == "'":
                    if j + 1 < n and s[j+1] == "'": j += 2; continue
                    break
                j += 1
            for k in range(i, min(j+1, n)): out[k] = ' '
            i = j + 1
        elif s.startswith('--', i):
            j = s.find('\n', i); j = n if j < 0 else j
            for k in range(i, j): out[k] = ' '
            i = j
        elif s.startswith('/*', i):
            j = s.find('*/', i+2); j = n if j < 0 else j+2
            for k in range(i, j): out[k] = ' '
            i = j
        else:
            i += 1
    return "".join(out)


M = mask(live)


def proc_span(proc):
    # ⚠ 경계는 **컬럼 0 의 최상위 PROCEDURE** 만. `^\s*PROCEDURE` 로 잡으면 중첩 로컬
    #    프로시저(MOBILE_REPORT_CREATE 안의 `    PROCEDURE LOG_END IS`)에서 구간이 잘린다.
    s = [mm.start() for mm in re.finditer(r'(?im)^PROCEDURE\s+' + proc + r'\b', M)][0]
    nx = [mm.start() for mm in re.finditer(r'(?im)^PROCEDURE\s+\w+', M) if mm.start() > s]
    return s, (nx[0] if nx else len(M))


def stmt_at(proc, needle, occ=0):
    s, e = proc_span(proc)
    hits = [mm.start() for mm in re.finditer(re.escape(needle), M[s:e])]
    st = s + hits[occ]
    j = st; depth = 0
    while j < e:
        if M[j] == '(': depth += 1
        elif M[j] == ')': depth -= 1
        elif M[j] == ';' and depth == 0: break
        j += 1
    return live[st:j].strip()


cur.execute("SELECT MAX(SUBSTR(YYYYMMDD,1,4)) FROM DM_MDF_VERSION WHERE VERSION_NO=:v", {"v": VER})
YYYY = cur.fetchone()[0]
cur.execute("SELECT MAX(ORI_VERSION_NO) FROM SCM_MGR.DM_MDF_VERSION WHERE DIVISION_ID=:d AND VERSION_NO=:v",
            {"d": DIV, "v": VER})
ORIV = cur.fetchone()[0]

MRC = 'P_DMF0044_MOBILE_REPORT_CREATE'
DEP = 'P_DMF0044_SALES_REPORT_DEPT_CREATE'
PRD = 'P_DMF0044_SALES_REPORT_PRODUCT_CREATE'
EXC = 'P_DMF0044_SALES_REPORT_EXCHANGE_RATE_CREATE'

STEPS = [
    ("V1 중복검증(FN_GET_COUNTRY_KR_NAME 포함)", 'SELECT COUNT(*) INTO v_chk FROM (', MRC, 0),
    ("M1 DELETE  SALES_PLAN_REPORT_C(DT2)",      'DELETE FROM DM_PLN_SALES_PLAN_REPORT_C', MRC, 0),
    ("M2 INSERT  SALES_PLAN_REPORT_C(DT2)",      'INSERT INTO DM_PLN_SALES_PLAN_REPORT_C', MRC, 0),
    ("P1 DELETE  MOBILE_REPORT_PRODUCT",         'DELETE FROM SCM_MGR.DM_MOBILE_REPORT_PRODUCT', PRD, 0),
    ("P2 INSERT  MOBILE_REPORT_PRODUCT ★",       'INSERT INTO SCM_MGR.DM_MOBILE_REPORT_PRODUCT', PRD, 0),
    ("D1 DELETE  MOBILE_REPORT_DEPT",            'DELETE FROM SCM_MGR.DM_MOBILE_REPORT_DEPT', DEP, 0),
    ("D2 DELETE  GTT",                           'DELETE FROM SCM_MGR.GT_DMF0044_DEPT_RPT_C', DEP, 0),
    ("D3 INSERT  GTT",                           'INSERT INTO SCM_MGR.GT_DMF0044_DEPT_RPT_C', DEP, 0),
    ("D4 UPDATE  GTT 부서→기타",                  'UPDATE SCM_MGR.GT_DMF0044_DEPT_RPT_C', DEP, 0),
    ("D5 UPDATE  SALES_PLAN 부서→기타",           'UPDATE DM_PLN_SALES_PLAN_REPORT_C', DEP, 0),
    ("D6 UPDATE  ETC 부서→기타",                  'UPDATE DM_PLN_SALES_ETC_REPORT_C', DEP, 0),
    ("D7 INSERT  MOBILE_REPORT_DEPT",            'INSERT INTO SCM_MGR.DM_MOBILE_REPORT_DEPT', DEP, 0),
    ("E1 DELETE  MOBILE_REPORT_EXCHANGE_RATE",   'DELETE FROM SCM_MGR.DM_MOBILE_REPORT_EXCHANGE_RATE', EXC, 0),
    ("E2 INSERT  MOBILE_REPORT_EXCHANGE_RATE",   'INSERT INTO SCM_MGR.DM_MOBILE_REPORT_EXCHANGE_RATE', EXC, 0),
]

DECL = f"""
    P_DIVISION_ID    VARCHAR2(32) := '{DIV}';
    P_VERSION_NO     VARCHAR2(50) := '{VER}';
    P_YYYY           VARCHAR2(4)  := '{YYYY}';
    v_yyyy           VARCHAR2(4)  := '{YYYY}';
    v_user_id        VARCHAR2(10) := 'mdf_batch';
    P_CREATED_BY     VARCHAR2(30) := 'mdf_batch';
    v_ori_version_no VARCHAR2(50) := {'NULL' if ORIV is None else chr(39)+ORIV+chr(39)};
    V_SP_BP          VARCHAR2(2);
    v_etc_department_id VARCHAR2(30);
    v_chk            PLS_INTEGER := 0;
"""

print(f"{'단계':<44}{'소요(초)':>10}{'영향행':>12}")
print("-" * 68)
total = 0.0
try:
    # 사전 계산 (프로시저가 하는 것과 동일)
    cur.execute("""SELECT CASE WHEN COUNT(*)>0 THEN 'BP' ELSE 'SP' END FROM DM_PLN_SALES_PLAN_REPORT_C
                    WHERE DIVISION_ID=:d AND VERSION_NO=:v AND MEASURE='Business_Plan' AND ROWNUM=1""",
                {"d": DIV, "v": VER})
    SPBP = cur.fetchone()[0]
    cur.execute("""SELECT MAX(SEGMENT1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                    WHERE LOOKUP_TYPE='MDF_DEPARTMENT' AND ATTRIBUTE1='Y'""")
    ETCD = cur.fetchone()[0]

    for label, needle, proc, occ in STEPS:
        s = stmt_at(proc, needle, occ)
        blk = ("DECLARE" + DECL
               + f"BEGIN\n    V_SP_BP := '{SPBP}';\n"
               + f"    v_etc_department_id := {'NULL' if ETCD is None else chr(39)+ETCD+chr(39)};\n"
               + s + ";\n    :rc := SQL%ROWCOUNT;\nEND;")
        rc = cur.var(oracledb.NUMBER)
        t0 = time.time()
        cur.execute(blk, {"rc": rc})
        el = time.time() - t0
        total += el
        n = rc.getvalue()
        print(f"{label:<44}{el:>10.2f}{int(n) if n is not None else 0:>12,}")
finally:
    con.rollback()

print("-" * 68)
print(f"{'TRANSFER 전 구간 합계':<44}{total:>10.2f}")
print("\n[정리] 전체 ROLLBACK 완료 — 커밋된 변경 0")
con.close()
