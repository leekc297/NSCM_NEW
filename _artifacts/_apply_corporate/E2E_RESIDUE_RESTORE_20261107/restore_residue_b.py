# -*- coding: utf-8 -*-
"""E2E 잔존 복원 2차(2026-11-07 14:1x) — chain6b SCP0084 F1(09:31:39) 가 저장한 MEMO '1' 을 AS-IS/원값 '' 로 복원.
근거: diff/P_SCP0084_GET_LONG_TERM_STOCK__1.csv  key 40|AZ00|AJRJR1212A|GRM01|202609|DUMMY MEMO AS-IS '' ↔ TO-BE '1' · 테이블 조회 14:11 UPDATE_DATE 20261107 093139 UPDATE_USER_ID minyonglee1
안전: 현재값이 기대값('1')일 때만 1행 UPDATE · 전/후 조회 기록 · 1행 아니면 ROLLBACK"""
import os, sys, datetime, csv
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); import dbconn
KEY = "YYYYMM='202609' AND PLANT_ID='AZ00' AND DIVISION_ID='40' AND ITEM_ID='AJRJR1212A' AND CHARG='DUMMY' AND DEVALUATION_AGE='GRM01'"
SEL = f"SELECT YYYYMM, PLANT_ID, DIVISION_ID, ITEM_ID, CHARG, DEVALUATION_AGE, MEMO, UPDATE_DATE, UPDATE_TIME, UPDATE_USER_ID FROM SCM_MGR.SCP_ANL_LONG_TERM_STOCK WHERE {KEY}"
UPD = f"UPDATE SCM_MGR.SCP_ANL_LONG_TERM_STOCK SET MEMO = NULL WHERE {KEY} AND MEMO = '1'"
cfg = dbconn.load_cfg(); print('DB:', dbconn.describe('tobe', cfg)); cx = dbconn.connect('tobe', cfg); cur = cx.cursor()
now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
cur.execute(SEL); cols = [d[0] for d in cur.description]; before = cur.fetchall(); print('before', before)
os.makedirs(os.path.join(HERE, '00_BACKUP'), exist_ok=True)
with open(os.path.join(HERE, '00_BACKUP', 'SCP_ANL_LONG_TERM_STOCK_MEMO_b.before.csv'), 'a', encoding='utf-8', newline='') as f:
    w = csv.writer(f); w.writerow(['fetched_at'] + cols); [w.writerow([now] + list(r)) for r in before]
if len(before) != 1 or (before[0][6] or '') != '1': print('[중단] 대상 1행·MEMO=1 이어야 함'); cx.rollback(); sys.exit(2)
cur.execute(UPD); print('UPDATE', cur.rowcount)
if cur.rowcount != 1: cx.rollback(); print('[중단] 1행 아님 → ROLLBACK'); sys.exit(2)
cx.commit(); cur.execute(SEL); after = cur.fetchall(); print('after', after)
open(os.path.join(HERE, 'APPLIED_OPERATIONS.md'), 'a', encoding='utf-8').write(f"\n## {now} 2차 복원(ZIOUI1) — chain6b SCP0084 F1 잔존\n- SCP_ANL_LONG_TERM_STOCK {KEY}: MEMO '1' → NULL (AS-IS '' · 09:31:39 minyonglee1 E2E 저장분)\n- 전: {before[0]}\n- 후: {after[0]}\n- UPDATE_DATE/TIME/USER 는 SP 경로가 아니라 직접 UPDATE 라 변경하지 않음(원래 감사값 20261007 063628 RFC_GSCM_01 은 E2E 저장으로 이미 덮인 상태)\n")
