# -*- coding: utf-8 -*-
"""
Phase 1 — ZIOUI1 실측 수집 (읽기 전용).
  · 권한 매트릭스 (GET_ADMIN_GROUP / GET_ADMIN_GROUP_MEASURE)
  · 권한그룹 x 계정
  · 배치 JOB job_action 전문 (수동 실행 SP·인자 추출용)
  · 화면 배선 (MNU_BTN_MPG_M x API_M)
  · 최신 버전 (division x cutoff_type)
"""
import json, re, pathlib, sys, datetime
sys.path.insert(0, r"C:\Projects\NSCM\_artifacts\_diagnostics")
import oracledb

D = pathlib.Path(__file__).resolve().parent
SCREENS = ("DMF0082", "DMF0003", "DMF0020", "DMF0014", "DMF0021",
           "DMF0042", "DMF0044", "DMF0049", "DMF0035")


def conn():
    sh = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_apply_corporate\apply.sh")
    m = re.search(r"CONN='([^/]+)/\"([^\"]+)\"@([^']+)'", sh.read_text(encoding="utf-8", errors="ignore"))
    return oracledb.connect(user=m.group(1), password=m.group(2), dsn=m.group(3))


def rows(cur, sql, **kw):
    cur.execute(sql, kw)
    cols = [c[0] for c in cur.description]
    return [dict(zip(cols, r)) for r in cur.fetchall()]


out = {}
with conn() as db:
    cur = db.cursor()
    cur.execute("SELECT SYS_CONTEXT('USERENV','DB_NAME'), SYS_CONTEXT('USERENV','SERVER_HOST'), "
                "SYS_CONTEXT('USERENV','SESSION_USER'), TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
    out["meta"] = dict(zip(("db", "host", "user", "fetched"), cur.fetchone()))
    print("접속:", out["meta"])

    # 1) 권한 그룹
    out["auth_group"] = rows(cur, """
        SELECT SEGMENT1 AUTH, SEGMENT2 SCOPE, ATTRIBUTE1 ATTR1, VALID_YN
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE='GET_ADMIN_GROUP' ORDER BY SEGMENT1, SEGMENT2""")

    # 2) 권한 x 화면 x DIV x MEASURE  (편집요일 = ATTRIBUTE1)
    out["auth_measure"] = rows(cur, """
        SELECT SEGMENT1 AUTH, SEGMENT2 SCR, SEGMENT3 DIV, SEGMENT4 MEASURE,
               ATTRIBUTE1 EDIT_DAY, VALID_YN
          FROM SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE='GET_ADMIN_GROUP_MEASURE' AND VALID_YN='Y'
         ORDER BY SEGMENT2, SEGMENT3, SEGMENT1, SEGMENT4""")

    # 3) 권한그룹 x 계정
    out["accounts"] = rows(cur, """
        SELECT M.USER_GR_ID AUTH, M.USER_ID, U.USER_NM
          FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M M
          LEFT JOIN SCM_MGR.SCM_ADM_USER_M U ON U.USER_ID = M.USER_ID
         WHERE M.USER_GR_ID IN ('DM Planner','DM Planner (W/S)','SCP Planner','DM ADMIN','ADMIN')
         ORDER BY M.USER_GR_ID, M.USER_ID""")

    # 4) 배치 JOB 전문
    out["jobs"] = rows(cur, """
        SELECT JOB_NAME, ENABLED, REPEAT_INTERVAL, JOB_ACTION
          FROM ALL_SCHEDULER_JOBS
         WHERE OWNER='SCM_MGR'
           AND ( UPPER(JOB_NAME) LIKE '%MKT_FCST%' OR UPPER(JOB_NAME) LIKE '%SALES_PLAN%'
              OR UPPER(JOB_NAME) LIKE '%CUST_FCST%' OR UPPER(JOB_NAME) LIKE '%EDI%'
              OR UPPER(JOB_NAME) LIKE '%BIZ%' OR UPPER(JOB_NAME) LIKE '%BP_%' )
         ORDER BY JOB_NAME""")

    # 5) 화면 배선
    binds = {"s%d" % i: s for i, s in enumerate(SCREENS)}
    inlist = ",".join(":" + k for k in binds)
    out["wiring"] = rows(cur, """
        SELECT B.MNU_ID, B.SHT_NM, B.MNU_BTN_CD, A.API_URL
          FROM SCM_MGR.SCM_ADM_MNU_BTN_MPG_M B
          JOIN SCM_MGR.SCM_ADM_API_M A ON A.API_ID = B.API_ID
         WHERE B.USE_YN='Y' AND B.MNU_ID IN (%s)
         ORDER BY B.MNU_ID, B.SHT_NM, B.MNU_BTN_CD""" % inlist, **binds)

    # 6) 최신 버전
    out["versions"] = rows(cur, """
        SELECT DIVISION_ID, CUTOFF_TYPE, MAX(VERSION_NO) LATEST_VER,
               COUNT(DISTINCT VERSION_NO) VER_CNT
          FROM SCM_MGR.DM_PLN_CFM_MKT_DEMAND_PLAN_C
         GROUP BY DIVISION_ID, CUTOFF_TYPE ORDER BY DIVISION_ID, CUTOFF_TYPE""")

(D / "01_meta.json").write_text(json.dumps(out, ensure_ascii=False, indent=1, default=str),
                                encoding="utf-8")
print("\n수집 결과")
for k, v in out.items():
    if k != "meta":
        print("   {:14s} {:4d}".format(k, len(v)))
print("저장: 01_meta.json")
