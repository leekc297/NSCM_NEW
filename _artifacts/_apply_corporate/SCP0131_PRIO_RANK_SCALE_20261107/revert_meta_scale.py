# -*- coding: utf-8 -*-
"""원복(2026-11-07 14:2x) — SCP0131 PRIO_RANK DATA_SCALE_NUMBER '0' → NULL.
사유: chain6b CheckList v7(11:28 실측) D1 V-90126e36 '신규행 PRIO_RANK 편집기 생성 오류 — Wijmo Assertion: Number expected' · 컬럼 프로브 테스트 전체 중단(E7/E1/H13 ERROR).
      원인 = 공용 columnMapping.ts:94-101 이 scale 0 → InputNumber 편집기, 화면 editLock.ts:43 신규행 기본값 PRIO_RANK:'' (문자열) → InputNumber 가 숫자 아님을 거부.
      같은 scale 0 인 SCP0127 TYPE_APPLY_DAY 도 기본값 '' 이나 그 화면은 이번 실행에서 프로브 통과(원인 추가 확인 필요) — 어느 쪽이든 화면이 깨지므로 메타는 적용 전 값으로 되돌리고 FE 가이드(신규행 기본값 null + 메타 0)로 넘긴다.
절차: 현재값 '0' 확인·백업 → UPDATE → 재조회."""
import os, sys, csv, datetime
HERE = os.path.dirname(os.path.abspath(__file__)); ROOT = os.path.abspath(os.path.join(HERE, '..', '..', '..'))
sys.path.insert(0, os.path.join(ROOT, 'tools', 'DbConn')); import dbconn
KEY = "PROGRAM_ID='SCP0131' AND SHEET_NAME='Sales Site Priority' AND COLUMN_NAME='PRIO_RANK'"
SEL = f"SELECT PROGRAM_ID, SHEET_NAME, COLUMN_NAME, DATA_SCALE_NUMBER, LAST_UPDATED_BY, TO_CHAR(LAST_UPDATE_DATE,'YYYY-MM-DD HH24:MI:SS') FROM SCM_MGR.SCM_MST_SHEET_COLUMNS WHERE {KEY}"
UPD = f"UPDATE SCM_MGR.SCM_MST_SHEET_COLUMNS SET DATA_SCALE_NUMBER = NULL, LAST_UPDATED_BY = 'minyonglee1', LAST_UPDATE_DATE = SYSDATE WHERE {KEY} AND DATA_SCALE_NUMBER = 0"
cfg = dbconn.load_cfg(); print('DB:', dbconn.describe('tobe', cfg)); cx = dbconn.connect('tobe', cfg); cur = cx.cursor()
now = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
cur.execute(SEL); cols = [d[0] for d in cur.description]; rows = cur.fetchall(); print('before', rows)
with open(os.path.join(HERE, '00_BACKUP', 'sheet_columns_PRIO_RANK.before_revert.csv'), 'a', encoding='utf-8', newline='') as f:
    w = csv.writer(f); w.writerow(['fetched_at'] + cols); [w.writerow([now] + list(r)) for r in rows]
if len(rows) != 1 or str(rows[0][3]) != '0': print('[중단] 대상 1행·DATA_SCALE_NUMBER=0 이어야 함'); cx.rollback(); sys.exit(2)
cur.execute(UPD); print('UPDATE', cur.rowcount)
if cur.rowcount != 1: cx.rollback(); print('[중단] ROLLBACK'); sys.exit(2)
cx.commit(); cur.execute(SEL); after = cur.fetchall(); print('after', after)
open(os.path.join(HERE, 'APPLIED_OPERATIONS.md'), 'a', encoding='utf-8').write(f"\n## {now} 원복(ZIOUI1) — DATA_SCALE_NUMBER '0' → NULL\n- 사유: chain6b v7 D1 V-90126e36 신규행 PRIO_RANK 편집기 'Number expected' 오류(화면 editLock.ts:43 기본값 '' ↔ InputNumber) · 컬럼 프로브 중단\n- 전: {rows[0]} · 후: {after[0]}\n- 후속: FE 가이드 Doc/gen/SCP0131/H13_E1_FE_GUIDE.md §2 갱신(신규행 기본값 null + 메타 0 동시 적용) · 클라우드 패키지 30_META 에서 PRIO_RANK scale 제거\n")
