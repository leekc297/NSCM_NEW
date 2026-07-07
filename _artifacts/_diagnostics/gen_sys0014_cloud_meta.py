#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""SYS0014 클라우드 이관 메타를 사내 DB 최종상태 기준 MERGE INTO(멱등)로 생성.
대상: SHEET_COLUMNS / MNU_M / MNU_BTN_MPG / USER_GR_MNU_BTN / API_M / PROC_M.
DATE 컬럼은 SYSDATE 로 치환(감사 타임스탬프). 출력 = 패키지 02_DB_META/."""
import os, pathlib
import oracledb

USER=os.environ['NSCM_ORA_USER']; DSN=os.environ['NSCM_ORA_DSN']; PWD=os.environ['NSCM_ORA_PASS']
OUT = pathlib.Path("C:/Projects/NSCM/_artifacts/_deploy_packages/SYS0014_CLOUD_20260626/02_DB_META")
OUT.mkdir(parents=True, exist_ok=True)
SCHEMA='SCM_MGR'

cn = oracledb.connect(user=USER, password=PWD, dsn=DSN); cur = cn.cursor()

def cols_of(table):
    cur.execute("""SELECT COLUMN_NAME, DATA_TYPE FROM USER_TAB_COLUMNS
                   WHERE TABLE_NAME=:t ORDER BY COLUMN_ID""", t=table)
    return cur.fetchall()

def lit(val, dtype):
    if dtype == 'DATE':
        return 'SYSDATE'
    if val is None:
        return f"CAST(NULL AS {'NUMBER' if dtype=='NUMBER' else 'VARCHAR2(4000)'})"
    if dtype == 'NUMBER':
        return f"CAST({val} AS NUMBER)"
    s = str(val).replace("'", "''")
    return f"CAST('{s}' AS VARCHAR2(4000))"

def gen_merge(table, key_cols, where, order_by, fname, title):
    cols = cols_of(table)                      # [(name, dtype)]
    names = [c[0] for c in cols]
    cur.execute(f"SELECT {','.join(names)} FROM {SCHEMA}.{table} WHERE {where} ORDER BY {order_by}")
    rows = cur.fetchall()
    src_lines = []
    for r in rows:
        vals = [f"{lit(r[i], cols[i][1])} {names[i]}" for i in range(len(names))]
        src_lines.append("  SELECT " + ", ".join(vals) + " FROM DUAL")
    src = "\n  UNION ALL\n".join(src_lines)
    on = " AND ".join([f"T.{k}=S.{k}" for k in key_cols])
    upd_cols = [n for n in names if n not in key_cols]
    upd = ", ".join([f"T.{n}=S.{n}" for n in upd_cols])
    ins_cols = ", ".join(names)
    ins_vals = ", ".join([f"S.{n}" for n in names])
    sql = f"""-- {title}
-- 사내 DB(SCM_MGR) 최종상태 기준 MERGE INTO (멱등 upsert). DATE=SYSDATE. 생성: gen_sys0014_cloud_meta.py
-- 대상행: {len(rows)} | KEY: {', '.join(key_cols)}
MERGE INTO {SCHEMA}.{table} T
USING (
{src}
) S
ON ({on})
WHEN MATCHED THEN UPDATE SET
  {upd}
WHEN NOT MATCHED THEN INSERT (
  {ins_cols}
) VALUES (
  {ins_vals}
);
COMMIT;
"""
    (OUT / fname).write_text(sql, encoding='utf-8')
    print(f"{fname}: {len(rows)} rows ({len(names)} cols)")

gen_merge('SCM_ADM_MNU_M', ['MNU_ID'], "MNU_ID='SYS0014'", "MNU_ID",
          '01_MNU_M.sql', 'SYS0014 메뉴 등록 (SCM_ADM_MNU_M)')
gen_merge('SCM_MST_SHEET_COLUMNS', ['PROGRAM_ID','SHEET_NAME','COLUMN_NAME'],
          "PROGRAM_ID='SYS0014'", "SHEET_NAME, SORT_ORDER_NO",
          '02_SHEET_COLUMNS.sql', 'SYS0014 화면 컬럼 메타 (SCM_MST_SHEET_COLUMNS) — 사용자 요청: MERGE INTO')
gen_merge('SCM_ADM_MNU_BTN_MPG_M', ['MNU_ID','SHT_NM','MNU_BTN_CD'],
          "MNU_ID='SYS0014'", "SHT_NM, MNU_BTN_CD",
          '03_MNU_BTN_MPG.sql', 'SYS0014 메뉴-버튼 매핑 (SCM_ADM_MNU_BTN_MPG_M)')
gen_merge('SCM_ADM_API_M', ['API_ID'], "API_ID LIKE '%SYS0014%'", "API_ID",
          '04_API_M.sql', 'SYS0014 API 메타 (SCM_ADM_API_M)')
gen_merge('SCM_ADM_PROC_M', ['PROC_NM','COL_NM','COL_TP_CD'],
          "PROC_NM LIKE '%SYS0014%'", "PROC_NM, COL_TP_CD, SORT_ORD",
          '05_PROC_M.sql', 'SYS0014 프로시저 메타 (SCM_ADM_PROC_M)')
gen_merge('SCM_ADM_USER_GR_MNU_BTN_MPG_M', ['USER_GR_ID','MNU_ID','SHT_NM','MNU_BTN_CD'],
          "MNU_ID='SYS0014'", "USER_GR_ID, SHT_NM, MNU_BTN_CD",
          '06_USER_GR_MNU_BTN.sql', 'SYS0014 그룹-버튼 권한 (SCM_ADM_USER_GR_MNU_BTN_MPG_M)')
print("DONE ->", OUT)
