# -*- coding: utf-8 -*-
import oracledb
from ora import conn_info
u,p,d=conn_info()
cn=oracledb.connect(user=u,password=p,dsn=d); cur=cn.cursor()
cur.execute("ALTER SESSION SET NLS_DATE_FORMAT='YYYYMMDD'")
cur.execute("ALTER SESSION SET NLS_TIMESTAMP_FORMAT='YYYYMMDD HH24:MI:SS'")
IN=['40','ALL','ALL','ALL','20260101','20260731','ALL','','Current','N','minyonglee1','minyonglee1']
outs=[cn.cursor() for _ in range(6)]
cur.callproc("PKG_DMF0082.P_DMF0082_GET_MAIN_DATA", IN+outs)

def q(sql,label):
    cur.execute(sql); print(f"--- {label}"); 
    for r in cur.fetchall(): print("   ",r)

# LOC 날짜 span + 날짜당 행수
q("SELECT MIN(YYYYMMDD),MAX(YYYYMMDD),COUNT(DISTINCT YYYYMMDD) FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE WHERE MEASURE='LOC'","LOC date span (min/max/distinct-days)")
# LOC: distinct item-cell key vs rows
q("""SELECT COUNT(*) ROWS_, COUNT(DISTINCT ITEM_ID||'|'||SCM_SITE_ID||'|'||PLANT_SITE_ID||'|'||INCOTERMS||'|'||DOM_EXP||'|'||CELL_PROD_SITE_ID) KEYS,
       COUNT(DISTINCT ITEM_ID) ITEMS FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE WHERE MEASURE='LOC'""","LOC rows/keys/items")
# LOC per (key,date) 중복 — 팬아웃 판정
q("""SELECT dup, COUNT(*) FROM (
       SELECT ITEM_ID,SCM_SITE_ID,PLANT_SITE_ID,INCOTERMS,DOM_EXP,CELL_PROD_SITE_ID,YYYYMMDD, COUNT(*) dup
       FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE WHERE MEASURE='LOC'
       GROUP BY ITEM_ID,SCM_SITE_ID,PLANT_SITE_ID,INCOTERMS,DOM_EXP,CELL_PROD_SITE_ID,YYYYMMDD)
     GROUP BY dup ORDER BY dup""","LOC dup-per-(fullkey,date) histogram")
# SITE_ITEM 중복도 (4-key)
q("""SELECT dup,COUNT(*) FROM (
       SELECT DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID,COUNT(*) dup FROM SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM
       WHERE ITEM_VALID_YN='Y' GROUP BY DIVISION_ID,PROJECT_CODE,SCM_SITE_ID,ITEM_ID)
     GROUP BY dup ORDER BY dup""","SITE_ITEM rows-per-4key histogram (AS-IS 조인키)")
# 소스 SELLING_PRICE 자체 카디널리티 (div40, 범위내)
q("""SELECT MIN(YYYYMMDD),MAX(YYYYMMDD),COUNT(*),COUNT(DISTINCT YYYYMMDD)
     FROM SCM_MGR.DM_PLN_CFM_SELLING_PRICE WHERE DIVISION_ID='40' AND MEASURE='LOC' AND YYYYMMDD BETWEEN '20260101' AND '20260731'""","SRC SELLING_PRICE LOC (range full)")
cn.close()
