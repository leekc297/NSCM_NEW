#!/usr/bin/env python3
"""
gen_dmf0003_salessite_sync_sql.py — DMF0003 Sales Site AS-IS 정합 보완 SQL 생성기 (읽기 전용)

AS-IS(LGCE_SCMDEV MSSQL)와 TO-BE(사내 Oracle)를 읽어 아래 3본의 보완 SQL 파일을
_artifacts/_apply_corporate/ 에 생성한다. **DB 를 변경하지 않는다** (SELECT only).
실행은 별도로 `python ora.py exec <파일>` 로 수행 (사내 + 클라우드 QA/DEV 3곳).

  P1: SCM_MST_SITE(SALES).DEPT_ID AS-IS 동기화  — TO-BE 전부 NULL(이관 누락) 복원
  P3: SALES 사이트 델타 INSERT                  — 이관 스냅샷 이후 AS-IS 신규분 (INSERT-only)
  P4: JV Planner 사용자 UNIT_AUTH 보완           — AS-IS TB_FX(D∪J) 기준

접속: .env.asis (ASIS_DB_* / TOBE_DB_*)
"""
import sys, pathlib

sys.stdout.reconfigure(encoding="utf-8")
ROOT = pathlib.Path(__file__).resolve().parents[2]
env = {}
for line in (ROOT / ".env.asis").read_text().splitlines():
    if "=" in line and not line.strip().startswith("#"):
        k, v = line.split("=", 1)
        env[k.strip()] = v.strip()

import pyodbc, oracledb

ms = pyodbc.connect(
    f"DRIVER={{{env['ASIS_DB_DRIVER']}}};SERVER={env['ASIS_DB_HOST']},{env['ASIS_DB_PORT']};"
    f"DATABASE={env['ASIS_DB_NAME']};UID={env['ASIS_DB_USER']};PWD={env['ASIS_DB_PASS']}", timeout=15)
oc = oracledb.connect(user=env['TOBE_DB_USER'], password=env['TOBE_DB_PASS'],
                      dsn=f"{env['TOBE_DB_HOST']}:{env['TOBE_DB_PORT']}/{env['TOBE_DB_PDB']}")
mc, occ = ms.cursor(), oc.cursor()


def qm(sql, b=None):
    mc.execute(sql, b or []); return mc.fetchall()


def qo(sql, b=None):
    occ.execute(sql, b or []); return occ.fetchall()


esc = lambda v: str(v).replace("'", "''")
OUT = ROOT / "_artifacts" / "_apply_corporate"

HDR = """-- ⭐ 적용 대상 3곳 전부 실행 의무: ①사내 ②클라우드 QA ③클라우드 DEV
-- (클라우드 DB 적용물은 QA·DEV 2군데 동시 적용 의무 — 2026-08-04 사용자 확정)
-- 정책: 멱등 / 감사컬럼 'admin' / AS-IS(LGCE_SCMDEV 2026-08-04 실측) 기준
"""

# ===== P1: SALES SITE DEPT_ID 동기화 =====
rows = qm("SELECT DIVISION_ID, SCM_SITE_ID, DEPT_ID FROM SCM_MST_SITE WITH(NOLOCK) "
          "WHERE SITE_TYPE='SALES' AND ISNULL(DEPT_ID,'') <> ''")
