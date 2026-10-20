# -*- coding: utf-8 -*-
"""SCP0096 보완(2026-10-20) 착수 재조회 — hook #152 (DB 최신 원문 기준). 읽기 전용.
  1) PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD 원문(ALL_SOURCE) + LAST_DDL   ← 초기기간(dayRange) 등가 보완 원천
  2) 그 SP 를 FE 실전송값으로 실행(divisionId='40', planCycle='DAILY', fromDate='', offsetMonth='12', timeZone='')  ← o_rc1 컬럼/값
  3) SCP0096 사내 메타 현재값: MNU_BTN_MPG_M / API_M / PROC_M(PKG_SCP0096.*) / SHEET_COLUMNS / USER_GR_MNU_MPG_M  ← registration.sql 미러 원천
  4) PKG_SCP0096 LAST_DDL (10-19 22:53 적용본 유지 여부)
"""
import sys, os, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8', errors='replace')
sys.path.insert(0, r'C:\Projects\NSCM\tools\DbConn')
import dbconn, oracledb

cx = dbconn.connect('tobe')
cur = cx.cursor()

def q(sql, **b):
    cur.execute(sql, b); return cur.fetchall()

print('## 조회 DB:', dbconn.describe('tobe'))
print('## 조회시각:', q("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') FROM DUAL")[0][0])

print('\n## 4) PKG_SCP0096 / PKG_COM0000 LAST_DDL')
for r in q("""SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME,'YYYY-MM-DD HH24:MI:SS')
              FROM ALL_OBJECTS WHERE OWNER='SCM_MGR' AND OBJECT_NAME IN ('PKG_SCP0096','PKG_COM0000') ORDER BY 1,2"""):
    print('  ', r)

print('\n## 1) P_SCM0001_GET_SCP_MONTH_PERIOD 원문 (PKG_COM0000 BODY 발췌)')
src = q("""SELECT LINE, TEXT FROM ALL_SOURCE WHERE OWNER='SCM_MGR' AND NAME='PKG_COM0000' AND TYPE='PACKAGE BODY' ORDER BY LINE""")
start = None
for i, (ln, tx) in enumerate(src):
    if start is None and 'PROCEDURE' in tx.upper() and 'P_SCM0001_GET_SCP_MONTH_PERIOD' in tx.upper():
        start = i
    elif start is not None and i > start and 'END P_SCM0001_GET_SCP_MONTH_PERIOD' in tx.upper():
        for ln2, tx2 in src[start:i + 1]:
            print(f'{ln2:5d}: {tx2.rstrip()}')
        break
if start is None:
    print('  (원문 미발견)')

print('\n## 2) 실행 — FE 실전송값 (divisionId=40, planCycle=DAILY, fromDate="", offsetMonth=12, timeZone="")')
for tz in ['', 'Asia/Seoul']:
    o1 = cur.var(oracledb.DB_TYPE_CURSOR); o2 = cur.var(oracledb.DB_TYPE_CURSOR)
    try:
        cur.callproc('SCM_MGR.PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD', ['40', 'DAILY', '', '12', tz, o1, o2])
        c1 = o1.getvalue(); cols = [d[0] for d in c1.description]; rows = c1.fetchall()
        print(f'  timeZone={tz!r}: o_rc1 cols={cols} rows={rows[:3]} (n={len(rows)})')
        c2 = o2.getvalue(); print('    o_result_cursor:', [d[0] for d in c2.description], c2.fetchall()[:2])
    except Exception as e:
        print(f'  timeZone={tz!r}: ERROR', dbconn.mask(str(e)))
for div in ['81', '82']:
    o1 = cur.var(oracledb.DB_TYPE_CURSOR); o2 = cur.var(oracledb.DB_TYPE_CURSOR)
    try:
        cur.callproc('SCM_MGR.PKG_COM0000.P_SCM0001_GET_SCP_MONTH_PERIOD', [div, 'DAILY', '', '12', '', o1, o2])
        c1 = o1.getvalue(); print(f'  division={div}: ', c1.fetchall()[:2])
    except Exception as e:
        print(f'  division={div}: ERROR', dbconn.mask(str(e)))

print('\n## 3) SCP0096 사내 메타 현재값')
print('### MNU_BTN_MPG_M')
for r in q("SELECT SHT_NM, MNU_BTN_CD, API_ID, USE_YN FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SCP0096' ORDER BY 1,2"): print('  ', r)
print('### API_M (SCP0096 버튼이 참조하는 API_ID)')
for r in q("""SELECT API_ID, API_TP_CD, API_URL, USE_YN FROM SCM_ADM_API_M
              WHERE API_ID IN (SELECT API_ID FROM SCM_ADM_MNU_BTN_MPG_M WHERE MNU_ID='SCP0096') ORDER BY 1"""): print('  ', r)
print('### PROC_M PKG_SCP0096.* (행수)')
for r in q("SELECT PROC_NM, COUNT(*), LISTAGG(COL_NM, ',') WITHIN GROUP (ORDER BY SORT_ORD) FROM SCM_ADM_PROC_M WHERE PROC_NM LIKE 'PKG_SCP0096.%' GROUP BY PROC_NM ORDER BY 1"): print('  ', r)
print('### SHEET_COLUMNS SCP0096')
for r in q("""SELECT SHEET_NAME, COLUMN_NAME, COLUMN_LABEL_NAME, SORT_ORDER_NO, FIXED_FLAG, COLUMN_WIDTH, CELL_CONTROL_OBJECT_TYPE_CODE, CELL_COMBO_DATA_TYPE,
                     DATA_SCALE_NUMBER, HORIZONTAL_ALIGN_CODE, VISIBLE_FLAG, DEFAULT_FLAG, USER_SELECTABLE_FLAG, VALID_YN, DIVISION_ID, INPUT_TP_CD, LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI')
              FROM SCM_MST_SHEET_COLUMNS WHERE PROGRAM_ID='SCP0096' ORDER BY SORT_ORDER_NO"""): print('  ', r)
print('### USER_GR_MNU_MPG_M / USER_GR_MNU_BTN_MPG_M')
for r in q("SELECT USER_GR_ID, USE_YN FROM SCM_ADM_USER_GR_MNU_MPG_M WHERE MNU_ID='SCP0096' ORDER BY 1"): print('  ', r)
for r in q("SELECT USER_GR_ID, SHT_NM, MNU_BTN_CD, USE_YN FROM SCM_ADM_USER_GR_MNU_BTN_MPG_M WHERE MNU_ID='SCP0096' ORDER BY 1,2,3"): print('  ', r)
print('### MNU_M')
for r in q("SELECT MNU_ID, UPPR_MNU_ID, MNU_URL, MNU_MSG_ID, SORT_ORD, MNU_LV_NO, USE_YN, ROUTE_PATH FROM SCM_ADM_MNU_M WHERE MNU_ID='SCP0096'"): print('  ', r)
cx.rollback(); cx.close()
