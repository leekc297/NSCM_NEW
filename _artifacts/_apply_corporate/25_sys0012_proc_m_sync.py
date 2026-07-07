"""SYS0012 GET SP PROC_M 동기화 — P_DIVISION_ID / P_DEPARTMENT 추가 (2026-06-28).

목적:
  24_sys0012_search_div_dept.sql 로 P_SYS0012_GET_APPROVAL_LIST 시그니처에
  P_DIVISION_ID(6) / P_DEPARTMENT(7) IN 추가 + 커서 위치 8/9 로 이동.
  → SCM_ADM_PROC_M 의 SORT_ORD(positional)도 동일하게 맞춰야 BE 호출 정합(PLS-00306 차단).

변경 (PROC_NM='P_SYS0012_GET_APPROVAL_LIST'):
  기존 1 sesUserId / 2 userId / 3 startDate / 4 endDate / 5 status / 6 o_rc / 7 O_RESULT_CURSOR
  목표 ... 5 status / 6 divisionId(IN) / 7 department(IN) / 8 o_rc / 9 O_RESULT_CURSOR
  순서: (1) o_rc 6→8, O_RESULT_CURSOR 7→9 (UPDATE) → (2) divisionId@6, department@7 (INSERT)
  COL_NM = camelCase (FE filter key = PROC_M COL_NM 정합). divisionId/department.

멱등: divisionId 행 존재 시 skip (이미 적용).
실행: NSCM_ORA_USER/PASS/DSN 환경변수 설정 후 python 25_sys0012_proc_m_sync.py
      ⚠️ 24_sys0012_search_div_dept.sql (SP) 먼저 적용 후 실행.
"""
import os, sys
import oracledb

sys.stdout.reconfigure(line_buffering=True)

u = os.getenv("NSCM_ORA_USER"); p = os.getenv("NSCM_ORA_PASS"); d = os.getenv("NSCM_ORA_DSN")
assert u and p and d, "NSCM_ORA_USER/PASS/DSN required"

PROC = "P_SYS0012_GET_APPROVAL_LIST"
conn = oracledb.connect(user=u, password=p, dsn=d)
cur = conn.cursor()
print(f"[ connected ] {d}")


def show():
    cur.execute(
        "SELECT COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD FROM SCM_MGR.SCM_ADM_PROC_M "
        "WHERE PROC_NM=:n ORDER BY SORT_ORD", {"n": PROC}
    )
    for r in cur.fetchall():
        print(f"    {r[3]:>2} | {r[0]:<16} | {r[1]:<11} | {r[2]}")


print("\n[ BEFORE ]")
show()

# 멱등 — divisionId 이미 있으면 skip
cur.execute(
    "SELECT COUNT(*) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=:n AND COL_NM='divisionId'",
    {"n": PROC}
)
if cur.fetchone()[0] > 0:
    print("\n[ SKIP ] divisionId 이미 존재 — 이미 적용됨")
    conn.close()
    sys.exit(0)

# (1) 커서 SORT_ORD 이동 (6→8, 7→9)
cur.execute(
    "UPDATE SCM_MGR.SCM_ADM_PROC_M SET SORT_ORD=8 WHERE PROC_NM=:n AND COL_NM='o_rc'", {"n": PROC}
)
cur.execute(
    "UPDATE SCM_MGR.SCM_ADM_PROC_M SET SORT_ORD=9 WHERE PROC_NM=:n AND COL_NM='O_RESULT_CURSOR'",
    {"n": PROC}
)

# (2) divisionId(6) / department(7) IN VARCHAR INSERT
ins = """
INSERT INTO SCM_MGR.SCM_ADM_PROC_M
  (PROC_NM, COL_NM, DATA_TP_CD, COL_TP_CD, SORT_ORD,
   CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)
VALUES (:n, :col, 'VARCHAR', 'IN', :ord, 'admin', SYSDATE, 'admin', SYSDATE)
"""
cur.execute(ins, {"n": PROC, "col": "divisionId", "ord": 6})
cur.execute(ins, {"n": PROC, "col": "department", "ord": 7})
conn.commit()
print("\n[ COMMIT ] divisionId(6) / department(7) 추가 + 커서 8/9 이동")

print("\n[ AFTER ]")
show()

# 검증 — 9행 + positional 연속
cur.execute(
    "SELECT COUNT(*), MAX(SORT_ORD) FROM SCM_MGR.SCM_ADM_PROC_M WHERE PROC_NM=:n", {"n": PROC}
)
cnt, mx = cur.fetchone()
mark = "✓" if cnt == 9 and mx == 9 else "✗"
print(f"\n[ VERIFICATION ] {mark} PROC_M {cnt} 행 (기대 9), MAX SORT_ORD {mx} (기대 9)")

conn.close()
if cnt != 9 or mx != 9:
    sys.exit(1)