tobe_keys = set((r[0], r[1]) for r in qo("SELECT DIVISION_ID, SCM_SITE_ID FROM SCM_MST_SITE WHERE SITE_TYPE='SALES'"))
upd = [(d, s, dept) for d, s, dept in rows if (d, s) in tobe_keys]
p1 = OUT / "DMF0003_P1_SITE_DEPT_ID_SYNC_20260804.sql"
with open(p1, "w", encoding="utf-8") as f:
    f.write("-- DMF0003_P1_SITE_DEPT_ID_SYNC_20260804.sql\n")
    f.write("-- 목적: SCM_MST_SITE(SALES).DEPT_ID AS-IS 동기화 — TO-BE 전부 NULL(이관 누락)\n")
    f.write("--       → 셀 콤보 부서제약(SiteByEndCustomerAuth, AS-IS UP_FX_GetCommonDataList L13026) 데이터 기반 복원\n")
    f.write(HDR)
    f.write(f"-- 대상 {len(upd)}건 (AS-IS DEPT_ID 보유 SALES ∩ TO-BE 존재키). 멱등: 값 불일치/NULL 만 갱신.\n\n")
    for d, s, dept in upd:
        f.write(f"UPDATE SCM_MGR.SCM_MST_SITE SET DEPT_ID='{esc(dept)}', LAST_UPDATED_BY='admin', LAST_UPDATE_DATE=SYSDATE "
                f"WHERE DIVISION_ID='{esc(d)}' AND SCM_SITE_ID='{esc(s)}' AND SITE_TYPE='SALES' "
                f"AND (DEPT_ID IS NULL OR DEPT_ID <> '{esc(dept)}');\n")
    f.write("\nCOMMIT;\n-- 검증: SELECT COUNT(*), COUNT(DEPT_ID) FROM SCM_MGR.SCM_MST_SITE WHERE SITE_TYPE='SALES';\n")
print(f"P1 생성: {p1.name} — {len(upd)}건")

# ===== P3: SALES 델타 INSERT =====
ms_cols = [r[0] for r in qm("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME='SCM_MST_SITE'")]
ora_meta = {r[0]: (r[1], r[2]) for r in qo(
    "SELECT COLUMN_NAME, DATA_TYPE, NULLABLE FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' AND TABLE_NAME='SCM_MST_SITE'")}
AUDIT = ('CREATED_BY', 'CREATION_DATE', 'LAST_UPDATED_BY', 'LAST_UPDATE_DATE')
common = [c for c in ora_meta if c in ms_cols and c not in AUDIT]
sa = set((r[0], r[1]) for r in qm("SELECT DIVISION_ID, SCM_SITE_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SITE_TYPE='SALES' AND VALID_YN='Y'"))
sb = set((r[0], r[1]) for r in qo("SELECT DIVISION_ID, SCM_SITE_ID FROM SCM_MST_SITE WHERE SITE_TYPE='SALES' AND VALID_YN='Y'"))
missing = sorted(sa - sb)
collist = ", ".join(common)
p3 = OUT / "DMF0003_P3_SITE_DELTA_INSERT_20260804.sql"
n = 0
with open(p3, "w", encoding="utf-8") as f:
    f.write("-- DMF0003_P3_SITE_DELTA_INSERT_20260804.sql\n")
    f.write("-- 목적: 이관 스냅샷 이후 AS-IS 신규 SALES 사이트(VALID_YN='Y') 델타 INSERT — Sales Site 콤보 AS-IS 정합\n")
    f.write("-- 사유: 원천 드리프트 = 이관 시점 이후 AS-IS 변경분 미반영\n")
    f.write("--       (공통행 END_CUSTOMER/SITE_DESCRIPTION drift 0건 실측 — 차이는 순수 신규분)\n")
    f.write(HDR)
    f.write(f"-- 대상 {len(missing)}건 / INSERT-only(NOT EXISTS) — TO-BE에만 있는 19건은 삭제하지 않음(별도 보고)\n\n")
    for d, s in missing:
        mc.execute(f"SELECT {collist} FROM SCM_MST_SITE WITH(NOLOCK) WHERE DIVISION_ID=? AND SCM_SITE_ID=?", [d, s])
        row = mc.fetchone()
        if row is None:
            continue
        vals = []
        for cname, v in zip(common, row):
            dtype, nullable = ora_meta[cname]
            if v is None:
                if nullable == 'N':
                    vals.append("'-'" if dtype.startswith('VARCHAR') or dtype == 'CHAR' else "0")
                else:
                    vals.append("NULL")
            elif dtype in ('NUMBER', 'FLOAT'):
                vals.append(str(v))
            elif dtype == 'DATE':
                vals.append(f"TO_DATE('{str(v)[:19]}','YYYY-MM-DD HH24:MI:SS')")
            else:
                vals.append(f"'{esc(v)}'")
        f.write(f"INSERT INTO SCM_MGR.SCM_MST_SITE ({collist}, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)\n"
                f"SELECT {', '.join(vals)}, 'admin', SYSDATE, 'admin', SYSDATE FROM DUAL\n"
                f"WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_MST_SITE X "
                f"WHERE X.DIVISION_ID='{esc(d)}' AND X.SCM_SITE_ID='{esc(s)}');\n")
        n += 1
    f.write("\nCOMMIT;\n-- 검증: SELECT DIVISION_ID, COUNT(*) FROM SCM_MGR.SCM_MST_SITE WHERE SITE_TYPE='SALES' AND VALID_YN='Y' GROUP BY DIVISION_ID;\n")
    f.write(f"-- 원복: 본 파일의 {n}개 키를 CREATED_BY='admin' 조건과 함께 DELETE\n")
