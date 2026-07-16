#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
A3_dmf0003_masterchg_full_removal.py
===============================================================================
DMF0003 Master Change 버튼·기능 전체 삭제 (2026-07-13 사용자 명시 결정).

배경
  - MasterChgModal 은 SP 차단(38_*_BLOCKED_handoff.md)으로 shell 만 존재하던 기능.
  - 2026-07-13 사용자: "어떤 권한으로도 Master Change 버튼이 보이지 않는다.
    버튼·기능 전체 일괄 삭제" → FE 코드 삭제와 함께 사내 메타도 정리.

삭제 대상 (사내 Oracle SCM_MGR)
  1. SCM_ADM_MNU_BTN_MPG_M : MNU_ID='DMF0003' AND SHT_NM='Mkt Fcst' AND MNU_BTN_CD='MASTER_CHG'
  2. USER_GR 버튼 권한 테이블(존재 시) : 동일 버튼 grant 행
  3. SCM_ADM_API_M         : API_ID='DMF0003_main_MASTER_CHG'
  4. SCM_ADM_MSG_M         : MSG00653(모달 SP안내) + LBL00701(Master Change 라벨)
                             — FE 코드 사용처 0 확인(2026-07-13 grep) 후 dead meta 정리.

비삭제 (그대로 둠)
  - SP DMF0000_GET_MASTER_CHG_POPUP / DMF0003_SAVE_MKT_FCST_PK_DATA_UPDATE:
    AS-IS 이관 자산(다른 소비자 존재 가능) — 화면 기능 삭제와 무관하게 보존.
  - SHEET_COLUMNS 'SCM0002_MasterChgPopup' 19행: AS-IS 원본 메타 보존.

실행: python A3_dmf0003_masterchg_full_removal.py --apply   (없으면 dry-run)
"""
import sys

import oracledb

APPLY = "--apply" in sys.argv


def connect():
    last = None
    for kw in (dict(service_name="OCGSCMD_P01"), dict(sid="ESSCMD")):
        try:
            dsn = oracledb.makedsn(host="121.162.245.167", port=2521, **kw)
            return oracledb.connect(user="SCM_MGR", password="!SCMroqkf2026", dsn=dsn)
        except Exception as e:
            last = e
    raise last


conn = connect()
cur = conn.cursor()

# USER_GR 버튼 권한 테이블 실명 확인
cur.execute("""SELECT TABLE_NAME FROM USER_TABLES
 WHERE TABLE_NAME LIKE '%USER_GR%BTN%' OR TABLE_NAME LIKE '%BTN%USER_GR%'""")
gr_tables = [r[0] for r in cur.fetchall()]
print("USER_GR button grant tables:", gr_tables)

targets = [
    ("SCM_ADM_MNU_BTN_MPG_M",
     "MNU_ID='DMF0003' AND SHT_NM='Mkt Fcst' AND MNU_BTN_CD='MASTER_CHG'"),
    ("SCM_ADM_API_M", "API_ID='DMF0003_main_MASTER_CHG'"),
    ("SCM_ADM_MSG_M", "MSG_ID IN ('MSG00653','LBL00701')"),
]
for t in gr_tables:
    # 컬럼 구조 확인 후 조건 구성 (MNU_BTN_CD 보유 시)
    cur.execute("SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME=:t", t=t)
    cols = {r[0] for r in cur.fetchall()}
    if {"MNU_ID", "MNU_BTN_CD"} <= cols:
        cond = "MNU_ID='DMF0003' AND MNU_BTN_CD='MASTER_CHG'"
        if "SHT_NM" in cols:
            cond += " AND SHT_NM='Mkt Fcst'"
        targets.append((t, cond))

print(f"\n{'=' * 20} {'APPLY' if APPLY else 'DRY-RUN'} {'=' * 20}")
for table, cond in targets:
    cur.execute(f"SELECT COUNT(*) FROM {table} WHERE {cond}")
    before = cur.fetchone()[0]
    if APPLY and before > 0:
        cur.execute(f"DELETE FROM {table} WHERE {cond}")
    cur.execute(f"SELECT COUNT(*) FROM {table} WHERE {cond}")
    after = cur.fetchone()[0] if APPLY else before
    print(f"  {table:35} | before={before:2} | after={'-' if not APPLY else after}")

if APPLY:
    conn.commit()
    print("\nCOMMIT 완료")
else:
    conn.rollback()
    print("\ndry-run — 변경 없음. 적용: --apply")

cur.close()
conn.close()
