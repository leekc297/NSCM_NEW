#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""DMF0082_CLOUD_20260814 보강 — 누락 축 3종 추가.

누락 경위(2026-08-14): 델타 서베이를 테이블별로 손으로 나열하다 컬럼명 오류로 BTN 축이 조용히
스킵됐고, Excel 메타 2종은 아예 나열에서 빠졌다. 기계적 전수 스윕(`_dmf0082_missing_axis_sweep.py`)
으로 재도출한 결과 기준선 이후 변경 테이블 10개 중 **3개가 패키지에 없었다**:
  · SCM_ADM_MNU_BTN_MPG_M          (Excel Form 버튼 배선 — 08-13 22:00 신설)  ← 버튼 미표시 직접 원인
  · SCM_ADM_USER_GR_MNU_BTN_MPG_M  (그 버튼 권한 5그룹)
  · SCM_ADM_EXCEL_UPLOAD / SCM_ADM_EXCEL_COLUMNS (Excel Upload 헤더 매핑)
"""
import io, pathlib, sys
sys.path.insert(0, str(pathlib.Path(__file__).resolve().parent))
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8", errors="replace")

import oracledb
import build_cloud_packages_20260811 as G
from ora import conn_info

PKG = pathlib.Path(r"C:\Projects\NSCM\_artifacts\_deploy_packages\DMF0082_CLOUD_20260814\A_DB")
MENU = "DMF0082"

u, p, d = conn_info()
con = oracledb.connect(user=u, password=p, dsn=d)
cur = con.cursor()
cur.execute("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")
G.TS = cur.fetchone()[0]


def dump(table, keys, where, binds):
    cur.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' "
                "AND TABLE_NAME=:t ORDER BY COLUMN_ID", {"t": table})
    cols = [r[0] for r in cur.fetchall()]
    c2, rows = G.rows_of(cur, f"SELECT {', '.join(cols)} FROM SCM_MGR.{table} WHERE {where}", **binds)
    return G.merge_sql(f"SCM_MGR.{table}", keys, rows, c2), len(rows)


# ── 09 버튼 배선 + 권한 (DMF0082 전 행 전수) ─────────────────────────────
l1, n1 = dump("SCM_ADM_MNU_BTN_MPG_M",
              ["MNU_ID", "SHT_NM", "MNU_BTN_CD"], "MNU_ID = :m", {"m": MENU})
l2, n2 = dump("SCM_ADM_USER_GR_MNU_BTN_MPG_M",
              ["USER_GR_ID", "MNU_ID", "SHT_NM", "MNU_BTN_CD"], "MNU_ID = :m", {"m": MENU})
lines = ["-- ── ① 버튼 ↔ API 배선 (SCM_ADM_MNU_BTN_MPG_M) ──",
         "--   ⭐ 'FcstNPrice / FORM_DATA / DMF0082_GET_EXCEL_FORM' = 08-13 신설 = Excel Form 버튼.",
         "--      이 행이 없으면 FE `hasButton('FORM_DATA')` 가 false → 40 division 에서도 버튼 미표시.",
         ""] + l1 + ["", "-- ── ② 버튼 권한 (SCM_ADM_USER_GR_MNU_BTN_MPG_M) ──",
                     "--   배선만 있고 권한이 없으면 역시 버튼이 안 뜬다(둘 다 필요).", ""] + l2
G.write(PKG / "09_BTN_WIRING_SYNC.sql",
        f"DMF0082 버튼 배선 {n1}행 + 버튼 권한 {n2}행 (전수 MERGE)", lines)
print(f"[09] 배선 {n1}행 / 권한 {n2}행")

# ── 10 Excel 메타 ────────────────────────────────────────────────────────
cur.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' "
            "AND TABLE_NAME='SCM_ADM_EXCEL_UPLOAD' AND DATA_TYPE IN ('VARCHAR2','CHAR')")
eu_scols = [r[0] for r in cur.fetchall()]
eu_where = " OR ".join(f"{c} LIKE '%{MENU}%'" for c in eu_scols)
cur.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' "
            "AND TABLE_NAME='SCM_ADM_EXCEL_UPLOAD' AND COLUMN_NAME IN "
            "(SELECT COLUMN_NAME FROM ALL_CONS_COLUMNS cc JOIN ALL_CONSTRAINTS c "
            " ON c.CONSTRAINT_NAME=cc.CONSTRAINT_NAME AND c.OWNER=cc.OWNER "
            " WHERE c.OWNER='SCM_MGR' AND c.TABLE_NAME='SCM_ADM_EXCEL_UPLOAD' AND c.CONSTRAINT_TYPE='P') "
            "ORDER BY COLUMN_ID")
eu_keys = [r[0] for r in cur.fetchall()]
print(f"   EXCEL_UPLOAD PK = {eu_keys or '(PK 없음 — 전 컬럼 키 대체)'}")

l3, n3 = dump("SCM_ADM_EXCEL_UPLOAD", eu_keys or eu_scols[:2], eu_where, {})
cur.execute("SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE OWNER='SCM_MGR' "
            "AND TABLE_NAME='SCM_ADM_EXCEL_COLUMNS' AND DATA_TYPE IN ('VARCHAR2','CHAR')")
ec_scols = [r[0] for r in cur.fetchall()]
ec_where = " OR ".join(f"{c} LIKE '%{MENU}%'" for c in ec_scols)
cur.execute("SELECT COLUMN_NAME FROM ALL_CONS_COLUMNS cc JOIN ALL_CONSTRAINTS c "
            "ON c.CONSTRAINT_NAME=cc.CONSTRAINT_NAME AND c.OWNER=cc.OWNER "
            "WHERE c.OWNER='SCM_MGR' AND c.TABLE_NAME='SCM_ADM_EXCEL_COLUMNS' "
            "AND c.CONSTRAINT_TYPE='P' ORDER BY cc.POSITION")
ec_keys = [r[0] for r in cur.fetchall()]
l4, n4 = dump("SCM_ADM_EXCEL_COLUMNS", ec_keys or ec_scols[:2], ec_where, {})

G.write(PKG / "10_EXCEL_META_SYNC.sql",
        f"DMF0082 Excel 메타 — UPLOAD {n3}행 + COLUMNS {n4}행 (Excel Form/Upload 헤더 매핑)",
        ["-- ── ① SCM_ADM_EXCEL_UPLOAD ──", ""] + l3 +
        ["", "-- ── ② SCM_ADM_EXCEL_COLUMNS ──", ""] + l4)
print(f"[10] EXCEL_UPLOAD {n3}행 / EXCEL_COLUMNS {n4}행")

con.close()