print(f"P3 생성: {p3.name} — {n}건 / 공통컬럼 {len(common)}개")

# ===== P4: JV Planner UNIT_AUTH =====
conv = qo("SELECT EDIT_YN, COUNT(*) FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M "
          "WHERE USER_GR_ID='JV Planner' AND UNIT_TP_CD='D' GROUP BY EDIT_YN")
print("기존 JV Planner UNIT_AUTH EDIT_YN 관례:", conv)
edit_yn = conv[0][0] if len(conv) == 1 else 'N'
jrows = qm("SELECT DISTINCT UserID, CODE FROM TB_FX_UserGroupAuthExtention WITH(NOLOCK) "
           "WHERE UserID IN (SELECT DISTINCT UserID FROM TB_FX_UserGroupAuthExtention WITH(NOLOCK) WHERE AuthType='J') "
           "AND AuthType IN ('D','J') ORDER BY UserID, CODE")
p4 = OUT / "DMF0003_P4_JV_UNIT_AUTH_20260804.sql"
with open(p4, "w", encoding="utf-8") as f:
    f.write("-- DMF0003_P4_JV_UNIT_AUTH_20260804.sql\n")
    f.write("-- 목적: JV Planner 사용자 UNIT_AUTH(division) 미이관 보완 — Sales Site 콤보 권한(AS-IS TB_FX AuthType D∪J) 정합\n")
    f.write(f"-- EDIT_YN='{edit_yn}' (기존 JV Planner 그룹 관례 {conv} — 관례 부재 시 보수 'N'), UPPR_UNIT_ID='-'\n")
    f.write(HDR + "\n")
    for u, code in jrows:
        f.write(f"INSERT INTO SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M "
                f"(USER_GR_ID, USER_ID, UNIT_TP_CD, UNIT_ID, UPPR_UNIT_ID, EDIT_YN, USE_YN, "
                f"CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE)\n"
                f"SELECT 'JV Planner', '{esc(u)}', 'D', '{esc(code)}', '-', '{edit_yn}', 'Y', "
                f"'admin', SYSDATE, 'admin', SYSDATE FROM DUAL\n"
                f"WHERE NOT EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M X "
                f"WHERE X.USER_ID='{esc(u)}' AND X.UNIT_TP_CD='D' AND X.UNIT_ID='{esc(code)}');\n")
    f.write("\nCOMMIT;\n-- 검증: SELECT USER_ID, COUNT(*) FROM SCM_MGR.SCM_ADM_USER_GR_UNIT_AUTH_MPG_M WHERE USER_GR_ID='JV Planner' GROUP BY USER_ID;\n")
print(f"P4 생성: {p4.name} — {len(jrows)}건 (EDIT_YN={edit_yn})")
ms.close(); oc.close()
